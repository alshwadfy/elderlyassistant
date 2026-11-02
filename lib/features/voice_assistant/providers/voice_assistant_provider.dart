import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/repositories/rafiq_repositories.dart';
import '../../../core/services/rafiq_api_service.dart';
import '../data/models/voice_chat_models.dart';
import '../data/models/voice_interaction_model.dart';

export '../data/models/voice_chat_models.dart';

/// Events for the 9-Step AI Voice Pipeline State Machine (`VoiceAssistantBloc`).
sealed class VoiceAssistantEvent {
  const VoiceAssistantEvent();
}

class VoiceListeningStarted extends VoiceAssistantEvent {
  const VoiceListeningStarted();
}

class VoiceListeningCancelled extends VoiceAssistantEvent {
  const VoiceListeningCancelled();
}

class VoiceCommandSubmitted extends VoiceAssistantEvent {
  const VoiceCommandSubmitted(
    this.spokenText, {
    this.voicePersona = 'warm',
    this.speechRate = 1.0,
  });

  final String spokenText;
  final String voicePersona;
  final double speechRate;
}

/// Event-Driven Finite State Machine (`Bloc`) for Sequence Diagrams 1 & 2:
/// `Idle -> Listening -> Processing (FastAPI NLU) -> Repository Execution -> Speaking -> Idle`.
///
/// Key Senior Engineering guarantees:
/// 1. **Tremor / Multi-Tap Protection**: Drops duplicate `VoiceCommandSubmitted`
///    events while `state.state == VoiceAssistantState.processing`.
/// 2. **Zero Controller Coupling**: Updates medications through `MedicationRepository`
///    instead of holding a reference to `RemindersCubit`.
class VoiceAssistantBloc
    extends Bloc<VoiceAssistantEvent, VoiceAssistantStateData> {
  VoiceAssistantBloc({
    RafiqApiService? apiService,
    required MedicationRepository medicationRepository,
  })  : _api = apiService ?? RafiqApiService(),
        _medicationRepository = medicationRepository,
        super(
          VoiceAssistantStateData(
            state: VoiceAssistantState.idle,
            history: const [
              ChatBubble(
                kind: ChatBubbleKind.assistant,
                text: 'صباح الخير يا عادل! هل أخذت حبة الضغط؟',
              ),
              ChatBubble(
                kind: ChatBubbleKind.user,
                text: '«نعم، أخذتها الآن مع الفطور.»',
              ),
              ChatBubble(
                kind: ChatBubbleKind.doseLogged,
                badgeTitle: '✓ سُجّلت الجرعة',
                text: 'رائع! جرعتك القادمة الساعة ٢:٠٠ م.',
              ),
            ],
          ),
        ) {
    on<VoiceListeningStarted>(_onListeningStarted);
    on<VoiceListeningCancelled>(_onListeningCancelled);
    on<VoiceCommandSubmitted>(_onCommandSubmitted);
  }

  final RafiqApiService _api;
  final MedicationRepository _medicationRepository;

  void _onListeningStarted(
    VoiceListeningStarted event,
    Emitter<VoiceAssistantStateData> emit,
  ) {
    emit(
      state.copyWith(
        state: VoiceAssistantState.listening,
        currentTranscript: 'جارٍ الاستماع… تحدث الآن',
      ),
    );
  }

  void _onListeningCancelled(
    VoiceListeningCancelled event,
    Emitter<VoiceAssistantStateData> emit,
  ) {
    emit(
      state.copyWith(
        state: VoiceAssistantState.idle,
        currentTranscript: '',
      ),
    );
  }

  Future<void> _onCommandSubmitted(
    VoiceCommandSubmitted event,
    Emitter<VoiceAssistantStateData> emit,
  ) async {
    // Tremor / double-tap guard: ignore duplicate commands while processing
    if (state.state == VoiceAssistantState.processing) return;

    final formattedUserText = event.spokenText.startsWith('«')
        ? event.spokenText
        : '«${event.spokenText}»';
    final updatedWithUser = [
      ...state.history,
      ChatBubble(kind: ChatBubbleKind.user, text: formattedUserText),
    ];

    emit(
      state.copyWith(
        state: VoiceAssistantState.processing,
        currentTranscript: event.spokenText,
        history: updatedWithUser,
      ),
    );

    final aiResult = await _api.processVoiceInteraction(
      userId: 'user_01',
      spokenText: event.spokenText,
      voicePersona: event.voicePersona,
      speechRate: event.speechRate,
    );

    if (isClosed) return;

    final newBubbles = <ChatBubble>[...updatedWithUser];

    if (aiResult.intent == 'LOG_DOSE' || aiResult.doseLogged) {
      // Mutates canonical MedicationRepository; RemindersCubit updates reactively via Stream!
      final medTitle = _medicationRepository.logDoseByMedicationName(
        aiResult.medicationName,
      );
      newBubbles.add(
        ChatBubble(
          kind: ChatBubbleKind.doseLogged,
          badgeTitle: '✓ سُجّلت الجرعة ($medTitle)',
          text: aiResult.responseText,
        ),
      );
    } else if (aiResult.intent == 'FIND_HOSPITAL' ||
        aiResult.intent == 'FIND_DOCTOR') {
      newBubbles.add(
        ChatBubble(
          kind: ChatBubbleKind.assistant,
          text: aiResult.responseText,
        ),
      );
      newBubbles.add(
        ChatBubble(
          kind: ChatBubbleKind.doctors,
          text: 'المستشفيات القريبة منك',
          doctors: HealthcareRepository.initialHospitals,
        ),
      );
    } else if (aiResult.intent == 'CALL_FAMILY') {
      newBubbles.add(
        ChatBubble(
          kind: ChatBubbleKind.familyCall,
          badgeTitle: '📞 اتصال بالعائلة · ليلى (الابنة)',
          text: aiResult.responseText,
        ),
      );
    } else {
      newBubbles.add(
        ChatBubble(
          kind: ChatBubbleKind.assistant,
          text: aiResult.responseText,
        ),
      );
    }

    final interaction = VoiceInteractionModel(
      interactionId: 'int_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'user_01',
      transcript: event.spokenText,
      detectedIntent: aiResult.intent,
      responseText: aiResult.responseText,
      timestamp: DateTime.now(),
    );

    emit(
      state.copyWith(
        state: VoiceAssistantState.speaking,
        history: newBubbles,
        lastInteraction: interaction,
      ),
    );

    await Future.delayed(const Duration(milliseconds: 900));
    if (!isClosed) {
      emit(state.copyWith(state: VoiceAssistantState.idle));
    }
  }

  // Convenience dispatchers
  void startListening() => add(const VoiceListeningStarted());
  void cancelListening() => add(const VoiceListeningCancelled());
  void simulateUserCommand(
    String spokenText, {
    String voicePersona = 'warm',
    double speechRate = 1.0,
  }) =>
      add(
        VoiceCommandSubmitted(
          spokenText,
          voicePersona: voicePersona,
          speechRate: speechRate,
        ),
      );
}

typedef VoiceAssistantNotifier = VoiceAssistantBloc;
