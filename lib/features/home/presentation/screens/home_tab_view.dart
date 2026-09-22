import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../screens/home_shell_screen.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  void _open(BuildContext context, String route) {
    Navigator.of(context).pushNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.wb_sunny, color: AppColors.warning, size: 48),
          const SizedBox(height: 12),
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
          const SizedBox(height: 32),
          Semantics(
            label: 'Tap to speak to assistant',
            button: true,
            child: InkWell(
              onTap: () => _open(context, AppShellRoutes.voice),
              customBorder: const CircleBorder(),
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 30,
                      spreadRadius: 8,
                      offset: const Offset(0, 8),
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
          const SizedBox(height: 20),
          const Text(
            'Tap to speak',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Or say "Hey Assistant"',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.95,
            children: [
              _FeatureCard(
                icon: Icons.local_hospital_outlined,
                title: 'Find a Doctor',
                subtitle: 'Search nearby doctors and book appointments',
                onTap: () => _open(context, AppShellRoutes.doctors),
              ),
              _FeatureCard(
                icon: Icons.medication_outlined,
                title: 'Medication Reminders',
                subtitle: 'Never miss your medication',
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppShellRoutes.reminders,
                    (route) => false,
                  );
                },
              ),
              _FeatureCard(
                icon: Icons.people_outline,
                title: 'Contact Family',
                subtitle: 'Quickly reach your family members',
                onTap: () => _open(context, AppShellRoutes.family),
              ),
              _FeatureCard(
                icon: Icons.error_outline,
                title: 'Emergency Help',
                subtitle: 'Get immediate assistance',
                isEmergency: true,
                onTap: () => _open(context, AppShellRoutes.emergency),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isEmergency = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isEmergency;

  @override
  Widget build(BuildContext context) {
    final color = isEmergency ? AppColors.emergency : AppColors.primary;
    return Semantics(
      button: true,
      label: title,
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isEmergency
                        ? AppColors.emergencyContainer
                        : AppColors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const Spacer(),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
