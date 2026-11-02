import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/rafiq_api_service.dart';

class DailyCheckInState {
  const DailyCheckInState({
    this.mood = 'happy', // 'happy' | 'fine' | 'tired'
    this.tookMedicines = true,
    this.drankWater = true,
    this.movedToday = false,
    this.isSubmitting = false,
    this.lastSubmittedAt,
  });

  final String mood;
  final bool tookMedicines;
  final bool drankWater;
  final bool movedToday;
  final bool isSubmitting;
  final DateTime? lastSubmittedAt;

  DailyCheckInState copyWith({
    String? mood,
    bool? tookMedicines,
    bool? drankWater,
    bool? movedToday,
    bool? isSubmitting,
    DateTime? lastSubmittedAt,
  }) {
    return DailyCheckInState(
      mood: mood ?? this.mood,
      tookMedicines: tookMedicines ?? this.tookMedicines,
      drankWater: drankWater ?? this.drankWater,
      movedToday: movedToday ?? this.movedToday,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      lastSubmittedAt: lastSubmittedAt ?? this.lastSubmittedAt,
    );
  }
}

class DailyCheckInCubit extends Cubit<DailyCheckInState> {
  DailyCheckInCubit({RafiqApiService? apiService})
      : _api = apiService ?? RafiqApiService(),
        super(const DailyCheckInState());

  final RafiqApiService _api;

  void selectMood(String mood) {
    emit(state.copyWith(mood: mood));
  }

  void toggleMedicines() {
    emit(state.copyWith(tookMedicines: !state.tookMedicines));
  }

  void toggleWater() {
    emit(state.copyWith(drankWater: !state.drankWater));
  }

  void toggleMovement() {
    emit(state.copyWith(movedToday: !state.movedToday));
  }

  Future<bool> submitCheckIn() async {
    emit(state.copyWith(isSubmitting: true));
    final ok = await _api.submitDailyCheckIn(
      userId: 'user_01',
      mood: state.mood,
      tookMedicines: state.tookMedicines,
      drankWater: state.drankWater,
      movedToday: state.movedToday,
    );
    if (!isClosed) {
      emit(
        state.copyWith(
          isSubmitting: false,
          lastSubmittedAt: DateTime.now(),
        ),
      );
    }
    return ok;
  }
}

typedef DailyCheckInNotifier = DailyCheckInCubit;
