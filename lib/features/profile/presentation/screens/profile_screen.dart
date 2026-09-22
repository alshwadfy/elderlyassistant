import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/demo_snackbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Profile & Settings',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.primary,
                  child: Icon(
                    Icons.person_outline,
                    size: 40,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Adel Ahmed',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '+20 10 1234 5678',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showDemoSnackBar(context, 'Edit profile will use the API later');
                  },
                  child: const Text('Edit', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _SettingsItem(
            icon: Icons.volume_up_outlined,
            title: 'Voice Settings',
            subtitle: 'Language, voice, speed',
            onTap: () => showDemoSnackBar(context, 'Voice settings (demo)'),
          ),
          _SettingsItem(
            icon: Icons.notifications_none_outlined,
            title: 'Notifications',
            subtitle: 'Reminders, alerts',
            onTap: () => showDemoSnackBar(context, 'Notifications (demo)'),
          ),
          _SettingsItem(
            icon: Icons.security_outlined,
            title: 'Privacy & Security',
            subtitle: 'Data and permissions',
            onTap: () => showDemoSnackBar(context, 'Privacy settings (demo)'),
          ),
          _SettingsItem(
            icon: Icons.info_outline,
            title: 'About',
            subtitle: 'App version, support',
            onTap: () => showDemoSnackBar(context, 'AI Elderly Assistant v1.0.0'),
          ),
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      ),
    );
  }
}
