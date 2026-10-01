import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final navActive = isDark ? AppColorsDark.navActive : AppColors.navActive;
    final navInactive = isDark ? AppColorsDark.navInactive : AppColors.navInactive;
    final primaryContainer = isDark ? AppColorsDark.primaryContainer : AppColors.primaryContainer;
    final surface = isDark ? AppColorsDark.surface : AppColors.surface;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 74,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: onTap,
            height: 62,
            backgroundColor: Colors.transparent,
            elevation: 0,
            indicatorColor: primaryContainer,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.home_outlined, size: 26, color: navInactive),
                selectedIcon: Icon(Icons.home_rounded, color: navActive, size: 28),
                label: l10n.navHome,
                tooltip: l10n.navHome,
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_today_outlined, size: 24, color: navInactive),
                selectedIcon: Icon(Icons.calendar_month_rounded, color: navActive, size: 26),
                label: l10n.navSchedule,
                tooltip: l10n.navSchedule,
              ),
              NavigationDestination(
                icon: Icon(Icons.notifications_none_outlined, size: 26, color: navInactive),
                selectedIcon: Icon(Icons.notifications_rounded, color: navActive, size: 28),
                label: l10n.navReminders,
                tooltip: l10n.navReminders,
              ),
              NavigationDestination(
                icon: Icon(Icons.more_horiz_rounded, size: 26, color: navInactive),
                selectedIcon: Icon(Icons.more_horiz_rounded, color: navActive, size: 28),
                label: l10n.navMore,
                tooltip: l10n.navMore,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
