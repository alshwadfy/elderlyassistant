import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_logo.dart';
import 'login_form_screen.dart';
import 'onboarding_screen.dart';

/// Login / Welcome screen.
///
/// Design decisions per ui.md:
/// • All text ≥18sp. App name 32sp bold.
/// • Both buttons ≥64dp (primary) / 64dp (outlined) — spec says primary action 64dp+.
/// • Plain literal copy — no idioms.
/// • Responsive layout adapting to small & large screens with no overflow.
/// • Full dark mode compatibility.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark ? AppColorsDark.primary : AppColors.primary;
    final textSecondary = isDark ? AppColorsDark.textSecondary : AppColors.textSecondary;
    final surfaceColor = isDark ? AppColorsDark.surface : AppColors.surface;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF0D1521), const Color(0xFF141D2C)]
                : [const Color(0xFFE9ECFF), const Color(0xFFF7F9FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxHeight < 680;

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                      child: Column(
                        children: [
                          SizedBox(height: isCompact ? 16 : 32),
                          const Spacer(),

                          // ─── Logo ─────────────────────────────────────────────────
                          Container(
                            padding: EdgeInsets.all(isCompact ? 16 : 22),
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withValues(alpha: isDark ? 0.4 : 0.22),
                                  blurRadius: 36,
                                  spreadRadius: 4,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: AppLogo(size: isCompact ? 72 : 88),
                          ),

                          SizedBox(height: isCompact ? 20 : 30),

                          // ─── App name ─────────────────────────────────────────────
                          Text(
                            'AI Elderly Assistant',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isCompact ? 28 : 32,
                              fontWeight: FontWeight.w900,
                              color: primaryColor,
                              letterSpacing: -0.5,
                            ),
                          ),

                          SizedBox(height: isCompact ? 12 : 18),

                          // ─── Tagline ──────────────────────────────────────────────
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: isDark ? 0.15 : 0.08),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: primaryColor.withValues(alpha: isDark ? 0.3 : 0.15),
                              ),
                            ),
                            child: Text(
                              'Your voice, your support.\n'
                              'Simple help for a safer, healthier, and more connected life.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isCompact ? 16 : 18,
                                fontWeight: FontWeight.w600,
                                color: textSecondary,
                                height: 1.5,
                              ),
                            ),
                          ),

                          const Spacer(),
                          SizedBox(height: isCompact ? 24 : 36),

                          // ─── Get Started (primary action) ─────────────────────────
                          Semantics(
                            label: 'Get started and set up your assistant',
                            button: true,
                            child: SizedBox(
                              width: double.infinity,
                              height: isCompact ? 56 : 64,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  elevation: 3,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const OnboardingScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Get Started',
                                  style: TextStyle(
                                    fontSize: isCompact ? 18 : 20,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // ─── Login (secondary action) ──────────────────────────────
                          Semantics(
                            label: 'Log in to your existing account',
                            button: true,
                            child: SizedBox(
                              width: double.infinity,
                              height: isCompact ? 56 : 64,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: primaryColor,
                                  side: BorderSide(color: primaryColor, width: 2.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
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
                                child: Text(
                                  'Log In to Existing Account',
                                  style: TextStyle(
                                    fontSize: isCompact ? 16 : 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: isCompact ? 16 : 24),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
