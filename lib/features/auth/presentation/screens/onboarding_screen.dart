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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark ? AppColorsDark.primary : AppColors.primary;
    final textPrimary = isDark ? AppColorsDark.textPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColorsDark.textSecondary : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: isDark ? AppColorsDark.background : AppColors.background,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            Row(
              children: [
                const AppLogo(size: 40),
                const SizedBox(width: 12),
                Text(
                  'AI Elderly Assistant',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              'Meet Your Assistant',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose how you\'d like your companion to speak with you. You can change this at any time.',
              style: TextStyle(
                fontSize: 16,
                color: textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            for (var i = 0; i < _voices.length; i++)
              _VoiceOption(
                title: _voices[i].$1,
                description: _voices[i].$2,
                isSelected: _selected == i,
                isDark: isDark,
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
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: BorderSide(color: primaryColor, width: 2),
                minimumSize: const Size(double.infinity, 52),
              ),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Play Voice Sample', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 24),
            Text(
              'What should I call you?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              style: TextStyle(fontSize: 18, color: textPrimary),
              decoration: InputDecoration(
                hintText: 'e.g. Eleanor',
                prefixIcon: Icon(Icons.person_outline, color: primaryColor),
              ),
            ),
            const SizedBox(height: 24),
            AccessibleButton(
              label: 'Complete Setup & Go Home',
              semanticLabel: 'Complete setup and go to Home',
              backgroundColor: primaryColor,
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
    required this.isDark,
    required this.onTap,
  });

  final String title;
  final String description;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primaryColor = isDark ? AppColorsDark.primary : AppColors.primary;
    final textPrimary = isDark ? AppColorsDark.textPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColorsDark.textSecondary : AppColors.textSecondary;
    final cardBg = isDark ? AppColorsDark.surface : AppColors.surface;
    final borderColor = isSelected
        ? primaryColor
        : (isDark ? AppColorsDark.border : AppColors.border);

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
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 2.5 : 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isSelected
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked,
                    color: isSelected
                        ? primaryColor
                        : (isDark ? AppColorsDark.textMuted : AppColors.textMuted),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: textPrimary,
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
                  style: TextStyle(
                    color: textSecondary,
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
