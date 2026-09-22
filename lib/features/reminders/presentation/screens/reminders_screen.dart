import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/demo_snackbar.dart';
import '../../data/models/reminder_model.dart';
import '../../providers/reminders_provider.dart';
import '../widgets/reminder_card.dart';

class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  Future<void> _addReminder(BuildContext context, WidgetRef ref) async {
    final titleController = TextEditingController();
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Reminder'),
          content: TextField(
            controller: titleController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'e.g. Evening vitamin',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (saved == true && titleController.text.trim().isNotEmpty) {
      ref.read(remindersProvider.notifier).addReminder(
            ReminderModel(
              reminderId: 'rem_${DateTime.now().millisecondsSinceEpoch}',
              userId: 'user_01',
              type: 'medication',
              title: titleController.text.trim(),
              scheduledTime: DateTime.now().add(const Duration(hours: 2)),
              repeatPattern: 'Custom reminder',
              status: 'pending',
            ),
          );
      if (context.mounted) {
        showDemoSnackBar(context, 'Reminder added (demo)');
      }
    }
    titleController.dispose();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminders = ref.watch(remindersProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.medication, color: AppColors.textLight),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Medication Reminders',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Today, 23 September\nHere are your upcoming medications:',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 20, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(
                  '${reminders.length} reminders scheduled for today',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                final reminder = reminders[index];
                return ReminderCard(
                  reminder: reminder,
                  accent: index == 0
                      ? AppColors.success
                      : index == 2
                          ? AppColors.warning
                          : AppColors.primary,
                  onToggle: () {
                    ref
                        .read(remindersProvider.notifier)
                        .toggleStatus(reminder.reminderId);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => _addReminder(context, ref),
            icon: const Icon(Icons.add),
            label: const Text('Add New Reminder'),
          ),
        ],
      ),
    );
  }
}
