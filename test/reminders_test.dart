import 'package:elderlyassistant/features/reminders/data/models/reminder_model.dart';
import 'package:elderlyassistant/features/reminders/providers/reminders_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RemindersNotifier', () {
    test('initial state contains skipped reminder', () {
      final notifier = RemindersNotifier();
      final hasSkipped = notifier.state.any((r) => r.status == 'skipped');
      expect(hasSkipped, isTrue);
    });

    test('addReminder appends new item', () {
      final notifier = RemindersNotifier();
      final initialCount = notifier.state.length;
      notifier.addReminder(
        ReminderModel(
          reminderId: 'rem_test',
          userId: 'user_01',
          type: 'medication',
          title: 'Test Remedy',
          scheduledTime: DateTime.now(),
          repeatPattern: '1 drop',
          status: 'pending',
        ),
      );
      expect(notifier.state.length, equals(initialCount + 1));
      expect(notifier.state.last.title, equals('Test Remedy'));
    });

    test('updateReminder updates existing reminder', () {
      final notifier = RemindersNotifier();
      final target = notifier.state.first;
      notifier.updateReminder(target.copyWith(title: 'Updated Medicine Name'));
      final updated = notifier.state.firstWhere((r) => r.reminderId == target.reminderId);
      expect(updated.title, equals('Updated Medicine Name'));
    });

    test('deleteReminder removes reminder by id', () {
      final notifier = RemindersNotifier();
      final targetId = notifier.state.first.reminderId;
      notifier.deleteReminder(targetId);
      final exists = notifier.state.any((r) => r.reminderId == targetId);
      expect(exists, isFalse);
    });
  });
}
