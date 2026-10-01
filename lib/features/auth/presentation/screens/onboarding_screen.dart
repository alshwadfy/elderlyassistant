import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/accessible_button.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../home/presentation/screens/home_shell_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _nameController = TextEditingController(text: 'Eleanor');

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
    final bgColor = isDark ? AppColorsDark.background : AppColors.background;

    return Scaffold(
      backgroundColor: bgColor,
      // ─── Static top header ───
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const AppLogo(size: 36),
            const SizedBox(width: 10),
            Text(
              'AI Elderly Assistant',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        children: [
          // ─── Elderly Assistant Photo ───
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              'assets/elderly-assistant-photo.png',
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              semanticLabel: 'Elderly woman using AI voice assistant',
            ),
          ),
          const SizedBox(height: 24),

          // ─── Headline ───
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
            'Your voice companion is ready to help you stay safe, healthy, and connected.',
            style: TextStyle(
              fontSize: 16,
              color: textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),

          // ─── Name field ───
          Text(
            'What should I call you?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _nameController,
            style: TextStyle(fontSize: 18, color: textPrimary),
            decoration: InputDecoration(
              hintText: 'e.g. Eleanor',
              prefixIcon: Icon(Icons.person_outline, color: primaryColor),
            ),
          ),
          const SizedBox(height: 32),

          // ─── CTA Button ───
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
    );
  }
}
