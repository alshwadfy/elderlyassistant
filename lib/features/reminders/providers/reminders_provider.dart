import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/reminder_model.dart';

class RemindersNotifier extends StateNotifier<List<ReminderModel>> {
  RemindersNotifier() : super(_initialReminders);

  static final List<ReminderModel> _initialReminders = [
    ReminderModel(
      reminderId: 'rem_1',
      userId: 'user_01',
      type: 'medication',
      title: 'دواء ضغط الدم / Blood Pressure Meds',
      scheduledTime: DateTime.now().add(const Duration(hours: 1)),
      repeatPattern: 'يومياً الساعة 8:00 مساءً / Daily 8:00 PM',
      status: 'pending',
    ),
    ReminderModel(
      reminderId: 'rem_2',
      userId: 'user_01',
      type: 'medication',
      title: 'فيتامين د / Vitamin D',
      scheduledTime: DateTime.now().add(const Duration(hours: 3)),
      repeatPattern: 'يومياً الساعة 10:00 مساءً / Daily 10:00 PM',
      status: 'pending',
    ),
    ReminderModel(
      reminderId: 'rem_3',
      userId: 'user_01',
      type: 'appointment',
      title: 'استشارة طبيب القلب / Cardiology Doctor',
      scheduledTime: DateTime.now().add(const Duration(days: 1)),
      repeatPattern: 'مرة واحدة / Once',
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
    StateNotifierProvider.autoDispose<RemindersNotifier, List<ReminderModel>>((ref) {
  return RemindersNotifier();
});
