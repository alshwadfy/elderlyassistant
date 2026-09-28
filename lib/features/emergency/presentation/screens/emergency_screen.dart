import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/accessible_button.dart';
import '../../../../core/widgets/demo_snackbar.dart';
import '../../../home/presentation/screens/home_shell_screen.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  bool _isAlertActive = false;
  DateTime? _triggeredAt;

  void _triggerEmergency() {
    final now = DateTime.now();
    setState(() {
      _isAlertActive = true;
      _triggeredAt = now;
    });

    // Construct trigger payload matching emergency_event.triggered_at backend schema
    final payload = {
      'emergency_event': {
        'triggered_at': now.toIso8601String(),
        'status': 'triggered',
      }
    };

    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    showDemoSnackBar(
      context,
      'SOS alert dispatched at $timeStr (${payload['emergency_event']!['triggered_at']})',
    );
  }

  void _cancelEmergency() {
    setState(() {
      _isAlertActive = false;
      _triggeredAt = null;
    });
    showDemoSnackBar(context, 'Emergency alert cancelled');
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.emergencyBg,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    tooltip: 'Back',
                    icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  const Expanded(
                    child: Text(
                      'Emergency Help',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              if (_isAlertActive && _triggeredAt != null) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.successContainer,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.success, width: 2),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: AppColors.success,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Help is on the way!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.success,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Alert sent at ${_triggeredAt!.hour.toString().padLeft(2, '0')}:${_triggeredAt!.minute.toString().padLeft(2, '0')}. Your family and caregivers have been notified.',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const Spacer(),
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.emergency.withValues(alpha: 0.1),
                ),
                child: Center(
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.emergency.withValues(alpha: 0.2),
                    ),
                    child: Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.emergency,
                        ),
                        child: Icon(
                          _isAlertActive ? Icons.notifications_active : Icons.phone_in_talk,
                          size: 48,
                          color: AppColors.textLight,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                _isAlertActive ? 'Alert Dispatched' : 'Emergency Help',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.emergency,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _isAlertActive
                    ? 'Stay calm. Your caregivers have received your location and contact request.'
                    : 'Need immediate assistance?\nYou will be connected with your family or emergency services.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const Spacer(),
              if (_isAlertActive) ...[
                AccessibleButton(
                  label: 'Cancel Emergency Alert',
                  semanticLabel: 'Cancel emergency alert',
                  icon: Icons.close,
                  backgroundColor: AppColors.textMuted,
                  onPressed: _cancelEmergency,
                ),
              ] else ...[
                AccessibleButton(
                  label: 'Call Emergency',
                  semanticLabel: 'Call emergency services',
                  icon: Icons.phone,
                  backgroundColor: AppColors.emergency,
                  onPressed: _triggerEmergency,
                ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                height: 56,
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppShellRoutes.family);
                  },
                  icon: const Icon(Icons.people_outline, color: AppColors.emergency),
                  label: const Text(
                    'Contact Family',
                    style: TextStyle(
                      color: AppColors.emergency,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.emergency, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
