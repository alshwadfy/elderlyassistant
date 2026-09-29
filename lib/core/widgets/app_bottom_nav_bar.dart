import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const labels = ['Home', 'Schedule', 'Reminders', 'More'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.surface : AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
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
            indicatorColor: isDark ? AppColorsDark.primaryContainer : AppColors.primaryContainer,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined, size: 26),
                selectedIcon: Icon(Icons.home_rounded, color: AppColors.primary, size: 28),
                label: 'Home',
                tooltip: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_today_outlined, size: 24),
                selectedIcon: Icon(Icons.calendar_month_rounded, color: AppColors.primary, size: 26),
                label: 'Schedule',
                tooltip: 'Schedule and appointments',
              ),
              NavigationDestination(
                icon: Icon(Icons.notifications_none_outlined, size: 26),
                selectedIcon: Icon(Icons.notifications_rounded, color: AppColors.primary, size: 28),
                label: 'Reminders',
                tooltip: 'Medication reminders',
              ),
              NavigationDestination(
                icon: Icon(Icons.more_horiz_rounded, size: 26),
                selectedIcon: Icon(Icons.more_horiz_rounded, color: AppColors.primary, size: 28),
                label: 'More',
                tooltip: 'Profile and settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

