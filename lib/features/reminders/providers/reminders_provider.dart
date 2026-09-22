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
  ];

  void toggleStatus(String reminderId) {
    state = [
      for (final rem in state)
        if (rem.reminderId == reminderId)
          rem.copyWith(
            status: rem.status == 'completed' ? 'pending' : 'completed',
          )
        else
          rem,
    ];
  }

  void addReminder(ReminderModel reminder) {
    state = [...state, reminder];
  }
}

final remindersProvider =
    StateNotifierProvider<RemindersNotifier, List<ReminderModel>>((ref) {
  return RemindersNotifier();
});
