class VoiceInteractionModel {
  VoiceInteractionModel({
    required this.interactionId,
    required this.userId,
    required this.transcript,
    required this.detectedIntent,
    required this.responseText,
    required this.timestamp,
  });

  final String interactionId;
  final String userId;
  final String transcript;
  final String detectedIntent;
  final String responseText;
  final DateTime timestamp;

  factory VoiceInteractionModel.fromJson(Map<String, dynamic> json) {
    return VoiceInteractionModel(
      interactionId: json['interaction_id'] ?? '',
      userId: json['user_id'] ?? '',
      transcript: json['transcript'] ?? '',
      detectedIntent: json['detected_intent'] ?? 'UNKNOWN',
      responseText: json['response_text'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'interaction_id': interactionId,
      'user_id': userId,
      'transcript': transcript,
      'detected_intent': detectedIntent,
      'response_text': responseText,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
