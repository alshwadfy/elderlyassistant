import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/accessible_button.dart';
import '../../providers/auth_provider.dart';
import 'verify_code_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emergencyContactController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    final success = await ref.read(authProvider.notifier).register(
          name: _nameController.text,
          phone: _phoneController.text,
          emergencyContact: _emergencyContactController.text,
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء حساب جديد / Create Account'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              const Text(
                'انضم إلينا بخطوات بسيطة ✨\nCreate Your Account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
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
                label: 'الاسم الكامل / Full Name Input',
                child: TextField(
                  controller: _nameController,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                    labelText: 'الاسم الكامل / Full Name',
                    prefixIcon: Icon(Icons.person, size: 28),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                label: 'رقم هاتف الطوارئ للتواصل / Emergency Contact Phone',
                child: TextField(
                  controller: _emergencyContactController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                    labelText: 'رقم قريب/طوارئ / Emergency Contact',
                    prefixIcon: Icon(Icons.contact_phone, size: 28),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              AccessibleButton(
                label: authState.isLoading ? 'جاري الإرسال...' : 'متابعة / Continue',
                semanticLabel: 'زر المتابعة لإرسال كود التحقق',
                onPressed: authState.isLoading ? () {} : _handleRegister,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
