import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import 'login_form_screen.dart';
import 'verify_code_screen.dart';

/// Register screen.
///
/// Design decisions per ui.md:
/// • Bold labels ABOVE each field — label never disappears while typing.
/// • All text ≥ 18sp.
/// • Privacy policy checkbox text 18sp (not 14sp).
/// • Error banner: icon + text, not just colour.
/// • Continue button 64dp.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _acceptedPrivacy = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_acceptedPrivacy) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please accept the privacy policy to continue.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      );
      return;
    }

    final success = await ref.read(authProvider.notifier).register(
          name: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          password: _passwordController.text,
        );

    if (success && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VerifyCodeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark ? AppColorsDark.primary : AppColors.primary;
    final textPrimary = isDark ? AppColorsDark.textPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColorsDark.textSecondary : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: isDark ? AppColorsDark.background : AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Semantics(
          label: 'Go back',
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              size: 28,
              color: textPrimary,
            ),
            onPressed: () => Navigator.maybePop(context),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ─── Heading ────────────────────────────────────────────────
              Text(
                'Create Your Account',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: primaryColor,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Join our caring community. We are here to support you every step of the way.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: textSecondary,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 28),

              // ─── Error banner ────────────────────────────────────────────
              if (authState.error != null) ...[
                _ErrorBanner(message: authState.error!, isDark: isDark),
                const SizedBox(height: 24),
              ],

              // ─── Full Name ───────────────────────────────────────────────
              _FieldLabel(label: 'Full Name', isDark: isDark),
              const SizedBox(height: 8),
              Semantics(
                label: 'Full Name',
                child: TextField(
                  controller: _nameController,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: textPrimary),
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    hintText: 'e.g. Eleanor Vance',
                    prefixIcon: Icon(Icons.person_outline_rounded, size: 26, color: primaryColor),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // ─── Email ───────────────────────────────────────────────────
              _FieldLabel(label: 'Email Address', isDark: isDark),
              const SizedBox(height: 8),
              Semantics(
                label: 'Email Address',
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: textPrimary),
                  decoration: InputDecoration(
                    hintText: 'e.g. name@email.com',
                    prefixIcon: Icon(Icons.mail_outline_rounded, size: 26, color: primaryColor),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // ─── Phone ───────────────────────────────────────────────────
              _FieldLabel(label: 'Phone Number', isDark: isDark),
              const SizedBox(height: 8),
              Semantics(
                label: 'Phone Number',
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Your phone or emergency contact number',
                    prefixIcon: Icon(Icons.phone_outlined, size: 26, color: primaryColor),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // ─── Password ────────────────────────────────────────────────
              _FieldLabel(label: 'Create a Password', isDark: isDark),
              const SizedBox(height: 8),
              Semantics(
                label: 'Create a Password',
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: textPrimary),
                  decoration: InputDecoration(
                    hintText: 'At least 8 characters',
                    prefixIcon: Icon(Icons.lock_outline_rounded, size: 26, color: primaryColor),
                    suffixIcon: Semantics(
                      label: _obscurePassword ? 'Show password' : 'Hide password',
                      child: IconButton(
                        tooltip: _obscurePassword ? 'Show password' : 'Hide password',
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 26,
                          color: textSecondary,
                        ),
                        onPressed: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ─── Privacy checkbox ────────────────────────────────────────
              Semantics(
                label: _acceptedPrivacy
                    ? 'Privacy policy accepted'
                    : 'I agree to the Privacy Policy — tap to accept',
                child: InkWell(
                  onTap: () =>
                      setState(() => _acceptedPrivacy = !_acceptedPrivacy),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: Checkbox(
                            value: _acceptedPrivacy,
                            onChanged: (v) =>
                                setState(() => _acceptedPrivacy = v ?? false),
                            materialTapTargetSize:
                                MaterialTapTargetSize.padded,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'I agree to the Privacy Policy. My personal information is stored securely and is only shared with my caregivers.',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: textPrimary,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ─── Submit button ───────────────────────────────────────────
              Semantics(
                label: authState.isLoading
                    ? 'Sending verification code, please wait'
                    : 'Continue to verification',
                button: true,
                child: SizedBox(
                  height: 64,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: authState.isLoading ? null : _handleRegister,
                    child: authState.isLoading
                        ? const SizedBox(
                            width: 26,
                            height: 26,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Continue to Verification',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ─── Login link ──────────────────────────────────────────────
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginFormScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Already have an account? Log in',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Shared widgets ──────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label, required this.isDark});
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
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
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
