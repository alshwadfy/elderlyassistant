import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/reminder_model.dart';

class ReminderCard extends StatelessWidget {
  const ReminderCard({
    super.key,
    required this.reminder,
    required this.onToggle,
    this.onSkip,
    this.onEdit,
    this.onDelete,
    this.accent = AppColors.primary,
  });

  final ReminderModel reminder;
  final VoidCallback onToggle;
  final VoidCallback? onSkip;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark ? AppColorsDark.primary : AppColors.primary;
    final successColor = isDark ? AppColorsDark.success : AppColors.success;
    final warningColor = isDark ? AppColorsDark.warning : AppColors.warning;
    final emergencyColor = isDark ? AppColorsDark.emergency : AppColors.emergency;
    final surface = isDark ? AppColorsDark.surface : AppColors.surface;
    final textPrimary = isDark ? AppColorsDark.textPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColorsDark.textSecondary : AppColors.textSecondary;
    final border = isDark ? AppColorsDark.border : AppColors.border;

    final bool isCompleted = reminder.status == 'completed';
    final bool isSkipped = reminder.status == 'skipped';
    final bool isMissed = reminder.status == 'missed';

    final Color statusColor = isCompleted
        ? successColor
        : isSkipped
            ? warningColor
            : isMissed
                ? emergencyColor
                : primaryColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted
              ? successColor.withValues(alpha: 0.3)
              : border,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header: Time Pill + Status + Menu ───
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Time pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: isDark ? 0.18 : 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time_filled_rounded,
                        size: 14,
                        color: statusColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTime(reminder.scheduledTime),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status Badge & Menu
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _StatusBadge(status: reminder.status, l10n: l10n, isDark: isDark),
                    if (onEdit != null || onDelete != null) ...[
                      const SizedBox(width: 2),
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: PopupMenuButton<String>(
                          icon: Icon(
                            Icons.more_vert_rounded,
                            color: textSecondary,
                            size: 18,
                          ),
                          padding: EdgeInsets.zero,
                          onSelected: (value) {
                            if (value == 'edit') onEdit?.call();
                            if (value == 'delete') onDelete?.call();
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit_outlined, size: 18, color: primaryColor),
                                  const SizedBox(width: 8),
                                  Text(l10n.edit, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete_outline, size: 18, color: emergencyColor),
                                  const SizedBox(width: 8),
                                  Text(
                                    l10n.delete,
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: emergencyColor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ─── Medication Title & Icon ───
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: isDark ? 0.15 : 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isCompleted
                        ? Icons.check_rounded
                        : isSkipped
                            ? Icons.do_not_disturb_on_rounded
                            : Icons.medication_rounded,
                    color: statusColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reminder.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                          color: isCompleted
                              ? textSecondary
                              : textPrimary,
                        ),
                      ),
                      if (reminder.dosage != null && reminder.dosage!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          reminder.dosage!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: textSecondary,
                          ),
                        ),
                      ],
                      if (reminder.instructions != null && reminder.instructions!.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 13,
                              color: isDark ? Colors.amber.shade300 : Colors.amber.shade800,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                reminder.instructions!,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? Colors.amber.shade200 : Colors.amber.shade900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ─── Actions ───
            if (isCompleted)
              InkWell(
                onTap: onToggle,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: successColor.withValues(alpha: isDark ? 0.15 : 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_rounded, color: successColor, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        l10n.medicineTaken,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: successColor,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onToggle,
                      icon: const Icon(Icons.check_rounded, size: 18),
                      label: Text(
                        l10n.takeMedicine,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        backgroundColor: successColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  if (onSkip != null) ...[
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: onSkip,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        foregroundColor: textSecondary,
                        side: BorderSide(color: border, width: 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        l10n.skipForNow,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
    final hour = time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.status,
    required this.l10n,
    required this.isDark,
  });

  final String status;
  final AppLocalizations l10n;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final primaryColor = isDark ? AppColorsDark.primary : AppColors.primary;
    final primaryContainer = isDark ? AppColorsDark.primaryContainer : AppColors.primaryContainer;
    final successColor = isDark ? AppColorsDark.success : AppColors.success;
    final successContainer = isDark ? AppColorsDark.successContainer : AppColors.successContainer;
    final warningColor = isDark ? AppColorsDark.warning : AppColors.warning;
    final warningContainer = isDark ? AppColorsDark.warningContainer : AppColors.warningContainer;
    final emergencyColor = isDark ? AppColorsDark.emergency : AppColors.emergency;
    final emergencyContainer = isDark ? AppColorsDark.emergencyContainer : AppColors.emergencyContainer;

    final (label, bgColor, textColor) = switch (status) {
      'completed' => (l10n.completed, successContainer, successColor),
      'skipped' => (l10n.skipped, warningContainer, warningColor),
      'missed' => (l10n.missed, emergencyContainer, emergencyColor),
      _ => (l10n.pending, primaryContainer, primaryColor),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}
