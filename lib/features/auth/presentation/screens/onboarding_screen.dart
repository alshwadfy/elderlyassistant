import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/accessible_button.dart';
import '../../../home/presentation/screens/home_shell_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Row(
                children: [
                  Image.asset('assets/logo.png', width: 40, height: 40),
                  const SizedBox(width: 12),
                  const Text(
                    'AI Elderly Assistant',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'Meet Your Assistant',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose how you\'d like your companion to speak with you. You can change this at any time.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              
              // Voice Options
              _buildVoiceOption('Warm & Gentle', 'Soothing tone, slower pace, and friendly heartfelt check-ins.', true),
              _buildVoiceOption('Clear & Direct', 'Crisp volume, concise updates, and clear medication prompts.', false),
              _buildVoiceOption('Family Member Mode', 'Warm conversational tone with thoughtful daily stories and recap.', false),
              
              const Spacer(),
              const Text(
                'What should I call you?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'e.g. Eleanor',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 24),
              AccessibleButton(
                label: 'Complete Setup & Go Home \u2192',
                semanticLabel: 'Complete Setup and go to Home',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeShellScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVoiceOption(String title, String description, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(isSelected ? Icons.check_circle : Icons.radio_button_unchecked, color: isSelected ? AppColors.primary : AppColors.textMuted),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 36.0),
            child: Text(
              description,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
