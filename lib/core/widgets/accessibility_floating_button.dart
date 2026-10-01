import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_settings_provider.dart';
import '../theme/app_colors.dart';
import 'demo_snackbar.dart';

/// Floating Action Button that triggers the Accessibility Quick Actions Menu.
class AccessibilityFloatingButton extends ConsumerWidget {
  const AccessibilityFloatingButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    final primaryColor = isDark ? AppColorsDark.primary : AppColors.primary;

    return Semantics(
      button: true,
      label: l10n.accessibilityFabTooltip,
      child: Tooltip(
        message: l10n.accessibilityFabTooltip,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: isDark ? 0.5 : 0.35),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: FloatingActionButton(
            heroTag: 'accessibility_fab',
            onPressed: () {
              HapticFeedback.selectionClick();
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const AccessibilityMenuSheet(),
              );
            },
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            elevation: 4,
            shape: const CircleBorder(),
            child: const Icon(
              Icons.accessibility_new_rounded,
              size: 32,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// The Accessibility Quick Actions bottom sheet modal.
class AccessibilityMenuSheet extends ConsumerWidget {
  const AccessibilityMenuSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final a11y = ref.watch(accessibilityProvider);
    final notifier = ref.read(accessibilityProvider.notifier);

    final primaryColor = isDark ? AppColorsDark.primary : AppColors.primary;
    final primaryContainer =
        isDark ? AppColorsDark.primaryContainer : AppColors.primaryContainer;
    final textPrimary =
        isDark ? AppColorsDark.textPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColorsDark.textSecondary : AppColors.textSecondary;
    final surface = isDark ? AppColorsDark.surface : AppColors.surface;
    final border = isDark ? AppColorsDark.border : AppColors.border;

    final fontPercent = '${(a11y.fontScale * 100).round()}%';
    final spacingText = a11y.letterSpacing == 0.0
        ? l10n.normal
        : '+${a11y.letterSpacing.toStringAsFixed(1)}';
    final contrastText = a11y.contrastLevel <= 1.0
        ? l10n.normal
        : a11y.contrastLevel <= 1.25
            ? l10n.large
            : l10n.extraLarge;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.6 : 0.15),
            blurRadius: 28,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        14,
        20,
        MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header: Title & Close
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.accessibility_new_rounded,
                    color: primaryColor,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.accessibilityMenu,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 28),
                  tooltip: 'Close',
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ─── 1. Font Size Control ───
            _A11yControlCard(
              title: l10n.fontSize,
              valueLabel: fontPercent,
              icon: Icons.format_size_rounded,
              isDark: isDark,
              onDecrease: () {
                HapticFeedback.selectionClick();
                notifier.decreaseFontSize();
              },
              onIncrease: () {
                HapticFeedback.selectionClick();
                notifier.increaseFontSize();
              },
              decreaseTooltip: l10n.decreaseFontSize,
              increaseTooltip: l10n.increaseFontSize,
              decreaseIconText: 'A-',
              increaseIconText: 'A+',
            ),
            const SizedBox(height: 14),

            // ─── 2. Text Spacing Control ───
            _A11yControlCard(
              title: l10n.textSpacing,
              valueLabel: spacingText,
              icon: Icons.format_line_spacing_rounded,
              isDark: isDark,
              onDecrease: () {
                HapticFeedback.selectionClick();
                notifier.decreaseTextSpacing();
              },
              onIncrease: () {
                HapticFeedback.selectionClick();
                notifier.increaseTextSpacing();
              },
              decreaseTooltip: l10n.decreaseTextSpacing,
              increaseTooltip: l10n.increaseTextSpacing,
              decreaseIcon: Icons.remove_rounded,
              increaseIcon: Icons.add_rounded,
            ),
            const SizedBox(height: 14),

            // ─── 3. Contrast Level Control ───
            _A11yControlCard(
              title: l10n.contrast,
              valueLabel: contrastText,
              icon: Icons.tonality_rounded,
              isDark: isDark,
              onDecrease: () {
                HapticFeedback.selectionClick();
                notifier.decreaseContrast();
              },
              onIncrease: () {
                HapticFeedback.selectionClick();
                notifier.increaseContrast();
              },
              decreaseTooltip: l10n.decreaseContrast,
              increaseTooltip: l10n.increaseContrast,
              decreaseIcon: Icons.remove_rounded,
              increaseIcon: Icons.add_rounded,
            ),
            const SizedBox(height: 14),

            // ─── 4. High Contrast Mode Toggle ───
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isDark ? AppColorsDark.surface : AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: border, width: 1.5),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.contrast_rounded, color: primaryColor, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.highContrastMode,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                        Text(
                          a11y.highContrast ? l10n.onText : l10n.offText,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch.adaptive(
                    value: a11y.highContrast,
                    activeTrackColor: primaryColor,
                    onChanged: (val) {
                      HapticFeedback.selectionClick();
                      notifier.toggleHighContrast();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ─── 5. Read Aloud Button ───
            ElevatedButton.icon(
              onPressed: () {
                HapticFeedback.mediumImpact();
                Navigator.pop(context);
                showDemoSnackBar(context, '🔊 ${l10n.readAloudSpeaking}');
              },
              icon: const Icon(Icons.record_voice_over_rounded, size: 26),
              label: Text(
                l10n.readAloud,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 3,
              ),
            ),
            const SizedBox(height: 10),

            // ─── 6. Reset to Defaults ───
            TextButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                notifier.resetDefaults();
                showDemoSnackBar(context, l10n.resetDefaults);
              },
              icon: const Icon(Icons.restore_rounded, size: 22),
              label: Text(
                l10n.resetDefaults,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              style: TextButton.styleFrom(
                foregroundColor: textSecondary,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _A11yControlCard extends StatelessWidget {
  const _A11yControlCard({
    required this.title,
    required this.valueLabel,
    required this.icon,
    required this.isDark,
    required this.onDecrease,
    required this.onIncrease,
    required this.decreaseTooltip,
    required this.increaseTooltip,
    this.decreaseIcon,
    this.increaseIcon,
    this.decreaseIconText,
    this.increaseIconText,
  });

  final String title;
  final String valueLabel;
  final IconData icon;
  final bool isDark;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final String decreaseTooltip;
  final String increaseTooltip;
  final IconData? decreaseIcon;
  final IconData? increaseIcon;
  final String? decreaseIconText;
  final String? increaseIconText;

  @override
  Widget build(BuildContext context) {
    final primaryColor = isDark ? AppColorsDark.primary : AppColors.primary;
    final primaryContainer =
        isDark ? AppColorsDark.primaryContainer : AppColors.primaryContainer;
    final textPrimary =
        isDark ? AppColorsDark.textPrimary : AppColors.textPrimary;
    final border = isDark ? AppColorsDark.border : AppColors.border;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.surface : AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: primaryColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    valueLabel,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Step Down Button (min 48x48)
          Semantics(
            button: true,
            label: decreaseTooltip,
            child: Tooltip(
              message: decreaseTooltip,
              child: InkWell(
                onTap: onDecrease,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: decreaseIconText != null
                      ? Text(
                          decreaseIconText!,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: primaryColor,
                          ),
                        )
                      : Icon(
                          decreaseIcon ?? Icons.remove_rounded,
                          color: primaryColor,
                          size: 26,
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Step Up Button (min 48x48)
          Semantics(
            button: true,
            label: increaseTooltip,
            child: Tooltip(
              message: increaseTooltip,
              child: InkWell(
                onTap: onIncrease,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: increaseIconText != null
                      ? Text(
                          increaseIconText!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          increaseIcon ?? Icons.add_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
