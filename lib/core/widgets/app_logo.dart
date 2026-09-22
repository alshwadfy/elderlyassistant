import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// App mark with a fallback icon when the asset is missing.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 32});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'AI Elderly Assistant logo',
      image: true,
      child: Image.asset(
        'assets/logo.png',
        width: size,
        height: size,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(size * 0.28),
            ),
            child: Icon(
              Icons.favorite,
              color: AppColors.textLight,
              size: size * 0.55,
            ),
          );
        },
      ),
    );
  }
}
