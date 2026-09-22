import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/accessible_button.dart';
import '../../../home/presentation/screens/home_shell_screen.dart';
import '../../providers/auth_provider.dart';
import 'register_screen.dart';

class LoginFormScreen extends ConsumerStatefulWidget {
  const LoginFormScreen({super.key});

  @override
  ConsumerState<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends ConsumerState<LoginFormScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final success = await ref.read(authProvider.notifier).login(
          _phoneController.text,
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل الدخول / Login'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Image.asset('assets/logo.png', width: 90, height: 90),
              ),
              const SizedBox(height: 24),
              const Text(
                'مرحباً بك مجدداً 👋\nWelcome Back',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 32),
              if (authState.error != null) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.emergencyContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.emergency),
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
                label: 'رقم الهاتف / Phone Number Input',
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                    labelText: 'رقم الهاتف / Phone Number',
                    prefixIcon: Icon(Icons.phone, size: 28),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Semantics(
                label: 'كلمة المرور / Password Input',
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                    labelText: 'كلمة المرور / Password',
                    prefixIcon: Icon(Icons.lock, size: 28),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              AccessibleButton(
                label: authState.isLoading ? 'جاري التحقق...' : 'دخول / Login',
                semanticLabel: 'زر تسجيل الدخول / Login Submit Button',
                onPressed: authState.isLoading ? () {} : _handleLogin,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'ليس لديك حساب؟ ',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: const Text(
                      'إنشاء حساب جديد',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
