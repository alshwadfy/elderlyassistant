import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/reminder_model.dart';

class RemindersNotifier extends StateNotifier<List<ReminderModel>> {
  RemindersNotifier() : super(_initialReminders);

  static final List<ReminderModel> _initialReminders = [
    ReminderModel(
      reminderId: 'rem_1',
      userId: 'user_01',
      type: 'medication',
      title: 'Blood Pressure Medicine (Amlodipine)',
      scheduledTime: DateTime(2026, 9, 23, 8, 0),
      repeatPattern: 'Daily • Morning',
      status: 'completed',
      dosage: '1 Tablet (5mg)',
      instructions: 'Take after breakfast with a full glass of water',
      durationDays: 30,
      startDate: DateTime(2026, 9, 10),
    ),
    ReminderModel(
      reminderId: 'rem_2',
      userId: 'user_01',
      type: 'medication',
      title: 'Diabetes Medication (Metformin)',
      scheduledTime: DateTime(2026, 9, 23, 13, 0),
      repeatPattern: 'Daily • Afternoon',
      status: 'pending',
      dosage: '1 Tablet (500mg)',
      instructions: 'Take in the middle of lunch meal',
      durationDays: 14,
      startDate: DateTime(2026, 9, 18),
    ),
    ReminderModel(
      reminderId: 'rem_3',
      userId: 'user_01',
      type: 'medication',
      title: 'Calcium & Vitamin D3',
      scheduledTime: DateTime(2026, 9, 23, 17, 30),
      repeatPattern: 'Daily • Evening',
      status: 'pending',
      dosage: '1 Softgel',
      instructions: 'Take after evening tea',
      durationDays: 60,
      startDate: DateTime(2026, 9, 1),
    ),
    ReminderModel(
      reminderId: 'rem_4',
      userId: 'user_01',
      type: 'medication',
      title: 'Eye Drops (Latanoprost)',
      scheduledTime: DateTime(2026, 9, 23, 21, 0),
      repeatPattern: 'Daily • Night',
      status: 'skipped',
      dosage: '1 Drop in each eye',
      instructions: 'Apply right before bedtime',
      durationDays: 7,
      startDate: DateTime(2026, 9, 20),
    ),
  ];

  void toggleStatus(String reminderId) {
    state = [
      for (final rem in state)
        if (rem.reminderId == reminderId)
          rem.copyWith(
            status: rem.status == 'completed' ? 'pending' : 'completed',
            completedAt: rem.status == 'completed' ? null : DateTime.now(),
          )
        else
          rem,
    ];
  }

  void setStatus(String reminderId, String newStatus) {
    state = [
      for (final rem in state)
        if (rem.reminderId == reminderId)
          rem.copyWith(
            status: newStatus,
            completedAt: newStatus == 'completed' ? DateTime.now() : null,
          )
        else
          rem,
    ];
  }

  void addReminder(ReminderModel reminder) {
    state = [...state, reminder];
  }

  void updateReminder(ReminderModel updated) {
    state = [
      for (final rem in state)
        if (rem.reminderId == updated.reminderId) updated else rem,
    ];
  }

  void deleteReminder(String reminderId) {
    state = state.where((rem) => rem.reminderId != reminderId).toList();
  }
}

final remindersProvider =
    StateNotifierProvider<RemindersNotifier, List<ReminderModel>>((ref) {
  return RemindersNotifier();
});
