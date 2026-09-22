import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/accessible_button.dart';
import '../../../home/presentation/screens/home_shell_screen.dart';
import '../../providers/auth_provider.dart';

class VerifyCodeScreen extends ConsumerStatefulWidget {
  const VerifyCodeScreen({super.key});

  @override
  ConsumerState<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends ConsumerState<VerifyCodeScreen> {
  final _codeController = TextEditingController(text: '1234');

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _handleVerify() async {
    final success = await ref.read(authProvider.notifier).verifyCode(_codeController.text);

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('رمز التحقق / Verification Code'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const Icon(Icons.mark_email_read_outlined, size: 70, color: AppColors.primary),
              const SizedBox(height: 24),
              const Text(
                'أدخل رمز التحقق المرسل لهاتفك 📲\nEnter Verification Code',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '(رمز التجربة هو 1234 / Demo code: 1234)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),
              if (authState.error != null) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.emergencyContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    authState.error!,
                    style: const TextStyle(
                      color: AppColors.emergency,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
              ],
              Semantics(
                label: 'رمز التحقق المكون من 4 أرقام / 4 digit OTP Code',
                child: TextField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 16,
                  ),
                  maxLength: 4,
                  decoration: const InputDecoration(
                    hintText: '0000',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              AccessibleButton(
                label: authState.isLoading ? 'جاري التأكيد...' : 'تأكيد الحساب / Verify Account',
                semanticLabel: 'زر تأكيد رمز التحقق / Verify Code Button',
                onPressed: authState.isLoading ? () {} : _handleVerify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
