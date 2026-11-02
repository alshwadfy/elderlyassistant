import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Persistent full-width red emergency button (`أحتاج مساعدة`) matching Figma `#10:3476`.
class RafiqEmergencyButton extends StatelessWidget {
  const RafiqEmergencyButton({
    super.key,
    required this.onPressed,
    this.label = 'أحتاج مساعدة',
  });

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? const Color(0xFFDC2626)
        : AppColors.emergencyRed;

    return Semantics(
      button: true,
      label: label,
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
          icon: const Icon(
            Icons.warning_amber_rounded,
            size: 24,
            color: Colors.white,
          ),
          label: Text(
            label,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
