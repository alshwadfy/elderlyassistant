import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../doctors/data/models/doctor_model.dart';
import '../../doctors/providers/doctors_provider.dart';
import '../data/models/voice_chat_models.dart';
import '../data/models/voice_interaction_model.dart';

export '../data/models/voice_chat_models.dart';

class VoiceAssistantNotifier extends StateNotifier<VoiceAssistantStateData> {
  VoiceAssistantNotifier()
      : super(
          VoiceAssistantStateData(
            state: VoiceAssistantState.idle,
            history: const [
              ChatBubble(
                kind: ChatBubbleKind.assistant,
                text: 'Hello Adel! How can I help you today?',
              ),
            ],
          ),
        );

  void startListening() {
    state = state.copyWith(
      state: VoiceAssistantState.listening,
      currentTranscript: 'Listening...',
    );
  }

  Future<void> stopListeningAndProcess(String samplePhrase) async {
    final userBubble = ChatBubble(kind: ChatBubbleKind.user, text: samplePhrase);
    state = state.copyWith(
      state: VoiceAssistantState.processing,
      currentTranscript: samplePhrase,
      history: [...state.history, userBubble],
    );

    await Future.delayed(const Duration(milliseconds: 700));

    String intent = 'GENERAL_QUESTION';
    String responseText = 'I am here to help. You can ask about reminders, doctors, or family.';
    List<DoctorModel> doctors = const [];

    final lower = samplePhrase.toLowerCase();
    if (lower.contains('دواء') || lower.contains('medicine') || lower.contains('remind')) {
      intent = 'CREATE_REMINDER';
      responseText = 'Medication reminder saved for this evening.';
    } else if (lower.contains('طبيب') ||
        lower.contains('دكتور') ||
        lower.contains('doctor')) {
      intent = 'FIND_DOCTOR';
      responseText = 'I found some doctors near you. Here are the top options:';
      doctors = DoctorsNotifier.mockDoctors.take(2).toList();
    } else if (lower.contains('طوارئ') ||
        lower.contains('help') ||
        lower.contains('emergency')) {
      intent = 'EMERGENCY';
      responseText = 'I can take you to Emergency Help. Use the Emergency card on Home if you need it now.';
    }

    final interaction = VoiceInteractionModel(
      interactionId: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'user_01',
      transcript: samplePhrase,
      detectedIntent: intent,
      responseText: responseText,
      timestamp: DateTime.now(),
    );

    final nextHistory = [
      ...state.history,
      ChatBubble(kind: ChatBubbleKind.assistant, text: responseText),
      if (doctors.isNotEmpty)
        ChatBubble(kind: ChatBubbleKind.doctors, text: '', doctors: doctors),
    ];

    state = state.copyWith(
      state: VoiceAssistantState.speaking,
      lastInteraction: interaction,
      history: nextHistory,
    );

    await Future.delayed(const Duration(milliseconds: 900));
    state = state.copyWith(state: VoiceAssistantState.idle);
  }
}

final voiceAssistantProvider =
    StateNotifierProvider.autoDispose<VoiceAssistantNotifier, VoiceAssistantStateData>(
  (ref) => VoiceAssistantNotifier(),
);
