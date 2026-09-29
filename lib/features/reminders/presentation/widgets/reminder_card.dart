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

    // Neon Accent Color based on state
    final Color neonColor = isCompleted
        ? AppColors.success
        : isSkipped
            ? AppColors.warning
            : isMissed
                ? AppColors.emergency
                : accent;

    final (periodIcon, periodLabel) = _getTimePeriodInfo(reminder.scheduledTime, l10n);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.surface : AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: neonColor.withValues(alpha: isDark ? 0.6 : 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: neonColor.withValues(alpha: isDark ? 0.25 : 0.12),
            blurRadius: 14,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header: Time Badge & Status Tag + Options ───
            Row(
              children: [
                // Time & Period Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: neonColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: neonColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        periodIcon,
                        size: 18,
                        color: neonColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _formatTime(reminder.scheduledTime),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: neonColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '($periodLabel)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: neonColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Status Badge
                _StatusBadge(status: reminder.status, l10n: l10n),
                if (onEdit != null || onDelete != null) ...[
                  const SizedBox(width: 2),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert_rounded,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 22,
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
                            const Icon(Icons.edit_outlined, size: 20, color: AppColors.primary),
                            const SizedBox(width: 10),
                            Text(l10n.edit, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(Icons.delete_outline, size: 20, color: AppColors.emergency),
                            const SizedBox(width: 10),
                            Text(
                              l10n.delete,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.emergency),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),

            // ─── Body: Medication Name & Type Icon ───
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: neonColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: neonColor.withValues(alpha: 0.2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(
                    isCompleted
                        ? Icons.check_circle_rounded
                        : isSkipped
                            ? Icons.do_not_disturb_on_rounded
                            : Icons.medication_rounded,
                    color: neonColor,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reminder.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                          color: isCompleted
                              ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      if (reminder.dosage != null && reminder.dosage!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.vaccines_outlined, size: 14, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Text(
                              '${l10n.dosageLabel}: ${reminder.dosage}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
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

            // ─── Instructions Banner (if available) ───
            if (reminder.instructions != null && reminder.instructions!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.amber.withValues(alpha: 0.08)
                      : const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.amber.shade400.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded, size: 18, color: Colors.amber.shade800),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        reminder.instructions!,
                        style: TextStyle(
                          fontSize: 13,
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
            const SizedBox(height: 10),
            _DurationProgressSection(reminder: reminder, l10n: l10n, neonColor: neonColor),

            // ─── Sleek Neon Accent Line above Actions ───
            Container(
              height: 2,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: LinearGradient(
                  colors: [
                    neonColor.withValues(alpha: 0.05),
                    neonColor,
                    neonColor.withValues(alpha: 0.05),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: neonColor.withValues(alpha: 0.4),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),

            // ─── Action Section ───
            if (isCompleted) ...[
              // Clean Neon Completed Badge Banner (NO Mark Pending button)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withValues(alpha: 0.15),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      '${l10n.medicineTaken} 💚',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Pending / Skipped Action Buttons
              Row(
                children: [
                  // Primary Take Medicine Button (Min 48px height)
                  Expanded(
                    flex: 3,
                    child: Semantics(
                      button: true,
                      label: l10n.takeMedicine,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.success.withValues(alpha: 0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: onToggle,
                          icon: const Icon(Icons.check_circle_rounded, size: 22),
                          label: Text(
                            l10n.takeMedicine,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                            backgroundColor: AppColors.success,
                            foregroundColor: AppColors.textLight,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (onSkip != null) ...[
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: Semantics(
                        button: true,
                        label: l10n.skipForNow,
                        child: OutlinedButton(
                          onPressed: onSkip,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 48),
                            foregroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            side: BorderSide(
                              color: theme.colorScheme.outline.withValues(alpha: 0.5),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            l10n.skipForNow,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
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
      return (Icons.wb_sunny_rounded, l10n.afternoon);
    } else if (hour >= 17 && hour < 21) {
      return (Icons.wb_twilight_rounded, l10n.evening);
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
    required this.neonColor,
  });

  final ReminderModel reminder;
  final AppLocalizations l10n;
  final Color neonColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final duration = reminder.durationDays;

    if (duration == null) {
      return Row(
        children: [
          Icon(Icons.repeat_rounded, size: 16, color: neonColor),
          const SizedBox(width: 6),
          Text(
            l10n.ongoingTreatment,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: neonColor,
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
                Icon(Icons.calendar_month_rounded, size: 16, color: neonColor),
                const SizedBox(width: 6),
                Text(
                  l10n.dayProgressText(currentDay, duration),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: neonColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                l10n.daysRemainingBadge(daysLeft),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: neonColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              progress >= 1.0 ? AppColors.success : neonColor,
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
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}

