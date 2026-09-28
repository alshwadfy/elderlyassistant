import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/reminder_model.dart';

class ReminderCard extends StatelessWidget {
  const ReminderCard({
    super.key,
    required this.reminder,
    required this.onToggle,
    this.onEdit,
    this.onDelete,
    this.accent = AppColors.primary,
  });

  final ReminderModel reminder;
  final VoidCallback onToggle;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = reminder.status == 'completed';
    final bool isSkipped = reminder.status == 'skipped';

    final Color cardAccent = isCompleted
        ? AppColors.success
        : isSkipped
            ? AppColors.warning
            : accent;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                // Icon Background
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.successContainer
                        : isSkipped
                            ? AppColors.warningContainer
                            : accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isSkipped ? Icons.do_not_disturb_on_outlined : Icons.medication_outlined,
                    color: cardAccent,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              reminder.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isCompleted || isSkipped
                                    ? AppColors.textSecondary
                                    : AppColors.textPrimary,
                                decoration: isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                          _StatusBadge(status: reminder.status),
                        ],
                      ),
                      const SizedBox(height: 6),
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
                          const Text('•', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              reminder.repeatPattern,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
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
                const SizedBox(width: 8),
                // Checkbox / Toggle
                Semantics(
                  label: isCompleted
                      ? 'Mark as pending'
                      : 'Mark as completed',
                  button: true,
                  child: InkWell(
                    onTap: onToggle,
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCompleted
                              ? AppColors.success
                              : isSkipped
                                  ? AppColors.warning
                                  : AppColors.border,
                          width: 2,
                        ),
                        color: isCompleted
                            ? AppColors.success
                            : isSkipped
                                ? AppColors.warningContainer
                                : Colors.transparent,
                      ),
                      child: isCompleted
                          ? const Icon(Icons.check, size: 22, color: AppColors.textLight)
                          : isSkipped
                              ? const Icon(Icons.close, size: 20, color: AppColors.warning)
                              : null,
                    ),
                  ),
                ),
                if (onEdit != null || onDelete != null) ...[
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
                    iconSize: 24,
                    padding: EdgeInsets.zero,
                    onSelected: (value) {
                      if (value == 'edit') onEdit?.call();
                      if (value == 'delete') onDelete?.call();
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 20, color: AppColors.primary),
                            SizedBox(width: 12),
                            Text('Edit', style: TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, size: 20, color: AppColors.emergency),
                            SizedBox(width: 12),
                            Text('Delete', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.emergency)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
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

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (label, bgColor, textColor) = switch (status) {
      'completed' => ('Completed', AppColors.successContainer, AppColors.success),
      'skipped' => ('Skipped', AppColors.warningContainer, AppColors.warning),
      'missed' => ('Missed', AppColors.emergencyContainer, AppColors.emergency),
      _ => ('Pending', AppColors.primaryContainer, AppColors.primary),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
