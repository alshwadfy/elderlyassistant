import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/rafiq_emergency_bar.dart';
import '../../../../core/widgets/rafiq_sky_header.dart';
import '../../../emergency/presentation/screens/emergency_screen.dart';
import '../../providers/daily_check_in_provider.dart';

/// Daily Check-ins (`طمئنّا عليك`) screen matching Figma `#10:3035` (Day) & `#10:3092` (Night).
class DailyCheckInScreen extends StatelessWidget {
  const DailyCheckInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final checkIn = context.watch<DailyCheckInCubit>().state;
    final notifier = context.read<DailyCheckInCubit>();
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

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          RafiqSkyHeader(
            title: 'طمنّا عليك',
            subtitle: 'الفحص اليومي اختياري · يمكنك تخطّيه',
            onBack: () => Navigator.of(context).maybePop(),
            backLabel: 'الرئيسية',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Mood Card (`كيف تشعر اليوم؟`)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'كيف تشعر اليوم؟',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'اختر خيارًا واحدًا',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: textSecondary,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: _MoodOptionTile(
                                label: checkIn.mood == 'happy'
                                    ? 'سعيد ✓'
                                    : 'سعيد',
                                icon: Icons.sentiment_very_satisfied_rounded,
                                isSelected: checkIn.mood == 'happy',
                                isDark: isDark,
                                onTap: () => notifier.selectMood('happy'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _MoodOptionTile(
                                label:
                                    checkIn.mood == 'fine' ? 'بخير ✓' : 'بخير',
                                icon: Icons.sentiment_satisfied_alt_rounded,
                                isSelected: checkIn.mood == 'fine',
                                isDark: isDark,
                                onTap: () => notifier.selectMood('fine'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _MoodOptionTile(
                                label: checkIn.mood == 'tired'
                                    ? 'متعب ✓'
                                    : 'متعب',
                                icon: Icons.sentiment_dissatisfied_rounded,
                                isSelected: checkIn.mood == 'tired',
                                isDark: isDark,
                                onTap: () => notifier.selectMood('tired'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Daily Essentials Card (`كيف كان يومك حتى الآن؟`)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'كيف كان يومك حتى الآن؟',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'اضغط لتحديث ما أنجزته اليوم',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: textSecondary,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _DailyEssentialRow(
                          title: 'أدويتي',
                          subtitle: checkIn.tookMedicines
                              ? 'أخذت أدويتي ✓'
                              : 'لم آخذ أدويتي بعد',
                          icon: Icons.medication_rounded,
                          isChecked: checkIn.tookMedicines,
                          isDark: isDark,
                          onTap: notifier.toggleMedicines,
                        ),
                        const SizedBox(height: 10),
                        _DailyEssentialRow(
                          title: 'الماء',
                          subtitle: checkIn.drankWater
                              ? 'شربت الماء ✓'
                              : 'لم أشرب الماء بعد',
                          icon: Icons.water_drop_rounded,
                          isChecked: checkIn.drankWater,
                          isDark: isDark,
                          onTap: notifier.toggleWater,
                        ),
                        const SizedBox(height: 10),
                        _DailyEssentialRow(
                          title: 'الحركة',
                          subtitle: checkIn.movedToday
                              ? 'تحركت ومشيت اليوم ✓'
                              : 'لم أتحرك بعد',
                          icon: Icons.directions_walk_rounded,
                          isChecked: checkIn.movedToday,
                          isDark: isDark,
                          onTap: notifier.toggleMovement,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Submit button (`إرسال الفحص اليومي ✓`)
                  SizedBox(
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: checkIn.isSubmitting
                          ? null
                          : () async {
                              await notifier.submitCheckIn();
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    '✓ تم إرسال الفحص اليومي وطمأنة عائلتك بنجاح',
                                  ),
                                ),
                              );
                              Navigator.of(context).maybePop();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: const Icon(Icons.check_circle_outline_rounded),
                      label: Text(
                        checkIn.isSubmitting
                            ? 'جارٍ الإرسال…'
                            : 'إرسال الفحص اليومي ✓',
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Skip button (`ليس الآن`)
                  SizedBox(
                    height: 54,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textPrimary,
                        side: BorderSide(color: borderColor, width: 1.5),
                        backgroundColor: surfaceColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'ليس الآن',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

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

class _MoodOptionTile extends StatelessWidget {
  const _MoodOptionTile({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeBg = isDark
        ? AppColorsDark.primary.withValues(alpha: 0.25)
        : AppColors.rafiqPrimaryTint;
    final inactiveBg = isDark
        ? AppColorsDark.surfaceVariant
        : const Color(0xFFF8FAFF);
    final borderColor = isSelected
        ? (isDark ? AppColorsDark.rafiqAccentBlue : AppColors.rafiqPrimary)
        : (isDark ? AppColorsDark.cardBorder : AppColors.cardBorder);
    final textColor = isSelected
        ? (isDark ? Colors.white : AppColors.rafiqPrimary)
        : (isDark ? AppColorsDark.textPrimary : AppColors.textPrimary);

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 112),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              color: isSelected ? activeBg : inactiveBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: borderColor,
                width: isSelected ? 2.2 : 1.3,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 36, color: textColor),
                const SizedBox(height: 10),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: textColor,
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

class _DailyEssentialRow extends StatelessWidget {
  const _DailyEssentialRow({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isChecked,
    required this.isDark,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isChecked;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bgColor = isChecked
        ? (isDark ? AppColorsDark.successLight : AppColors.successLight)
        : (isDark ? AppColorsDark.surfaceVariant : const Color(0xFFF8FAFF));
    final borderColor = isChecked
        ? (isDark ? AppColorsDark.successBorder : AppColors.successBorder)
        : (isDark ? AppColorsDark.cardBorder : AppColors.cardBorder);
    final textPrimary = isDark
        ? AppColorsDark.textPrimary
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColorsDark.textSecondary
        : AppColors.textSecondary;

    return Semantics(
      button: true,
      checked: isChecked,
      label: '$title - $subtitle',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 72),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isChecked
                        ? AppColors.success
                        : (isDark
                            ? AppColorsDark.surface
                            : Colors.white),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: isChecked
                        ? Colors.white
                        : (isDark
                            ? AppColorsDark.rafiqAccentBlue
                            : AppColors.rafiqPrimary),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isChecked ? AppColors.success : Colors.transparent,
                    border: Border.all(
                      color: isChecked ? AppColors.success : borderColor,
                      width: 2,
                    ),
                  ),
                  child: isChecked
                      ? const Icon(
                          Icons.check_rounded,
                          size: 22,
                          color: Colors.white,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
