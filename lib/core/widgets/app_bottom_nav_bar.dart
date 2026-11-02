import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';

/// Rafiq (رفيق) Bottom Navigation Bar matching Figma `#10:3566` (Day) & `#7:4851` (Night).
///
/// 4 permanent-label tabs:
/// 0: `الرئيسية` (Home)
/// 1: `المستشفيات` (Nearby Hospitals & Next Visit)
/// 2: `الأدوية` (My Medicines Timeline)
/// 3: `حسابي` (Profile & Settings)
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = l10n.locale.languageCode == 'ar';

    final surface = isDark ? AppColorsDark.surface : AppColors.surface;
    final borderColor = isDark ? AppColorsDark.cardBorder : AppColors.cardBorder;
    final activePillColor = isDark
        ? AppColorsDark.primary
        : AppColors.rafiqPrimary;
    final inactiveColor = isDark
        ? AppColorsDark.navInactive
        : AppColors.textSecondary;

    final items = <_NavBarItemData>[
      _NavBarItemData(
        icon: Icons.home_outlined,
        selectedIcon: Icons.home_rounded,
        label: isAr ? 'الرئيسية' : l10n.navHome,
      ),
      _NavBarItemData(
        icon: Icons.local_hospital_outlined,
        selectedIcon: Icons.local_hospital_rounded,
        label: isAr ? 'المستشفيات' : 'Hospitals',
      ),
      _NavBarItemData(
        icon: Icons.medication_outlined,
        selectedIcon: Icons.medication_rounded,
        label: isAr ? 'الأدوية' : 'Medicines',
      ),
      _NavBarItemData(
        icon: Icons.person_outline_rounded,
        selectedIcon: Icons.person_rounded,
        label: isAr ? 'حسابي' : 'Account',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: surface,
        border: Border(
          top: BorderSide(color: borderColor, width: 1.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == currentIndex;
              return Expanded(
                child: Semantics(
                  button: true,
                  selected: isSelected,
                  label: item.label,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => onTap(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        constraints: const BoxConstraints(minHeight: 58),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? activePillColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isSelected ? item.selectedIcon : item.icon,
                              size: 24,
                              color: isSelected ? Colors.white : inactiveColor,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : inactiveColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavBarItemData {
  const _NavBarItemData({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}
