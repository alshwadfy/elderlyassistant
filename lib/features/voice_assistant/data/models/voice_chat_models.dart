import '../data/models/voice_interaction_model.dart';
import '../../doctors/data/models/doctor_model.dart';

enum VoiceAssistantState { idle, listening, processing, speaking }

enum ChatBubbleKind { assistant, user, doctors }

class ChatBubble {
  const ChatBubble({
    required this.kind,
    required this.text,
    this.doctors = const [],
  });

  final ChatBubbleKind kind;
  final String text;
  final List<DoctorModel> doctors;
}

class VoiceAssistantStateData {
  VoiceAssistantStateData({
    required this.state,
    required this.history,
    this.currentTranscript = '',
    this.lastInteraction,
  });

  final VoiceAssistantState state;
  final List<ChatBubble> history;
  final String currentTranscript;
  final VoiceInteractionModel? lastInteraction;

  VoiceAssistantStateData copyWith({
    VoiceAssistantState? state,
    List<ChatBubble>? history,
    String? currentTranscript,
    VoiceInteractionModel? lastInteraction,
  }) {
    return VoiceAssistantStateData(
      state: state ?? this.state,
      history: history ?? this.history,
      currentTranscript: currentTranscript ?? this.currentTranscript,
      lastInteraction: lastInteraction ?? this.lastInteraction,
    );
  }
}
