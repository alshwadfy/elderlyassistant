import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_logo.dart';
import 'login_form_screen.dart';
import 'onboarding_screen.dart';

/// Login / Welcome screen — matches the Figma UI (media_1790862407812.png).
///
/// Top: AI Elderly Assistant logo
/// Center: "Your voice. Our support." headline + subtitle + "Get Started" & "Log In" buttons
/// Bottom: Photo of elderly woman holding phone with audio wave badge.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark ? AppColorsDark.primary : AppColors.primary;
    final textPrimary = isDark ? AppColorsDark.textPrimary : const Color(0xFF1E3A8A);
    final textSecondary = isDark ? AppColorsDark.textSecondary : const Color(0xFF4B6B94);
    final bgColor = isDark ? AppColorsDark.background : const Color(0xFFF0F5FA);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ─── Header: App Logo ───
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                children: [
                  const AppLogo(size: 38),
                  const SizedBox(width: 12),
                  Text(
                    'AI Elderly Assistant',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ─── Headline & Subtitle ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  Text(
                    'Your voice. Our support.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: textPrimary,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Simple help for a safer,\nhealthier and more connected life.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textSecondary,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ─── Action Buttons ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  // Get Started (filled primary)
                  Semantics(
                    button: true,
                    label: 'Get started and set up your assistant',
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OnboardingScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Login (white with blue outline)
                  Semantics(
                    button: true,
                    label: 'Log in to your existing account',
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: isDark ? AppColorsDark.surface : Colors.white,
                          foregroundColor: primaryColor,
                          side: BorderSide(
                            color: primaryColor.withValues(alpha: 0.6),
                            width: 1.8,
                          ),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginFormScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ─── Elderly Woman Photo at Bottom ───
            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        'assets/elderly-assistant-photo.png',
                        fit: BoxFit.contain,
                        alignment: Alignment.bottomCenter,
                        semanticLabel: 'Elderly woman holding phone with AI voice assistant',
                      ),
                    ),
                  ),

                  // Floating audio wave badge next to the phone
                  Positioned(
                    right: 48,
                    bottom: 120,
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.graphic_eq_rounded,
                        color: primaryColor,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
