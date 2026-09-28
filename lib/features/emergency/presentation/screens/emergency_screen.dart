import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/accessible_button.dart';
import '../../../../core/widgets/demo_snackbar.dart';

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

    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    showDemoSnackBar(
      context,
      'SOS alert dispatched at $timeStr to all family members & caregivers!',
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
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return ColoredBox(
      color: theme.brightness == Brightness.dark
          ? const Color(0xFF1E1010)
          : AppColors.emergencyBg,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            children: [
              // Top Header with Back Button
              Row(
                children: [
                  IconButton(
                    tooltip: 'Back',
                    icon: Icon(
                      Icons.arrow_back,
                      size: 28,
                      color: theme.colorScheme.onSurface,
                    ),
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  Expanded(
                    child: Text(
                      l10n.emergencyHelpTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              if (_isAlertActive && _triggeredAt != null) ...[
                const SizedBox(height: 16),
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
                            Text(
                              l10n.helpOnWay,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.success,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.alertSentAt(
                                '${_triggeredAt!.hour.toString().padLeft(2, '0')}:${_triggeredAt!.minute.toString().padLeft(2, '0')}',
                              ),
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

              // SOS Button Animation Circle
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.emergency.withValues(alpha: 0.1),
                ),
                child: Center(
                  child: Container(
                    width: 155,
                    height: 155,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.emergency.withValues(alpha: 0.2),
                    ),
                    child: Center(
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.emergency,
                        ),
                        child: Icon(
                          _isAlertActive ? Icons.notifications_active : Icons.phone_in_talk,
                          size: 52,
                          color: AppColors.textLight,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                _isAlertActive ? l10n.alertDispatched : l10n.emergencyHelpTitle,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.emergency,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _isAlertActive ? l10n.stayCalm : l10n.needAssistance,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  height: 1.4,
                ),
              ),
              const Spacer(),

              // Primary SOS Call Button
              if (_isAlertActive) ...[
                AccessibleButton(
                  label: l10n.cancelEmergencyAlert,
                  semanticLabel: 'Cancel emergency alert',
                  icon: Icons.close,
                  backgroundColor: AppColors.textMuted,
                  onPressed: _cancelEmergency,
                ),
              ] else ...[
                AccessibleButton(
                  label: l10n.callEmergency,
                  semanticLabel: 'Call emergency services',
                  icon: Icons.phone_in_talk,
                  backgroundColor: AppColors.emergency,
                  onPressed: _triggerEmergency,
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
