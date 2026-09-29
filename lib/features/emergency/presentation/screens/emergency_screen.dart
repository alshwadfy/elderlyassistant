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

class _EmergencyScreenState extends State<EmergencyScreen>
    with SingleTickerProviderStateMixin {
  bool _isAlertActive = false;
  DateTime? _triggeredAt;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

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
    final isDark = theme.brightness == Brightness.dark;

    return ColoredBox(
      color: isDark ? const Color(0xFF1E1010) : AppColors.emergencyBg,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            children: [
              // Top Header with Back Button
              Row(
                children: [
                  IconButton(
                    tooltip: 'Back',
                    icon: Icon(
                      Icons.arrow_back_rounded,
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
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface,
                        letterSpacing: -0.3,
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
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.successContainer,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.success, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.success.withValues(alpha: 0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.helpOnWay,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.success,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              l10n.alertSentAt(
                                '${_triggeredAt!.hour.toString().padLeft(2, '0')}:${_triggeredAt!.minute.toString().padLeft(2, '0')}',
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
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

              // SOS Animated Pulse Button
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final scale = 1.0 + (_pulseController.value * 0.08);
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
                child: GestureDetector(
                  onTap: _isAlertActive ? _cancelEmergency : _triggerEmergency,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.emergency.withValues(alpha: 0.12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.emergency.withValues(alpha: 0.35),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 170,
                        height: 170,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.emergency.withValues(alpha: 0.25),
                        ),
                        child: Center(
                          child: Container(
                            width: 125,
                            height: 125,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xFFFF6B6B), Color(0xFFE53E3E)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Icon(
                              _isAlertActive
                                  ? Icons.notifications_active_rounded
                                  : Icons.phone_in_talk_rounded,
                              size: 58,
                              color: AppColors.textLight,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 36),

              Text(
                _isAlertActive ? l10n.alertDispatched : l10n.emergencyHelpTitle,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.emergency,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _isAlertActive ? l10n.stayCalm : l10n.needAssistance,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                  height: 1.4,
                ),
              ),

              const Spacer(),

              // Primary SOS Action Button
              if (_isAlertActive) ...[
                AccessibleButton(
                  label: l10n.cancelEmergencyAlert,
                  semanticLabel: 'Cancel emergency alert',
                  icon: Icons.close_rounded,
                  backgroundColor: AppColors.textMuted,
                  onPressed: _cancelEmergency,
                ),
              ] else ...[
                AccessibleButton(
                  label: l10n.callEmergency,
                  semanticLabel: 'Call emergency services',
                  icon: Icons.phone_in_talk_rounded,
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

