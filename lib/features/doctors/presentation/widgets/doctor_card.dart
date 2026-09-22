import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/doctor_model.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({super.key, required this.doctor, required this.onBook});

  final DoctorModel doctor;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Avatar
            const CircleAvatar(
              radius: 32,
              backgroundColor: AppColors.primaryContainer,
              child: Icon(Icons.person, color: AppColors.primary, size: 32),
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor.type,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        '${doctor.distanceKm} km',
                        style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 8),
                      const Text('•', style: TextStyle(color: AppColors.textSecondary)),
                      const SizedBox(width: 8),
                      Text(
                        '${doctor.estimatedMinutes} min',
                        style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Book Button
            ElevatedButton(
              onPressed: onBook,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(88, 48),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Book'),
            ),
          ],
        ),
      ),
    );
  }
}
