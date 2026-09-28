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
    this.dosage,
    this.instructions,
    this.startDate,
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
  final String? dosage; // e.g. '1 Tablet', '2 Capsules'
  final String? instructions; // e.g. 'Take after breakfast with water'
  final DateTime? startDate; // Start date of treatment course

  int get currentDay {
    if (startDate == null) return 1;
    final diff = DateTime.now().difference(startDate!).inDays + 1;
    if (diff < 1) return 1;
    if (durationDays != null && diff > durationDays!) return durationDays!;
    return diff;
  }

  int? get daysRemaining {
    if (durationDays == null) return null;
    final remaining = durationDays! - currentDay + 1;
    return remaining < 0 ? 0 : remaining;
  }

  double get progressRatio {
    if (durationDays == null || durationDays == 0) return 1.0;
    final ratio = currentDay / durationDays!;
    return ratio > 1.0 ? 1.0 : (ratio < 0.0 ? 0.0 : ratio);
  }

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
      dosage: json['dosage'],
      instructions: json['instructions'],
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
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
      'dosage': dosage,
      'instructions': instructions,
      'start_date': startDate?.toIso8601String(),
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
    String? dosage,
    String? instructions,
    DateTime? startDate,
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
      dosage: dosage ?? this.dosage,
      instructions: instructions ?? this.instructions,
      startDate: startDate ?? this.startDate,
    );
  }
}
