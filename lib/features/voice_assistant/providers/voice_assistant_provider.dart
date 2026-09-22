import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/voice_interaction_model.dart';

enum VoiceAssistantState { idle, listening, processing, speaking }

class VoiceAssistantStateData {
  VoiceAssistantStateData({
    required this.state,
    this.currentTranscript = '',
    this.lastInteraction,
  });

  final VoiceAssistantState state;
  final String currentTranscript;
  final VoiceInteractionModel? lastInteraction;

  VoiceAssistantStateData copyWith({
    VoiceAssistantState? state,
    String? currentTranscript,
    VoiceInteractionModel? lastInteraction,
  }) {
    return VoiceAssistantStateData(
      state: state ?? this.state,
      currentTranscript: currentTranscript ?? this.currentTranscript,
      lastInteraction: lastInteraction ?? this.lastInteraction,
    );
  }
}

class VoiceAssistantNotifier extends StateNotifier<VoiceAssistantStateData> {
  VoiceAssistantNotifier()
      : super(VoiceAssistantStateData(state: VoiceAssistantState.idle));

  void startListening() {
    state = state.copyWith(
      state: VoiceAssistantState.listening,
      currentTranscript: 'جاري الاستماع... / Listening...',
    );
  }

  void stopListeningAndProcess(String samplePhrase) async {
    state = state.copyWith(
      state: VoiceAssistantState.processing,
      currentTranscript: samplePhrase,
    );

    await Future.delayed(const Duration(milliseconds: 1200));

    // Map intent based on sample input
    String intent = 'GENERAL_QUESTION';
    String responseText = 'أنا هنا لمساعدتك. / I am here to help you.';

    if (samplePhrase.contains('دواء') || samplePhrase.contains('medicine') || samplePhrase.contains('remind')) {
      intent = 'CREATE_REMINDER';
      responseText = 'تم تسجيل تذكير الدواء بنجاح. / Medication reminder set.';
    } else if (samplePhrase.contains('طبيب') || samplePhrase.contains('دكتور') || samplePhrase.contains('doctor')) {
      intent = 'FIND_DOCTOR';
      responseText = 'وجدنا 3 أطباء بالقرب منك. / Found 3 doctors nearby.';
    } else if (samplePhrase.contains('طوارئ') || samplePhrase.contains('help') || samplePhrase.contains('emergency')) {
      intent = 'EMERGENCY';
      responseText = 'جاري الاتصال بالطوارئ واستدعاء المساعدة! / Triggering emergency call!';
    }

    final interaction = VoiceInteractionModel(
      interactionId: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'user_01',
      transcript: samplePhrase,
      detectedIntent: intent,
      responseText: responseText,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      state: VoiceAssistantState.speaking,
      lastInteraction: interaction,
    );

    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(state: VoiceAssistantState.idle);
  }
}

final voiceAssistantProvider =
    StateNotifierProvider.autoDispose<VoiceAssistantNotifier, VoiceAssistantStateData>((ref) {
  return VoiceAssistantNotifier();
});
