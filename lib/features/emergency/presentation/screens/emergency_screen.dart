import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/accessible_button.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.emergencyBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Emergency Help',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Pulsing SOS Button Simulation
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.emergency.withOpacity(0.1),
                ),
                child: Center(
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.emergency.withOpacity(0.2),
                    ),
                    child: Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.emergency,
                        ),
                        child: const Icon(
                          Icons.phone_in_talk,
                          size: 48,
                          color: AppColors.textLight,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 48),
              
              const Text(
                'Emergency Help',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.emergency,
                ),
              ),
              
              const SizedBox(height: 16),
              
              const Text(
                'Need immediate assistance?\n\nYou will be connected with your family or emergency services.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              
              const Spacer(),
              
              // Actions
              AccessibleButton(
                label: 'Call Emergency',
                semanticLabel: 'Call emergency services',
                icon: Icons.phone,
                backgroundColor: AppColors.emergency,
                onPressed: () {},
              ),
              const SizedBox(height: 16),
              
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.people_outline, color: AppColors.emergency),
                label: const Text(
                  'Contact Family',
                  style: TextStyle(color: AppColors.emergency),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.emergency, width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
