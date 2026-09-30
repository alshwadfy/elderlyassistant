import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/demo_snackbar.dart';

/// Emergency Screen — highest-priority screen in the app.
///
/// Design decisions per ui.md:
/// • SOS button uses AppColors.emergency (#B91C1C) / AppColorsDark.emergency (#EF4444)
/// • Largest, highest-contrast element on the screen.
/// • Confirm-with-Yes/No before triggering — equally large, immediate.
/// • Cancel also uses plain Yes/No, not icon-only.
/// • Fully responsive to all screen ratios, with dynamic sizing and scroll fallback.
/// • No hidden gestures.
/// • Text labels on every action — no icon-only controls.
class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen>
    with TickerProviderStateMixin {
  _EmergencyPhase _phase = _EmergencyPhase.idle;
  DateTime? _triggeredAt;

  late AnimationController _pulseController;
  late AnimationController _ringController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _ring1;
  late Animation<double> _ring2;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _ring1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ringController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    _ring2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ringController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _ringController.dispose();
    super.dispose();
  }

  // ─── Confirm before triggering ────────────────────────────────────────────
  Future<void> _showTriggerConfirm(bool isDark) async {
    HapticFeedback.heavyImpact();
    final confirmed = await _showConfirmDialog(
      title: 'Send Emergency Alert?',
      body: 'This will immediately notify your family members and caregivers '
          'that you need help. Are you sure you want to send the alert?',
      yesLabel: 'Yes, Send Alert',
      noLabel: 'No, Cancel',
      yesColor: isDark ? AppColorsDark.emergency : AppColors.emergency,
      isDark: isDark,
    );
    if (confirmed == true && mounted) {
      _triggerEmergency();
    }
  }

  void _triggerEmergency() {
    final now = DateTime.now();
    setState(() {
      _phase = _EmergencyPhase.active;
      _triggeredAt = now;
    });
    _ringController.repeat();
    HapticFeedback.vibrate();

    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    showDemoSnackBar(
      context,
      'SOS alert dispatched at $timeStr to all family members & caregivers!',
    );
  }

  // ─── Confirm before cancelling ────────────────────────────────────────────
  Future<void> _showCancelConfirm(bool isDark) async {
    final confirmed = await _showConfirmDialog(
      title: 'Cancel Emergency Alert?',
      body: 'Are you sure you want to cancel the emergency alert? '
          'Your family members will be notified that you are okay.',
      yesLabel: 'Yes, Cancel Alert',
      noLabel: 'No, Keep Alert Active',
      yesColor: isDark ? AppColorsDark.warning : AppColors.warning,
      isDark: isDark,
    );
    if (confirmed == true && mounted) {
      _cancelEmergency();
    }
  }

  void _cancelEmergency() {
    setState(() {
      _phase = _EmergencyPhase.idle;
      _triggeredAt = null;
    });
    _ringController.stop();
    _ringController.reset();
    showDemoSnackBar(context, 'Emergency alert cancelled. Stay safe!');
  }

  // ─── Shared confirm dialog — always Yes/No with full text ─────────────────
  Future<bool?> _showConfirmDialog({
    required String title,
    required String body,
    required String yesLabel,
    required String noLabel,
    required Color yesColor,
    required bool isDark,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColorsDark.surface : AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
          ),
        ),
        content: Text(
          body,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Yes — primary action
                SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: yesColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: Text(
                      yesLabel,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // No — secondary action
                SizedBox(
                  height: 60,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                      side: BorderSide(
                        color: isDark ? AppColorsDark.border : AppColors.border,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: Text(
                      noLabel,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isActive = _phase == _EmergencyPhase.active;

    final screenHeight = MediaQuery.sizeOf(context).height;
    final isCompact = screenHeight < 680;

    return ColoredBox(
      color: isDark ? AppColorsDark.emergencyBg : AppColors.emergencyBg,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // ─── Header ─────────────────────────────────────────────
                      _Header(isDark: isDark),

                      // ─── Active alert status banner ──────────────────────────
                      if (isActive && _triggeredAt != null)
                        _ActiveBanner(
                          triggeredAt: _triggeredAt!,
                          isDark: isDark,
                        ),

                      SizedBox(height: isCompact ? 12 : 24),
                      const Spacer(),

                      // ─── SOS Button ──────────────────────────────────────────
                      Semantics(
                        button: true,
                        label: isActive
                            ? 'Cancel emergency alert. Double tap to cancel.'
                            : 'Send SOS emergency alert. Double tap to confirm and send.',
                        child: _SosButton(
                          isActive: isActive,
                          isDark: isDark,
                          isCompact: isCompact,
                          pulseAnimation: _pulseAnimation,
                          ring1: _ring1,
                          ring2: _ring2,
                          ringController: _ringController,
                          onTap: () => isActive
                              ? _showCancelConfirm(isDark)
                              : _showTriggerConfirm(isDark),
                        ),
                      ),

                      SizedBox(height: isCompact ? 18 : 28),

                      // ─── Status text ─────────────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            Text(
                              isActive ? l10n.alertDispatched : l10n.emergencyHelpTitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isCompact ? 24 : 28,
                                fontWeight: FontWeight.w900,
                                color: isDark
                                    ? AppColorsDark.emergency
                                    : AppColors.emergency,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isActive ? l10n.stayCalm : l10n.needAssistance,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isCompact ? 16 : 18,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColorsDark.textSecondary
                                    : AppColors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),
                      SizedBox(height: isCompact ? 16 : 24),

                      // ─── Primary action button ────────────────────────────────
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          24,
                          0,
                          24,
                          isCompact ? 16 : 24,
                        ),
                        child: isActive
                            ? SizedBox(
                                width: double.infinity,
                                height: isCompact ? 56 : 64,
                                child: OutlinedButton.icon(
                                  icon: const Icon(Icons.close_rounded, size: 26),
                                  label: Text(l10n.cancelEmergencyAlert),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: isDark
                                        ? AppColorsDark.textPrimary
                                        : AppColors.textSecondary,
                                    side: BorderSide(
                                      color: isDark
                                          ? AppColorsDark.border
                                          : AppColors.textSecondary,
                                      width: 2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  onPressed: () => _showCancelConfirm(isDark),
                                ),
                              )
                            : SizedBox(
                                width: double.infinity,
                                height: isCompact ? 56 : 64,
                                child: ElevatedButton.icon(
                                  icon: const Icon(
                                    Icons.phone_in_talk_rounded,
                                    size: 26,
                                  ),
                                  label: Text(l10n.callEmergency),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isDark
                                        ? AppColorsDark.emergency
                                        : AppColors.emergency,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    elevation: 4,
                                  ),
                                  onPressed: () => _showTriggerConfirm(isDark),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

enum _EmergencyPhase { idle, active }

class _Header extends StatelessWidget {
  const _Header({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 24, 4),
      child: Row(
        children: [
          Semantics(
            label: 'Go back',
            button: true,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                size: 30,
                color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
              ),
              tooltip: 'Go back',
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
          Expanded(
            child: Text(
              'Emergency Help',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _ActiveBanner extends StatelessWidget {
  const _ActiveBanner({
    required this.triggeredAt,
    required this.isDark,
  });
  final DateTime triggeredAt;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final timeStr =
        '${triggeredAt.hour.toString().padLeft(2, '0')}:${triggeredAt.minute.toString().padLeft(2, '0')}';
    final successColor = isDark ? AppColorsDark.success : AppColors.success;
    final containerColor = isDark
        ? AppColorsDark.successContainer
        : AppColors.successContainer;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: successColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: successColor.withValues(alpha: 0.2),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: successColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Help is on the way',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: successColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Alert sent at $timeStr. Family notified.',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColorsDark.textPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SosButton extends StatelessWidget {
  const _SosButton({
    required this.isActive,
    required this.isDark,
    required this.isCompact,
    required this.pulseAnimation,
    required this.ring1,
    required this.ring2,
    required this.ringController,
    required this.onTap,
  });

  final bool isActive;
  final bool isDark;
  final bool isCompact;
  final Animation<double> pulseAnimation;
  final Animation<double> ring1;
  final Animation<double> ring2;
  final AnimationController ringController;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final emergencyColor = isDark ? AppColorsDark.emergency : AppColors.emergency;
    final outerSize = isCompact ? 200.0 : 230.0;
    final midSize = isCompact ? 165.0 : 190.0;
    final btnSize = isCompact ? 135.0 : 152.0;

    return AnimatedBuilder(
      animation: Listenable.merge([pulseAnimation, ring1, ring2]),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            if (isActive) ...[
              _Ring(
                scale: 1.0 + ring1.value * 0.6,
                opacity: (1 - ring1.value) * 0.35,
                color: emergencyColor,
                baseSize: btnSize,
              ),
              _Ring(
                scale: 1.0 + ring2.value * 0.6,
                opacity: (1 - ring2.value) * 0.25,
                color: emergencyColor,
                baseSize: btnSize,
              ),
            ],
            // Outer halo
            Container(
              width: outerSize,
              height: outerSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: emergencyColor.withValues(
                  alpha: isActive ? 0.22 : 0.12,
                ),
              ),
            ),
            // Middle ring
            Container(
              width: midSize,
              height: midSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: emergencyColor.withValues(
                  alpha: isActive ? 0.32 : 0.18,
                ),
              ),
            ),
            // The button itself
            Transform.scale(
              scale: isActive ? pulseAnimation.value : 1.0,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  width: btnSize,
                  height: btnSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: emergencyColor,
                    boxShadow: [
                      BoxShadow(
                        color: emergencyColor.withValues(alpha: isDark ? 0.6 : 0.45),
                        blurRadius: 32,
                        spreadRadius: isActive ? 10 : 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isActive
                            ? Icons.notifications_active_rounded
                            : Icons.sos_rounded,
                        size: isCompact ? 44 : 50,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'SOS',
                        style: TextStyle(
                          fontSize: isCompact ? 20 : 22,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Ring extends StatelessWidget {
  const _Ring({
    required this.scale,
    required this.opacity,
    required this.color,
    required this.baseSize,
  });

  final double scale;
  final double opacity;
  final Color color;
  final double baseSize;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Container(
        width: baseSize,
        height: baseSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: color.withValues(alpha: opacity),
            width: 3,
          ),
        ),
      ),
    );
  }
}
