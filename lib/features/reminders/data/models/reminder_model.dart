class ReminderModel {
  ReminderModel({
    required this.reminderId,
    required this.userId,
    required this.type,
    required this.title,
    required this.scheduledTime,
    required this.repeatPattern,
    required this.status,
  });

  final String reminderId;
  final String userId;
  final String type; // e.g. 'medication', 'appointment', 'general'
  final String title;
  final DateTime scheduledTime;
  final String repeatPattern;
  final String status; // 'pending', 'completed', 'missed'

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      reminderId: json['reminder_id'] ?? '',
      userId: json['user_id'] ?? '',
      type: json['type'] ?? 'medication',
      title: json['title'] ?? '',
      scheduledTime: json['scheduled_time'] != null
          ? DateTime.parse(json['scheduled_time'])
          : DateTime.now(),
      repeatPattern: json['repeat_pattern'] ?? 'daily',
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reminder_id': reminderId,
      'user_id': userId,
      'type': type,
      'title': title,
      'scheduled_time': scheduledTime.toIso8601String(),
      'repeat_pattern': repeatPattern,
      'status': status,
    };
  }

  ReminderModel copyWith({
    String? status,
  }) {
    return ReminderModel(
      reminderId: reminderId,
      userId: userId,
      type: type,
      title: title,
      scheduledTime: scheduledTime,
      repeatPattern: repeatPattern,
      status: status ?? this.status,
    );
  }
}
