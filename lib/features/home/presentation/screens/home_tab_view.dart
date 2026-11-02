import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/providers/app_settings_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/rafiq_emergency_bar.dart';
import '../../../../core/widgets/rafiq_sky_header.dart';
import '../../../check_in/presentation/screens/daily_check_in_screen.dart';
import '../../../doctors/presentation/screens/appointments_screen.dart';
import '../../../emergency/presentation/screens/emergency_screen.dart';
import '../../../emergency/presentation/screens/family_circle_screen.dart';
import '../../../reminders/data/models/reminder_model.dart';
import '../../../reminders/providers/reminders_provider.dart';
import '../../../voice_assistant/presentation/screens/voice_assistant_screen.dart';
import '../../../way_home/presentation/screens/way_home_screen.dart';

/// Home – v2 (`الرئيسية`) matching Figma `#2:98` (Day) & `#7:4773` (Night).
class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key, this.onSwitchTab});

  final ValueChanged<int>? onSwitchTab;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsCubit>().state;
    final reminders = context.watch<RemindersCubit>().state;
    final remindersNotifier = context.read<RemindersCubit>();
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

    // Next active medication (`حبة الضغط` at `٢:٠٠ م`)
    final nextMed = reminders.firstWhere(
      (r) => r.reminderId == 'rem_bp_pill',
      orElse: () => reminders.first,
    );
    final isNextMedDone = nextMed.status == 'completed';

    // Daily routine items (`اشرب الماء` at `٤:٠٠ م`, `مشي المساء` at `٦:٠٠ م`)
    final routineItems = reminders
        .where((r) => r.type == 'routine')
        .toList();

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          RafiqSkyHeader(
            title: 'أهلاً , أحمد !',
            subtitle: 'الجمعة ٩ أكتوبر',
            trailingAction: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.14)
                    : Colors.white.withValues(alpha: 0.88),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppLogo(size: 28, height: 34),
                  const SizedBox(width: 6),
                  Text(
                    'رفيق',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Next Medicine Card (`الدواء القادم · ٢:٠٠ م` — `حبة الضغط` `#2:108`)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isNextMedDone
                            ? AppColors.successBorder
                            : borderColor,
                        width: 1.8,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: isDark ? 0.25 : 0.05,
                          ),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'الدواء القادم · ٢:٠٠ م',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: isNextMedDone
                                          ? AppColors.success
                                          : primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    nextMed.title,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      color: textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: isNextMedDone
                                    ? AppColors.successLight
                                    : (isDark
                                        ? AppColorsDark.primaryContainer
                                        : AppColors.rafiqPrimaryTint),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                isNextMedDone
                                    ? Icons.check_circle_rounded
                                    : Icons.medication_rounded,
                                color: isNextMedDone
                                    ? AppColors.success
                                    : primaryColor,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          height: 54,
                          child: ElevatedButton(
                            onPressed: () {
                              remindersNotifier.toggleStatus(nextMed.reminderId);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isNextMedDone
                                  ? AppColors.success
                                  : primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              isNextMedDone
                                  ? 'تم أخذه بنجاح ✓ (اضغط للتراجع)'
                                  : 'تم أخذه ✓',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 2. Ask Your Assistant Card (`اسأل مساعدك` `#2:118`)
                  Semantics(
                    button: true,
                    label: 'اسأل مساعدك الصوتي',
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const VoiceAssistantScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: primaryColor.withValues(alpha: 0.45),
                              width: 1.8,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: const Icon(
                                  Icons.graphic_eq_rounded,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'اسأل مساعدك',
                                      style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.w800,
                                        color: textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'تحدّث بصوتك لتسجيل الدواء أو البحث عن مستشفى',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              const AppLogo(size: 40, height: 48),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 3. Three Shortcut Tiles (`المستشفيات`, `أدويتي`, `عائلتي` `#2:133`)
                  Row(
                    children: [
                      Expanded(
                        child: _ShortcutSquareTile(
                          label: 'المستشفيات',
                          icon: Icons.local_hospital_rounded,
                          isDark: isDark,
                          onTap: () {
                            if (onSwitchTab != null) {
                              onSwitchTab!(1);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ShortcutSquareTile(
                          label: 'أدويتي',
                          icon: Icons.medication_rounded,
                          isDark: isDark,
                          onTap: () {
                            if (onSwitchTab != null) {
                              onSwitchTab!(2);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ShortcutSquareTile(
                          label: 'عائلتي',
                          icon: Icons.people_alt_rounded,
                          isDark: isDark,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const FamilyCircleScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 4. Two Secondary Assistance Buttons (`طمنّا عليك` `#10:3468` & `ساعدني أرجع للبيت` `#10:3472`)
                  Row(
                    children: [
                      if (settings.dailyCheckInEnabled) ...[
                        Expanded(
                          child: _AssistanceActionTile(
                            label: 'طمنّا عليك',
                            icon: Icons.favorite_border_rounded,
                            isDark: isDark,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const DailyCheckInScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      Expanded(
                        child: _AssistanceActionTile(
                          label: 'ساعدني أرجع للبيت',
                          icon: Icons.home_work_outlined,
                          isDark: isDark,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const WayHomeScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 5. Next Visit Quick Card (`زيارتي القادمة · مستشفى الأمل`)
                  Semantics(
                    button: true,
                    label: 'زيارتي القادمة مستشفى الأمل ٢٩ أكتوبر',
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const AppointmentsScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: borderColor, width: 1.5),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: primaryColor.withValues(alpha: 0.14),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Icons.calendar_month_rounded,
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
                                      'زيارتي القادمة · مستشفى الأمل',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: textPrimary,
                                      ),
                                    ),
                                    Text(
                                      '٢٩ أكتوبر · ١٠:٠٠ ص · المرافق: فاطمة أحمد',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 6. Daily Routine Reminders Card (`اشرب الماء` ٤:٠٠ م & `مشي المساء` ٦:٠٠ م `#2:161`)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    child: Column(
                      children: [
                        for (var i = 0; i < routineItems.length; i++) ...[
                          _RoutineReminderRow(
                            reminder: routineItems[i],
                            isDark: isDark,
                            onToggle: () => remindersNotifier.toggleStatus(
                              routineItems[i].reminderId,
                            ),
                          ),
                          if (i < routineItems.length - 1)
                            Divider(color: borderColor, height: 16),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 7. Persistent Red Emergency Button (`أحتاج مساعدة` `#10:3476`)
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

class _ShortcutSquareTile extends StatelessWidget {
  const _ShortcutSquareTile({
    required this.label,
    required this.icon,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = isDark ? AppColorsDark.surface : AppColors.surface;
    final borderColor = isDark ? AppColorsDark.cardBorder : AppColors.cardBorder;
    final primaryColor = isDark
        ? AppColorsDark.rafiqAccentBlue
        : AppColors.rafiqPrimary;
    final textPrimary = isDark
        ? AppColorsDark.textPrimary
        : AppColors.textPrimary;

    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 96),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 30, color: primaryColor),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AssistanceActionTile extends StatelessWidget {
  const _AssistanceActionTile({
    required this.label,
    required this.icon,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = isDark ? AppColorsDark.surface : AppColors.surface;
    final borderColor = isDark ? AppColorsDark.cardBorder : AppColors.cardBorder;
    final primaryColor = isDark
        ? AppColorsDark.rafiqAccentBlue
        : AppColors.rafiqPrimary;
    final textPrimary = isDark
        ? AppColorsDark.textPrimary
        : AppColors.textPrimary;

    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 56),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 22, color: primaryColor),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoutineReminderRow extends StatelessWidget {
  const _RoutineReminderRow({
    required this.reminder,
    required this.isDark,
    required this.onToggle,
  });

  final ReminderModel reminder;
  final bool isDark;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final isDone = reminder.status == 'completed';
    final textPrimary = isDark
        ? AppColorsDark.textPrimary
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColorsDark.textSecondary
        : AppColors.textSecondary;
    final borderColor = isDark ? AppColorsDark.cardBorder : AppColors.cardBorder;
    final timeBadge = reminder.repeatPattern.split('•').first.trim();

    return Semantics(
      button: true,
      checked: isDone,
      label: '${reminder.title} $timeBadge',
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone ? AppColors.success : Colors.transparent,
                  border: Border.all(
                    color: isDone ? AppColors.success : borderColor,
                    width: 2,
                  ),
                ),
                child: isDone
                    ? const Icon(
                        Icons.check_rounded,
                        size: 18,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  reminder.title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              Text(
                timeBadge,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
