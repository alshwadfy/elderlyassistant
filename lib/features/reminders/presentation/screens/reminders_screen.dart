import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/rafiq_emergency_bar.dart';
import '../../../../core/widgets/rafiq_sky_header.dart';
import '../../../emergency/presentation/screens/emergency_screen.dart';
import '../../data/models/reminder_model.dart';
import '../../providers/reminders_provider.dart';

/// My Medicines (`أدويتي`) matching Figma `#2:262` (Day) & `#7:4932` (Night).
class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key, this.onBackToHome});

  final VoidCallback? onBackToHome;

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  int _selectedSegment = 0; // 0: اليوم, 1: كل الأدوية, 2: السجل

  void _showAddMedicineSheet(BuildContext context) {
    final titleCtrl = TextEditingController();
    final timeCtrl = TextEditingController(text: '٨:٠٠ م • يوميًا');
    final dosageCtrl = TextEditingController(text: '١ قرص');

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final primaryColor = isDark
            ? AppColorsDark.primary
            : AppColors.rafiqPrimary;
        final textPrimary = isDark
            ? AppColorsDark.textPrimary
            : AppColors.textPrimary;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'إضافة دواء أو تذكير جديد',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'اسم الدواء أو التذكير',
                  hintText: 'مثال: دواء السكر',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: timeCtrl,
                decoration: const InputDecoration(
                  labelText: 'الموعد والتكرار',
                  hintText: '٨:٠٠ م • يوميًا',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: dosageCtrl,
                decoration: const InputDecoration(
                  labelText: 'الجرعة',
                  hintText: '١ قرص بعد العشاء',
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (titleCtrl.text.trim().isEmpty) return;
                    context.read<RemindersCubit>().addReminder(
                          ReminderModel(
                            reminderId:
                                'rem_${DateTime.now().millisecondsSinceEpoch}',
                            userId: 'user_01',
                            type: 'medication',
                            title: titleCtrl.text.trim(),
                            scheduledTime: DateTime.now(),
                            repeatPattern: timeCtrl.text.trim(),
                            status: 'pending',
                            dosage: dosageCtrl.text.trim(),
                          ),
                        );
                    Navigator.of(ctx).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'حفظ التذكير ✓',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final reminders = context.watch<RemindersCubit>().state;
    final notifier = context.read<RemindersCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? AppColorsDark.background : AppColors.background;
    final surfaceColor = isDark ? AppColorsDark.surface : AppColors.surface;
    final borderColor = isDark ? AppColorsDark.cardBorder : AppColors.cardBorder;
    final textPrimary = isDark
        ? AppColorsDark.textPrimary
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColorsDark.textSecondary
        : AppColors.textSecondary;
    final primaryColor = isDark
        ? AppColorsDark.primary
        : AppColors.rafiqPrimary;

    final timelineReminders = reminders
        .where((r) => r.type != 'other_medication')
        .toList();
    final otherMedications = reminders
        .where((r) => r.type == 'other_medication')
        .toList();
    final logReminders = reminders
        .where((r) => r.status == 'completed' || r.status == 'skipped')
        .toList();

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          RafiqSkyHeader(
            title: 'أدويتي',
            subtitle: 'الجمعة ٩ أكتوبر',
            onBack: widget.onBackToHome ??
                (Navigator.of(context).canPop()
                    ? () => Navigator.of(context).maybePop()
                    : null),
            backLabel: 'الرئيسية',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Segmented View Switcher (`اليوم` | `كل الأدوية` | `السجل` `#2:270`)
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        _SegmentTabButton(
                          label: 'اليوم',
                          isSelected: _selectedSegment == 0,
                          isDark: isDark,
                          onTap: () => setState(() => _selectedSegment = 0),
                        ),
                        _SegmentTabButton(
                          label: 'كل الأدوية',
                          isSelected: _selectedSegment == 1,
                          isDark: isDark,
                          onTap: () => setState(() => _selectedSegment = 1),
                        ),
                        _SegmentTabButton(
                          label: 'السجل',
                          isSelected: _selectedSegment == 2,
                          isDark: isDark,
                          onTap: () => setState(() => _selectedSegment = 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (_selectedSegment == 0) ...[
                    // Vertical Medicine Timeline (`#2:277`)
                    for (var i = 0; i < timelineReminders.length; i++)
                      _TimelineMedicineRow(
                        reminder: timelineReminders[i],
                        isLast: i == timelineReminders.length - 1,
                        isDark: isDark,
                        onMarkDone: () => notifier.setStatus(
                          timelineReminders[i].reminderId,
                          'completed',
                        ),
                        onSkip: () => notifier.setStatus(
                          timelineReminders[i].reminderId,
                          'skipped',
                        ),
                        onToggle: () => notifier.toggleStatus(
                          timelineReminders[i].reminderId,
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Other Medicines Section (`أدوية أخرى` — `فيتامين د` `#2:319`)
                    Text(
                      'أدوية أخرى',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    for (final med in otherMedications)
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: borderColor, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: primaryColor.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                Icons.medication_liquid_rounded,
                                color: primaryColor,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    med.title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: textPrimary,
                                    ),
                                  ),
                                  Text(
                                    med.repeatPattern,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  notifier.toggleStatus(med.reminderId),
                              icon: Icon(
                                med.status == 'completed'
                                    ? Icons.check_circle_rounded
                                    : Icons.radio_button_unchecked_rounded,
                                color: med.status == 'completed'
                                    ? AppColors.success
                                    : textSecondary,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ] else if (_selectedSegment == 1) ...[
                    // All Medicines View (`كل الأدوية`)
                    for (final med in reminders)
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: borderColor, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: primaryColor.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                Icons.medication_rounded,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    med.title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: textPrimary,
                                    ),
                                  ),
                                  Text(
                                    '${med.repeatPattern} • ${med.dosage ?? ""}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'حذف',
                              onPressed: () =>
                                  notifier.deleteReminder(med.reminderId),
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: AppColors.emergencyRed,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 54,
                      child: OutlinedButton.icon(
                        onPressed: () => _showAddMedicineSheet(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryColor,
                          side: BorderSide(color: primaryColor, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        icon: const Icon(Icons.add_rounded),
                        label: const Text(
                          'إضافة دواء أو تذكير جديد',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    // History / Log View (`السجل`)
                    if (logReminders.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: borderColor),
                        ),
                        child: Text(
                          'لا توجد جرعات مسجّلة حتى الآن.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: textSecondary,
                          ),
                        ),
                      )
                    else
                      for (final item in logReminders)
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: item.status == 'completed'
                                ? (isDark
                                    ? AppColorsDark.successLight
                                    : AppColors.successLight)
                                : surfaceColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: item.status == 'completed'
                                  ? AppColors.successBorder
                                  : borderColor,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                item.status == 'completed'
                                    ? Icons.check_circle_rounded
                                    : Icons.schedule_rounded,
                                color: item.status == 'completed'
                                    ? AppColors.success
                                    : AppColors.warning,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: textPrimary,
                                      ),
                                    ),
                                    Text(
                                      item.status == 'completed'
                                          ? 'تم الأخذ ✓ • ${item.repeatPattern}'
                                          : 'تم التأجيل (ليس الآن) • ${item.repeatPattern}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                  ],

                  const SizedBox(height: 18),
                  RafiqEmergencyButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const EmergencyScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentTabButton extends StatelessWidget {
  const _SegmentTabButton({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primaryColor = isDark
        ? AppColorsDark.primary
        : AppColors.rafiqPrimary;
    final textSecondary = isDark
        ? AppColorsDark.textSecondary
        : AppColors.textSecondary;

    return Expanded(
      child: Semantics(
        button: true,
        selected: isSelected,
        label: label,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: Container(
              constraints: const BoxConstraints(minHeight: 48),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? Colors.white : textSecondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TimelineMedicineRow extends StatelessWidget {
  const _TimelineMedicineRow({
    required this.reminder,
    required this.isLast,
    required this.isDark,
    required this.onMarkDone,
    required this.onSkip,
    required this.onToggle,
  });

  final ReminderModel reminder;
  final bool isLast;
  final bool isDark;
  final VoidCallback onMarkDone;
  final VoidCallback onSkip;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final isDone = reminder.status == 'completed';
    final isActiveBp =
        reminder.reminderId == 'rem_bp_pill' && reminder.status == 'pending';
    final primaryColor = isDark
        ? AppColorsDark.primary
        : AppColors.rafiqPrimary;
    final surfaceColor = isDark ? AppColorsDark.surface : AppColors.surface;
    final borderColor = isDark ? AppColorsDark.cardBorder : AppColors.cardBorder;
    final textPrimary = isDark
        ? AppColorsDark.textPrimary
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColorsDark.textSecondary
        : AppColors.textSecondary;

    final timeShort = reminder.repeatPattern.split('•').first.trim();
    final timeLabel = isActiveBp ? 'الآن · $timeShort' : timeShort;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline vertical spine + circle node
          SizedBox(
            width: 34,
            child: Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone
                        ? AppColors.success
                        : (isActiveBp ? primaryColor : surfaceColor),
                    border: Border.all(
                      color: isDone
                          ? AppColors.success
                          : (isActiveBp ? primaryColor : borderColor),
                      width: 2.2,
                    ),
                  ),
                  child: isDone
                      ? const Icon(
                          Icons.check_rounded,
                          size: 17,
                          color: Colors.white,
                        )
                      : (isActiveBp
                          ? const Icon(
                              Icons.circle,
                              size: 10,
                              color: Colors.white,
                            )
                          : null),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2.5,
                      color: isDone ? AppColors.success : borderColor,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Timeline Card
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDone
                    ? (isDark
                        ? AppColorsDark.successLight
                        : AppColors.successLight)
                    : (isActiveBp
                        ? (isDark
                            ? AppColorsDark.primaryContainer
                            : AppColors.rafiqPrimaryTint)
                        : surfaceColor),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDone
                      ? AppColors.successBorder
                      : (isActiveBp ? primaryColor : borderColor),
                  width: isActiveBp ? 2.0 : 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        timeLabel,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isDone
                              ? AppColors.success
                              : (isActiveBp ? primaryColor : textSecondary),
                        ),
                      ),
                      if (isDone)
                        const Text(
                          '✓ تم الأخذ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.success,
                          ),
                        )
                      else if (reminder.status == 'skipped')
                        const Text(
                          'مؤجّل',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.warning,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          reminder.title,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: textPrimary,
                          ),
                        ),
                      ),
                      if (!isActiveBp)
                        IconButton(
                          onPressed: onToggle,
                          icon: Icon(
                            isDone
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_unchecked_rounded,
                            color: isDone ? AppColors.success : textSecondary,
                            size: 28,
                          ),
                        ),
                    ],
                  ),
                  if (isActiveBp) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: onMarkDone,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                '✓ تم',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: OutlinedButton(
                              onPressed: onSkip,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: textPrimary,
                                backgroundColor: surfaceColor,
                                side: BorderSide(
                                  color: borderColor,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                'ليس الآن',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
