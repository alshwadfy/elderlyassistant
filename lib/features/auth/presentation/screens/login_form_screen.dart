import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/demo_snackbar.dart';
import '../../../home/presentation/screens/home_shell_screen.dart';
import '../../providers/auth_provider.dart';
import 'register_screen.dart';

/// Login form screen — matches the Figma UI (media_1790862407812.png).
///
/// Features:
/// • Top logo branding
/// • "Welcome Back" header + subtitle
/// • Form card with Email, Password, Forgot Password?, and "Log In Safely" button
/// • "New here? Create a free account" link
/// • Bottom "Assistant Active" status card with elderly woman thumbnail
class LoginFormScreen extends ConsumerStatefulWidget {
  const LoginFormScreen({super.key});

  @override
  ConsumerState<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends ConsumerState<LoginFormScreen> {
  final _emailController = TextEditingController(text: 'fatma.care@assistant.com');
  final _passwordController = TextEditingController(text: 'password');
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final success = await ref.read(authProvider.notifier).login(
          _emailController.text,
          _passwordController.text,
        );

    if (success && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeShellScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark ? AppColorsDark.primary : const Color(0xFF0F3E8E);
    final brandBlue = isDark ? AppColorsDark.primaryLight : const Color(0xFF1E3A8A);
    final textSecondary = isDark ? AppColorsDark.textSecondary : const Color(0xFF4B6B94);
    final cardBg = isDark ? AppColorsDark.surface : Colors.white;
    final cardBorder = isDark ? AppColorsDark.border : const Color(0xFFDCE6F5);

    return Scaffold(
      backgroundColor: isDark ? AppColorsDark.background : const Color(0xFFF2F6FB),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ─── App Branding ───────────────────────────────────────────
              Row(
                children: [
                  const AppLogo(size: 34),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'AI Elderly',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: brandBlue,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        'Assistant',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: brandBlue,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ─── Heading ────────────────────────────────────────────────
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: brandBlue,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in below to start speaking with your assistant. We are here to support you.',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: textSecondary,
                  height: 1.45,
                ),
              ),

              const SizedBox(height: 20),

              // ─── Error banner ───────────────────────────────────────────
              if (authState.error != null) ...[
                _ErrorBanner(message: authState.error!, isDark: isDark),
                const SizedBox(height: 16),
              ],

              // ─── Form Card (White Rounded Card per Figma) ────────────────
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: cardBorder, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Email Label & Field
                    _FieldLabel(label: 'Email Address', isDark: isDark),
                    const SizedBox(height: 8),
                    Semantics(
                      label: 'Email Address',
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColorsDark.textPrimary : Colors.black87,
                        ),
                        decoration: InputDecoration(
                          hintText: 'e.g. fatma.care@assistant.com',
                          prefixIcon: Icon(
                            Icons.mail_outline_rounded,
                            size: 24,
                            color: brandBlue,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: brandBlue.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: brandBlue,
                              width: 2.0,
                            ),
                          ),
                          filled: true,
                          fillColor: isDark ? AppColorsDark.surface : Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Password Label & Field
                    _FieldLabel(label: 'Password', isDark: isDark),
                    const SizedBox(height: 8),
                    Semantics(
                      label: 'Password',
                      child: TextField(
                        controller: _passwordController,
                        obscureText: _obscure,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColorsDark.textPrimary : Colors.black87,
                        ),
                        decoration: InputDecoration(
                          hintText: '••••••••••••',
                          prefixIcon: Icon(
                            Icons.lock_outline_rounded,
                            size: 24,
                            color: brandBlue,
                          ),
                          suffixIcon: Semantics(
                            label: _obscure ? 'Show password' : 'Hide password',
                            child: IconButton(
                              tooltip: _obscure ? 'Show password' : 'Hide password',
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 24,
                                color: textSecondary,
                              ),
                              onPressed: () => setState(() => _obscure = !_obscure),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: brandBlue.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: brandBlue,
                              width: 2.0,
                            ),
                          ),
                          filled: true,
                          fillColor: isDark ? AppColorsDark.surface : Colors.white,
                        ),
                      ),
                    ),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          showDemoSnackBar(context, 'Password reset is coming soon.');
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: brandBlue,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Log In Safely button
                    Semantics(
                      label: authState.isLoading ? 'Signing in, please wait' : 'Log in safely',
                      button: true,
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 3,
                          ),
                          onPressed: authState.isLoading ? null : _handleLogin,
                          child: authState.isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Log In Safely',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ─── Create Account Link ─────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'New here? ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Create a free account',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: brandBlue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ─── Assistant Active Bottom Card (per Figma) ────────────────
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColorsDark.surface
                      : const Color(0xFFE9F1FC),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark
                        ? AppColorsDark.border
                        : const Color(0xFFD4E3F7),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    // Woman thumbnail (decorative, matches Figma active card)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(
                        'assets/elderly-assistant-photo.png',
                        width: 58,
                        height: 58,
                        fit: BoxFit.cover,
                        semanticLabel: 'Assistant avatar',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF22C55E),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Assistant Active',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: brandBlue,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '"Your voice. Our support." Simply tap, talk and stay connected.',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: textSecondary,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Shared sub-widgets ────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label, required this.isDark});
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: isDark ? AppColorsDark.textPrimary : const Color(0xFF1E3A8A),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message, required this.isDark});
  final String message;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final emergencyColor = isDark ? AppColorsDark.emergency : AppColors.emergency;
    final containerColor = isDark ? AppColorsDark.emergencyContainer : AppColors.emergencyContainer;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: emergencyColor, width: 2),
      ),
      child: Row(
        children: [
          Icon(Icons.error_rounded, color: emergencyColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: emergencyColor,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
