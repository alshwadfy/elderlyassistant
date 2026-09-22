import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'accessible_button.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.message,
    required this.onRetry,
    this.title = 'حدث خطأ / Something went wrong',
  });

  final String message;
  final VoidCallback onRetry;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: AppColors.emergencyContainer,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.emergency, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.emergency,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.emergency,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              AccessibleButton(
                label: 'إعادة المحاولة / Retry',
                icon: Icons.refresh,
                backgroundColor: AppColors.emergency,
                foregroundColor: AppColors.textLight,
                semanticLabel: 'إعادة المحاولة / Retry button',
                onPressed: onRetry,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
