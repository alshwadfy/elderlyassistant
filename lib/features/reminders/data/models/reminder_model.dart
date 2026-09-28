class ReminderModel {
  ReminderModel({
    required this.reminderId,
    required this.userId,
    required this.type,
    required this.title,
    required this.scheduledTime,
    required this.repeatPattern,
    required this.status,
    this.completedAt,
    this.durationDays,
  });

  final String reminderId;
  final String userId;
  final String type; // e.g. 'medication', 'appointment', 'general'
  final String title;
  final DateTime scheduledTime;
  final String repeatPattern;
  final String status; // 'pending', 'completed', 'missed', 'skipped'
  final DateTime? completedAt;
  final int? durationDays;

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
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      durationDays: json['duration_days'],
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
      'completed_at': completedAt?.toIso8601String(),
      'duration_days': durationDays,
    };
  }

  ReminderModel copyWith({
    String? reminderId,
    String? userId,
    String? type,
    String? title,
    DateTime? scheduledTime,
    String? repeatPattern,
    String? status,
    DateTime? completedAt,
    int? durationDays,
  }) {
    return ReminderModel(
      reminderId: reminderId ?? this.reminderId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      repeatPattern: repeatPattern ?? this.repeatPattern,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
      durationDays: durationDays ?? this.durationDays,
    );
  }
}
