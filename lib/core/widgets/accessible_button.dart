import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AccessibleButton extends StatelessWidget {
  const AccessibleButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.semanticLabel,
    this.icon,
    this.backgroundColor = AppColors.primary,
    this.foregroundColor = AppColors.textLight,
    this.height = 56.0,
    this.width,
  });

  final String label;
  final VoidCallback? onPressed;
  final String semanticLabel;
  final IconData? icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      enabled: onPressed != null,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 48.0,
          minHeight: 48.0,
          maxHeight: height < 48.0 ? 48.0 : height,
        ),
        child: SizedBox(
          width: width,
          height: height,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              elevation: 3,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 28, color: foregroundColor),
                  const SizedBox(width: 12),
                ],
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: foregroundColor,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
