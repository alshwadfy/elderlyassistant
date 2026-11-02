import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/repositories/rafiq_repositories.dart';

enum ContactCallStatus { noAnswer, calling, waiting, connected }

/// Events for the Emergency SOS State Machine (`EmergencyBloc` — Sequence Diagram 3).
sealed class EmergencyEvent {
  const EmergencyEvent();
}

class EmergencySessionStarted extends EmergencyEvent {
  const EmergencySessionStarted();
}

class EmergencyCountdownTicked extends EmergencyEvent {
  const EmergencyCountdownTicked();
}

class EmergencyDispatchedImmediately extends EmergencyEvent {
  const EmergencyDispatchedImmediately();
}

class EmergencyEscalatedToNextContact extends EmergencyEvent {
  const EmergencyEscalatedToNextContact(this.totalContacts);
  final int totalContacts;
}

typedef EmergencyContactEscalated = EmergencyEscalatedToNextContact;

class EmergencyContactConnected extends EmergencyEvent {
  const EmergencyContactConnected({
    String? name,
    String? contactName,
    required this.index,
  }) : name = name ?? contactName ?? '';
  final String name;
  final int index;
}

class EmergencyCancelled extends EmergencyEvent {
  const EmergencyCancelled();
}

class EmergencyState {
  const EmergencyState({
    this.countdownSeconds = 15,
    this.isDispatched = false,
    this.isCancelled = false,
    this.eventId,
    this.sharedAddress = '١٤ شارع الجلاء، مصر الجديدة، القاهرة',
    this.activePriorityIndex = 1, // 0: Laila (no answer), 1: Omar (calling), 2: Hoda (waiting)
    this.connectedContactName,
  });

  final int countdownSeconds;
  final bool isDispatched;
  final bool isCancelled;
  final String? eventId;
  final String sharedAddress;
  final int activePriorityIndex;
  final String? connectedContactName;

  ContactCallStatus statusForIndex(int index) {
    if (connectedContactName != null && index == activePriorityIndex) {
      return ContactCallStatus.connected;
    }
    if (index < activePriorityIndex) {
      return ContactCallStatus.noAnswer;
    }
    if (index == activePriorityIndex) {
      return ContactCallStatus.calling;
    }
    return ContactCallStatus.waiting;
  }

  String statusLabelAr(int index) {
    return switch (statusForIndex(index)) {
      ContactCallStatus.noAnswer => 'لا يردّ',
      ContactCallStatus.calling => 'جارٍ الاتصال',
      ContactCallStatus.waiting => 'في الانتظار',
      ContactCallStatus.connected => 'تم الردّ ✓',
    };
  }

  EmergencyState copyWith({
    int? countdownSeconds,
    bool? isDispatched,
    bool? isCancelled,
    String? eventId,
    String? sharedAddress,
    int? activePriorityIndex,
    String? connectedContactName,
  }) {
    return EmergencyState(
      countdownSeconds: countdownSeconds ?? this.countdownSeconds,
      isDispatched: isDispatched ?? this.isDispatched,
      isCancelled: isCancelled ?? this.isCancelled,
      eventId: eventId ?? this.eventId,
      sharedAddress: sharedAddress ?? this.sharedAddress,
      activePriorityIndex: activePriorityIndex ?? this.activePriorityIndex,
      connectedContactName: connectedContactName ?? this.connectedContactName,
    );
  }
}

/// Event-Driven Finite State Machine (`Bloc`) for Sequence Diagram 3:
/// 15-second cancelable countdown (`مساعدة الطوارئ` `#2:562`) ->
/// Dispatches `POST /api/emergency/trigger` ->
/// Sequential priority family escalation (`المساعدة في الطريق` `#2:597`:
/// 1. ليلى `لا يردّ` -> 2. عمر `جارٍ الاتصال` -> 3. هدى `في الانتظار`).
///
/// Owns its countdown timer internally so the UI remains a pure StatelessWidget
/// and cancellation is race-condition-proof against in-flight network requests.
class EmergencyBloc extends Bloc<EmergencyEvent, EmergencyState> {
  EmergencyBloc({EmergencyRepository? repository})
      : _repository = repository ?? EmergencyRepository(),
        super(const EmergencyState()) {
    on<EmergencySessionStarted>(_onSessionStarted);
    on<EmergencyCountdownTicked>(_onCountdownTicked);
    on<EmergencyDispatchedImmediately>(_onDispatchedImmediately);
    on<EmergencyEscalatedToNextContact>(_onEscalated);
    on<EmergencyContactConnected>(_onContactConnected);
    on<EmergencyCancelled>(_onCancelled);
  }

  final EmergencyRepository _repository;
  Timer? _countdownTimer;

  void _startTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isClosed) {
        add(const EmergencyCountdownTicked());
      }
    });
  }

  void _onSessionStarted(
    EmergencySessionStarted event,
    Emitter<EmergencyState> emit,
  ) {
    emit(
      const EmergencyState(
        countdownSeconds: 15,
        isDispatched: false,
        isCancelled: false,
        activePriorityIndex: 1,
      ),
    );
    _startTimer();
  }

  void _onCountdownTicked(
    EmergencyCountdownTicked event,
    Emitter<EmergencyState> emit,
  ) {
    if (state.isDispatched || state.isCancelled) {
      _countdownTimer?.cancel();
      return;
    }
    if (state.countdownSeconds > 1) {
      emit(state.copyWith(countdownSeconds: state.countdownSeconds - 1));
    } else {
      add(const EmergencyDispatchedImmediately());
    }
  }

  Future<void> _onDispatchedImmediately(
    EmergencyDispatchedImmediately event,
    Emitter<EmergencyState> emit,
  ) async {
    _countdownTimer?.cancel();
    if (state.isDispatched) return;

    emit(
      state.copyWith(
        countdownSeconds: 0,
        isDispatched: true,
        isCancelled: false,
        activePriorityIndex: 1,
      ),
    );

    final eventId = await _repository.triggerEmergency(
      userId: 'user_01',
      lat: 30.0886,
      lng: 31.3219,
      address: state.sharedAddress,
    );

    // Guard against race condition if user cancelled while HTTP request was in flight
    if (!isClosed && !state.isCancelled) {
      emit(state.copyWith(eventId: eventId));
    }
  }

  void _onEscalated(
    EmergencyEscalatedToNextContact event,
    Emitter<EmergencyState> emit,
  ) {
    if (event.totalContacts <= 0) return;
    final next = (state.activePriorityIndex + 1) % event.totalContacts;
    emit(state.copyWith(activePriorityIndex: next));
  }

  void _onContactConnected(
    EmergencyContactConnected event,
    Emitter<EmergencyState> emit,
  ) {
    emit(
      state.copyWith(
        activePriorityIndex: event.index,
        connectedContactName: event.name,
      ),
    );
  }

  Future<void> _onCancelled(
    EmergencyCancelled event,
    Emitter<EmergencyState> emit,
  ) async {
    _countdownTimer?.cancel();
    final currentEventId = state.eventId;
    emit(
      state.copyWith(
        isCancelled: true,
        isDispatched: false,
        countdownSeconds: 15,
      ),
    );
    if (currentEventId != null) {
      await _repository.cancelEmergency(eventId: currentEventId);
    }
  }

  // Convenience methods for imperative callers
  void startNewSession() => add(const EmergencySessionStarted());
  void dispatchAlert() => add(const EmergencyDispatchedImmediately());
  void escalateToNextContact(int total) =>
      add(EmergencyEscalatedToNextContact(total));
  void markContactConnected(String name, int index) =>
      add(EmergencyContactConnected(name: name, index: index));
  Future<void> cancelAlert() async => add(const EmergencyCancelled());

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    return super.close();
  }
}

typedef EmergencyNotifier = EmergencyBloc;
