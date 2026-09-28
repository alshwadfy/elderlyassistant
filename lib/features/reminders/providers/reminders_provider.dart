import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/reminder_model.dart';

class RemindersNotifier extends StateNotifier<List<ReminderModel>> {
  RemindersNotifier() : super(_initialReminders);

  static final List<ReminderModel> _initialReminders = [
    ReminderModel(
      reminderId: 'rem_1',
      userId: 'user_01',
      type: 'medication',
      title: 'Blood Pressure Medicine',
      scheduledTime: DateTime(2026, 9, 23, 8, 30),
      repeatPattern: '1 tablet • After breakfast',
      status: 'completed',
    ),
    ReminderModel(
      reminderId: 'rem_2',
      userId: 'user_01',
      type: 'medication',
      title: 'Vitamin D',
      scheduledTime: DateTime(2026, 9, 23, 13, 0),
      repeatPattern: '1 capsule • With lunch',
      status: 'pending',
    ),
    ReminderModel(
      reminderId: 'rem_3',
      userId: 'user_01',
      type: 'medication',
      title: 'Pain Relief (if needed)',
      scheduledTime: DateTime(2026, 9, 23, 20, 0),
      repeatPattern: '1 tablet • After dinner',
      status: 'pending',
    ),
    ReminderModel(
      reminderId: 'rem_4',
      userId: 'user_01',
      type: 'medication',
      title: 'Calcium Supplement',
      scheduledTime: DateTime(2026, 9, 23, 16, 0),
      repeatPattern: '1 tablet • Afternoon',
      status: 'skipped',
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
