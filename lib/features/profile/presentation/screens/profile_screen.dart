import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/app_settings_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/demo_snackbar.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentLocale = ref.watch(localeProvider);
    final currentThemeMode = ref.watch(themeModeProvider);

    final isDark = currentThemeMode == ThemeMode.dark;
    final isArabic = currentLocale.languageCode == 'ar';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.profileSettings,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
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
                    child: Text(l10n.edit, style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ─── Settings Controls ───
          _SettingsSwitchTile(
            icon: Icons.language_outlined,
            title: l10n.language,
            subtitle: isArabic ? l10n.arabic : l10n.english,
            value: isArabic,
            onChanged: (val) {
              ref.read(localeProvider.notifier).toggleLanguage();
            },
            activeText: 'العربية',
            inactiveText: 'English',
          ),
          _SettingsSwitchTile(
            icon: isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
            title: l10n.appearance,
            subtitle: isDark ? l10n.darkMode : l10n.lightMode,
            value: isDark,
            onChanged: (val) {
              ref.read(themeModeProvider.notifier).toggleTheme();
            },
            activeText: l10n.darkMode,
            inactiveText: l10n.lightMode,
          ),

          const SizedBox(height: 12),

          _SettingsItem(
            icon: Icons.volume_up_outlined,
            title: l10n.voiceSettings,
            subtitle: l10n.voiceSettingsSub,
            onTap: () => showDemoSnackBar(context, 'Voice settings (demo)'),
          ),
          _SettingsItem(
            icon: Icons.notifications_none_outlined,
            title: l10n.notifications,
            subtitle: l10n.notificationsSub,
            onTap: () => showDemoSnackBar(context, 'Notifications (demo)'),
          ),
          _SettingsItem(
            icon: Icons.security_outlined,
            title: l10n.privacySecurity,
            subtitle: l10n.privacySub,
            onTap: () => showDemoSnackBar(context, 'Privacy settings (demo)'),
          ),
          _SettingsItem(
            icon: Icons.info_outline,
            title: l10n.about,
            subtitle: l10n.aboutSub,
            onTap: () => showDemoSnackBar(context, 'AI Elderly Assistant v1.0.0'),
          ),
        ],
      ),
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  const _SettingsSwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.activeText,
    required this.inactiveText,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String activeText;
  final String inactiveText;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
            ),
          ],
        ),
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
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            fontSize: 14,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
