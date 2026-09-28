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

    final bool isCompleted = reminder.status == 'completed';
    final bool isSkipped = reminder.status == 'skipped';
    final bool isMissed = reminder.status == 'missed';

    final Color statusColor = isCompleted
        ? AppColors.success
        : isSkipped
            ? AppColors.warning
            : isMissed
                ? AppColors.emergency
                : accent;

    final (periodIcon, periodLabel) = _getTimePeriodInfo(reminder.scheduledTime, l10n);

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: isCompleted ? 0 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isCompleted
              ? AppColors.success.withValues(alpha: 0.3)
              : isSkipped
                  ? AppColors.warning.withValues(alpha: 0.4)
                  : theme.colorScheme.outlineVariant,
          width: isCompleted || isSkipped ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header: Time Badge & Status Tag + Overflow Options ───
            Row(
              children: [
                // Time & Period Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.successContainer
                        : isSkipped
                            ? AppColors.warningContainer
                            : theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        periodIcon,
                        size: 22,
                        color: isCompleted
                            ? AppColors.success
                            : isSkipped
                                ? AppColors.warning
                                : theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatTime(reminder.scheduledTime),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isCompleted
                              ? AppColors.success
                              : isSkipped
                                  ? AppColors.warning
                                  : theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '($periodLabel)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isCompleted
                              ? AppColors.success
                              : isSkipped
                                  ? AppColors.warning
                                  : theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Status Badge
                _StatusBadge(status: reminder.status, l10n: l10n),
                if (onEdit != null || onDelete != null) ...[
                  const SizedBox(width: 4),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 26,
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
                            const Icon(Icons.edit_outlined, size: 22, color: AppColors.primary),
                            const SizedBox(width: 12),
                            Text(l10n.edit, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(Icons.delete_outline, size: 22, color: AppColors.emergency),
                            const SizedBox(width: 12),
                            Text(
                              l10n.delete,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.emergency),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),

            // ─── Body: Medication Name & Type Icon ───
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.successContainer
                        : isDark
                            ? Colors.blue.withValues(alpha: 0.2)
                            : AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    isCompleted
                        ? Icons.check_circle_outline
                        : isSkipped
                            ? Icons.do_not_disturb_on_outlined
                            : Icons.medication_outlined,
                    color: statusColor,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reminder.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                          color: isCompleted
                              ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      if (reminder.dosage != null && reminder.dosage!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.vaccines_outlined, size: 16, color: AppColors.primary),
                              const SizedBox(width: 6),
                              Text(
                                '${l10n.dosageLabel}: ${reminder.dosage}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            // ─── Instructions Banner (if available) ───
            if (reminder.instructions != null && reminder.instructions!.isNotEmpty) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.amber.withValues(alpha: 0.1)
                      : const Color(0xFFFFFBEB), // Amber tint
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.amber.shade400.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, size: 20, color: Colors.amber.shade800),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        reminder.instructions!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.amber.shade200 : Colors.amber.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // ─── Duration & Progress Bar ───
            const SizedBox(height: 16),
            _DurationProgressSection(reminder: reminder, l10n: l10n),

            const SizedBox(height: 16),
            const Divider(height: 1),

            // ─── Action Buttons (Elderly Accessible Tap Targets) ───
            const SizedBox(height: 16),
            if (isCompleted) ...[
              // Completed State Banner with Undo
              Row(
                children: [
                  const Icon(Icons.check_circle, color: AppColors.success, size: 26),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.medicineTaken,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: onToggle,
                    icon: const Icon(Icons.undo, size: 20),
                    label: Text(l10n.markPending, style: const TextStyle(fontSize: 14)),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(120, 48),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ],
              ),
            ] else ...[
              // Pending / Skipped Action Buttons
              Row(
                children: [
                  // Primary Take Medicine Button
                  Expanded(
                    flex: 3,
                    child: Semantics(
                      button: true,
                      label: l10n.takeMedicine,
                      child: ElevatedButton.icon(
                        onPressed: onToggle,
                        icon: const Icon(Icons.check_circle_outline, size: 26),
                        label: Text(
                          l10n.takeMedicine,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 54),
                          backgroundColor: AppColors.success,
                          foregroundColor: AppColors.textLight,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 1,
                        ),
                      ),
                    ),
                  ),
                  if (onSkip != null) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: Semantics(
                        button: true,
                        label: l10n.skipForNow,
                        child: OutlinedButton(
                          onPressed: onSkip,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 54),
                            foregroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            side: BorderSide(
                              color: theme.colorScheme.outline,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            l10n.skipForNow,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  (IconData, String) _getTimePeriodInfo(DateTime time, AppLocalizations l10n) {
    final hour = time.hour;
    if (hour >= 5 && hour < 12) {
      return (Icons.wb_sunny_outlined, l10n.morning);
    } else if (hour >= 12 && hour < 17) {
      return (Icons.wb_sunny, l10n.afternoon);
    } else if (hour >= 17 && hour < 21) {
      return (Icons.wb_twilight, l10n.evening);
    } else {
      return (Icons.nightlight_round, l10n.night);
    }
  }

  String _formatTime(DateTime time) {
    final hour = time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}

class _DurationProgressSection extends StatelessWidget {
  const _DurationProgressSection({
    required this.reminder,
    required this.l10n,
  });

  final ReminderModel reminder;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final duration = reminder.durationDays;

    if (duration == null) {
      // Ongoing treatment
      return Row(
        children: [
          const Icon(Icons.repeat, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            l10n.ongoingTreatment,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      );
    }

    final currentDay = reminder.currentDay;
    final daysLeft = reminder.daysRemaining ?? 0;
    final progress = reminder.progressRatio;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_month_outlined, size: 18, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  l10n.dayProgressText(currentDay, duration),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                l10n.daysRemainingBadge(daysLeft),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              progress >= 1.0 ? AppColors.success : AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.status,
    required this.l10n,
  });

  final String status;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final (label, bgColor, textColor) = switch (status) {
      'completed' => (l10n.completed, AppColors.successContainer, AppColors.success),
      'skipped' => (l10n.skipped, AppColors.warningContainer, AppColors.warning),
      'missed' => (l10n.missed, AppColors.emergencyContainer, AppColors.emergency),
      _ => (l10n.pending, AppColors.primaryContainer, AppColors.primary),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
