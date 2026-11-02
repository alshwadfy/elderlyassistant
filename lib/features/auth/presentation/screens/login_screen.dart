import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/providers/app_settings_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/rafiq_sky_header.dart';
import 'login_form_screen.dart';
import 'onboarding_screen.dart';
import 'register_screen.dart';

/// Welcome Screen (`مرحباً بك في رفيق` `#107:44` Day & `#107:60` Night).
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsCubit>().state;
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
            title: 'أهلاً بك في رفيق',
            subtitle: 'رفيقك في كل يوم، لراحة بالك.',
            height: 185,
            trailingAction: Semantics(
              button: true,
              label: 'تغيير اللغة / Switch Language',
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () =>
                      context.read<AppSettingsCubit>().toggleLocale(),
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 48),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.16)
                          : Colors.white.withValues(alpha: 0.88),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.language_rounded,
                          size: 18,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          settings.isArabic ? 'AR / EN' : 'EN / AR',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Official Rafiq Logo Card (`#105:285` Day / `#107:75` Night)
                  Center(
                    child: Container(
                      width: 170,
                      height: 215,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: borderColor, width: 1.8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: isDark ? 0.35 : 0.08,
                            ),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: AppLogo(size: 138, height: 185),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'أهلاً بك في رفيق',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'رفيقك في كل يوم، لراحة بالك.\nمعك، خطوة بخطوة.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textSecondary,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Primary CTA: `تسجيل الدخول` (`#107:53` / `#107:69`)
                  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LoginFormScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'تسجيل الدخول',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Secondary CTA: `إنشاء حساب جديد` (`#107:56` / `#107:72`)
                  SizedBox(
                    height: 58,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: surfaceColor,
                        foregroundColor: textPrimary,
                        side: BorderSide(color: borderColor, width: 1.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'إنشاء حساب جديد',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Quick start / Meet your assistant (`تعرّف على مساعدك`)
                  SizedBox(
                    height: 52,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const OnboardingScreen(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.record_voice_over_rounded,
                        color: primaryColor,
                      ),
                      label: Text(
                        'ابدأ سريعًا · تعرّف على مساعدك',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: primaryColor,
                        ),
                      ),
                    ),
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
