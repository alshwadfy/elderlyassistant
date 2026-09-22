import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../voice_assistant/presentation/screens/voice_assistant_screen.dart';
import '../../../emergency/presentation/screens/emergency_screen.dart';

class HomeTabView extends ConsumerWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.wb_sunny, color: AppColors.warning, size: 48),
          const SizedBox(height: 16),
          const Text(
            'Good morning, Adel',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'How can I help you today?',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 48),
          
          // Main Voice Button
          Semantics(
            label: 'Tap to speak to assistant',
            button: true,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VoiceAssistantScreen()),
                );
              },
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 10,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.mic_none,
                  size: 80,
                  color: AppColors.textLight,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Tap to speak',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Or say "Hey Assistant"',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 48),

          // Feature Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.9,
            children: [
              _buildFeatureCard(
                context,
                icon: Icons.local_hospital_outlined,
                title: 'Find a Doctor',
                subtitle: 'Search nearby doctors and book appointments',
                onTap: () {},
              ),
              _buildFeatureCard(
                context,
                icon: Icons.medication_outlined,
                title: 'Medication Reminders',
                subtitle: 'Never miss your medication',
                onTap: () {},
              ),
              _buildFeatureCard(
                context,
                icon: Icons.people_outline,
                title: 'Contact Family',
                subtitle: 'Quickly reach your family members',
                onTap: () {},
              ),
              _buildFeatureCard(
                context,
                icon: Icons.error_outline,
                title: 'Emergency Help',
                subtitle: 'Get immediate assistance',
                isEmergency: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EmergencyScreen()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isEmergency = false,
  }) {
    final color = isEmergency ? AppColors.emergency : AppColors.primary;
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isEmergency ? AppColors.emergencyContainer : AppColors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const Spacer(),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
