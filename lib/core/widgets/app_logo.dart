import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Rafiq (رفيق) brand logo widget using the official Figma assets:
/// - `assets/images/rafiq_logo_day.png` (Day mode)
/// - `assets/images/rafiq_logo_night.png` (Night mode)
/// - `assets/images/rafiq_logo_full.png` (Full unedited emblem)
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 44,
    this.height,
    this.useFullEmblem = false,
  });

  final double size;
  final double? height;
  final bool useFullEmblem;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final assetPath = useFullEmblem
        ? 'assets/images/rafiq_logo_full.png'
        : (isDark
            ? 'assets/images/rafiq_logo_night.png'
            : 'assets/images/rafiq_logo_day.png');
    final boxHeight = height ?? (size * 1.28);

    return Semantics(
      label: 'شعار رفيق / Rafiq Logo',
      image: true,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.24),
        child: Image.asset(
          assetPath,
          width: size,
          height: boxHeight,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: isDark ? AppColorsDark.primary : AppColors.rafiqPrimary,
                borderRadius: BorderRadius.circular(size * 0.28),
              ),
              child: Icon(
                Icons.handshake_rounded,
                color: AppColors.textLight,
                size: size * 0.55,
              ),
            );
          },
        ),
      ),
    );
  }
}
