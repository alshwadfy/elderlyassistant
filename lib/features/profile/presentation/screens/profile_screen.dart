import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/providers/app_settings_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/rafiq_emergency_bar.dart';
import '../../../../core/widgets/rafiq_sky_header.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../emergency/presentation/screens/emergency_screen.dart';
import '../../../emergency/presentation/screens/family_circle_screen.dart';
import '../../../emergency/providers/family_provider.dart';
import 'settings_subscreens.dart';

/// Profile & Settings (`الملف الشخصي والإعدادات`) matching Figma `#2:477` (Day) & `#7:5124` (Night).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, this.onBackToHome});

  final VoidCallback? onBackToHome;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsCubit>().state;
    final settingsNotifier = context.read<AppSettingsCubit>();
    final auth = context.watch<AuthCubit>().state;
    final contacts = context.watch<FamilyCubit>().state;
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
            title: 'الملف الشخصي والإعدادات',
            subtitle: 'تحكّم في المظهر، الخط، الصوت، وعائلتك',
            onBack: onBackToHome ??
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
                  // 1. User Profile Card (`عادل أحمد` · `+20 10 1234 5678` · `تعديل` `#2:485`)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: primaryColor,
                          child: const Text(
                            'ع',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                auth.userName ?? 'عادل أحمد',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                auth.userPhone,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const EditProfileScreen(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: primaryColor,
                            side: BorderSide(color: borderColor, width: 1.5),
                            minimumSize: const Size(76, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'تعديل',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. Settings Navigation List (`#2:499`)
                  _SettingsNavRow(
                    title: 'المظهر',
                    subtitle: settings.appearanceSubtitleAr,
                    icon: isDark
                        ? Icons.nightlight_round
                        : Icons.wb_sunny_rounded,
                    isDark: isDark,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AppearanceScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  _SettingsNavRow(
                    title: 'الخط والتباين',
                    subtitle: settings.highContrast
                        ? 'أأ · تباين عالٍ'
                        : 'أأ · حجم مريح وتباين واضح',
                    icon: Icons.text_fields_rounded,
                    isDark: isDark,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const FontContrastScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  _SettingsNavRow(
                    title: 'الصوت والكلام',
                    subtitle:
                        '${settings.voicePersonaLabelAr} · سرعة ${settings.speechSpeedLabelAr}',
                    icon: Icons.record_voice_over_rounded,
                    isDark: isDark,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const VoiceSpeechScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  _SettingsNavRow(
                    title: 'عائلتي',
                    subtitle: '${contacts.length} جهات اتصال · ترتيب الطوارئ',
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
                  const SizedBox(height: 10),

                  _SettingsNavRow(
                    title: 'تنبيهات الدواء',
                    subtitle: settings.pillVibration
                        ? 'صوت عالٍ · اهتزاز وتذكير منطوق'
                        : 'صوت التنبيه فقط',
                    icon: Icons.notifications_active_outlined,
                    isDark: isDark,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const MedicineAlertsScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  // Optional Daily Check-in Toggle (`الفحص اليومي` · `اختياري · يمكنك إيقافه` `#48:460`)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
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
                            Icons.favorite_border_rounded,
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
                                'الفحص اليومي',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: textPrimary,
                                ),
                              ),
                              Text(
                                'اختياري · يمكنك إيقافه',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: settings.dailyCheckInEnabled,
                          activeThumbColor: Colors.white,
                          activeTrackColor: primaryColor,
                          onChanged: settingsNotifier.setDailyCheckInEnabled,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Language Switcher (`اللغة`)
                  _SettingsNavRow(
                    title: 'اللغة / Language',
                    subtitle: settings.isArabic ? 'العربية (RTL)' : 'English',
                    icon: Icons.language_rounded,
                    isDark: isDark,
                    onTap: settingsNotifier.toggleLocale,
                  ),
                  const SizedBox(height: 12),

                  // Sign Out Button (`تسجيل الخروج`)
                  SizedBox(
                    height: 54,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.read<AuthCubit>().logout();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textPrimary,
                        backgroundColor: surfaceColor,
                        side: BorderSide(color: borderColor, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      icon: const Icon(Icons.logout_rounded, size: 20),
                      label: const Text(
                        'تسجيل الخروج',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Persistent Red Emergency Button (`أحتاج مساعدة`)
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

class _SettingsNavRow extends StatelessWidget {
  const _SettingsNavRow({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isDark,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = isDark ? AppColorsDark.surface : AppColors.surface;
    final borderColor = isDark ? AppColorsDark.cardBorder : AppColors.cardBorder;
    final textPrimary = isDark
        ? AppColorsDark.textPrimary
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColorsDark.textSecondary
        : AppColors.textSecondary;
    final primaryColor = isDark
        ? AppColorsDark.rafiqAccentBlue
        : AppColors.rafiqPrimary;

    return Semantics(
      button: true,
      label: '$title - $subtitle',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 74),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  child: Icon(icon, color: primaryColor, size: 24),
                ),
                const SizedBox(width: 12),
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
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
