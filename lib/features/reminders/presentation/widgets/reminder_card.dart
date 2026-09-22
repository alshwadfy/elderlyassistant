import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/reminder_model.dart';

class ReminderCard extends StatelessWidget {
  const ReminderCard({
    super.key,
    required this.reminder,
    required this.onToggle,
  });

  final ReminderModel reminder;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = reminder.status == 'completed';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Icon Background
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.successContainer : AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                reminder.type == 'medication' ? Icons.medication_outlined : Icons.calendar_today_outlined,
                color: isCompleted ? AppColors.success : AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? AppColors.textSecondary : AppColors.textPrimary,
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        _formatTime(reminder.scheduledTime),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('•', style: TextStyle(color: AppColors.textSecondary)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          reminder.repeatPattern,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Toggle Checkbox
            Semantics(
              label: isCompleted ? 'Mark as pending' : 'Mark as completed',
              button: true,
              child: InkWell(
                onTap: onToggle,
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCompleted ? AppColors.success : AppColors.border,
                      width: 2,
                    ),
                    color: isCompleted ? AppColors.success : Colors.transparent,
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check, size: 20, color: AppColors.textLight)
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    // Simple 12-hour format for demo
    final hour = time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}
