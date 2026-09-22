import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/accessible_button.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/demo_snackbar.dart';
import '../../../home/presentation/screens/home_shell_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _selected = 0;
  final _nameController = TextEditingController(text: 'Eleanor');

  static const _voices = [
    (
      'Warm & Gentle',
      'Soothing tone, slower pace, and friendly heartfelt check-ins.',
    ),
    (
      'Clear & Direct',
      'Crisp volume, concise updates, and clear medication prompts.',
    ),
    (
      'Family Member Mode',
      'Warm conversational tone with thoughtful daily stories and recap.',
    ),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Row(
              children: [
                AppLogo(size: 40),
                SizedBox(width: 12),
                Text(
                  'AI Elderly Assistant',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
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
            const SizedBox(height: 24),
            for (var i = 0; i < _voices.length; i++)
              _VoiceOption(
                title: _voices[i].$1,
                description: _voices[i].$2,
                isSelected: _selected == i,
                onTap: () => setState(() => _selected = i),
              ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {
                showDemoSnackBar(
                  context,
                  'Playing ${_voices[_selected].$1} sample (demo)',
                );
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Play Voice Sample'),
            ),
            const SizedBox(height: 24),
            const Text(
              'What should I call you?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'e.g. Eleanor',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 24),
            AccessibleButton(
              label: 'Complete Setup & Go Home',
              semanticLabel: 'Complete setup and go to Home',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeShellScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _VoiceOption extends StatelessWidget {
  const _VoiceOption({
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: title,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
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
                  Icon(
                    isSelected
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: isSelected ? AppColors.primary : AppColors.textMuted,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 36),
                child: Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
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
