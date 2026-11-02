import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/rafiq_emergency_bar.dart';
import '../../../../core/widgets/rafiq_sky_header.dart';
import '../../../emergency/presentation/screens/emergency_screen.dart';
import '../../providers/way_home_provider.dart';

/// Help Me Find My Way Home (`ساعدني أرجع للبيت`) screen matching Figma `#10:3172` (Day)
/// & `#10:3242` (Night), featuring an interactive pinch-to-zoom neighborhood map (`#10:3183`).
class WayHomeScreen extends StatefulWidget {
  const WayHomeScreen({super.key});

  @override
  State<WayHomeScreen> createState() => _WayHomeScreenState();
}

class _WayHomeScreenState extends State<WayHomeScreen> {
  final TransformationController _mapController = TransformationController();

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _recenterMap() {
    setState(() {
      _mapController.value = Matrix4.identity();
    });
  }

  @override
  Widget build(BuildContext context) {
    final wayHome = context.watch<WayHomeCubit>().state;
    final notifier = context.read<WayHomeCubit>();
    final step = wayHome.currentStep;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? AppColorsDark.background : AppColors.background;
    final surfaceColor = isDark ? AppColorsDark.surface : AppColors.surface;
    final borderColor = isDark ? AppColorsDark.cardBorder : AppColors.cardBorder;
    final textPrimary = isDark
        ? AppColorsDark.textPrimary
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColorsDark.textSecondary
        : AppColors.textSecondary;
    final primaryColor = isDark
        ? AppColorsDark.primary
        : AppColors.rafiqPrimary;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          RafiqSkyHeader(
            title: 'ساعدني أرجع للبيت',
            subtitle: 'خطوة بخطوة إلى المنزل',
            onBack: () => Navigator.of(context).maybePop(),
            backLabel: 'الرئيسية',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Interactive Map Card (`Route to home` `#10:3183`)
                  Container(
                    height: 224,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF15223B)
                          : const Color(0xFFE9F0FA),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: borderColor, width: 1.8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: isDark ? 0.30 : 0.06,
                          ),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Stack(
                        children: [
                          // Interactive zoomable & pannable map canvas
                          Positioned.fill(
                            child: InteractiveViewer(
                              transformationController: _mapController,
                              minScale: 1.0,
                              maxScale: 2.8,
                              child: GestureDetector(
                                onTap: notifier.advanceStep,
                                child: CustomPaint(
                                  painter: _NeighborhoodRouteMapPainter(
                                    isDark: isDark,
                                    progress: step.progress,
                                  ),
                                  child: Stack(
                                    children: [
                                      // Home marker label (`المنزل`)
                                      Positioned(
                                        top: 22,
                                        right: 36,
                                        child: _MapMarkerBadge(
                                          label: 'المنزل',
                                          icon: Icons.home_rounded,
                                          backgroundColor: AppColors.success,
                                          textColor: Colors.white,
                                        ),
                                      ),
                                      // Current User position label (`أنت هنا`)
                                      Positioned(
                                        left: (28 + (165 * step.progress)).toDouble(),
                                        bottom: (28 + (112 * step.progress)).toDouble(),
                                        child: _MapMarkerBadge(
                                          label: wayHome.hasArrived
                                              ? 'وصلت للمنزل ✓'
                                              : 'أنت هنا',
                                          icon: Icons.my_location_rounded,
                                          backgroundColor: primaryColor,
                                          textColor: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Recenter & Step controls overlay
                          Positioned(
                            left: 12,
                            top: 12,
                            child: Row(
                              children: [
                                Semantics(
                                  button: true,
                                  label: 'إعادة توسيط الخريطة',
                                  child: Material(
                                    color: surfaceColor.withValues(alpha: 0.92),
                                    shape: const CircleBorder(),
                                    elevation: 2,
                                    child: InkWell(
                                      customBorder: const CircleBorder(),
                                      onTap: _recenterMap,
                                      child: SizedBox(
                                        width: 48,
                                        height: 48,
                                        child: Icon(
                                          Icons.my_location_rounded,
                                          color: primaryColor,
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Semantics(
                                  button: true,
                                  label: 'الخطوة التالية على الخريطة',
                                  child: Material(
                                    color: surfaceColor.withValues(alpha: 0.92),
                                    borderRadius: BorderRadius.circular(999),
                                    elevation: 2,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(999),
                                      onTap: notifier.advanceStep,
                                      child: Container(
                                        constraints: const BoxConstraints(
                                          minHeight: 48,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.directions_walk_rounded,
                                              size: 18,
                                              color: primaryColor,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              wayHome.hasArrived
                                                  ? 'إعادة المسار'
                                                  : 'تقدّم خطوة',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w800,
                                                color: textPrimary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Next Step Direction Card (`امشِ للأمام ١٠٠ متر` `#10:3212`)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColorsDark.primaryContainer
                          : AppColors.rafiqPrimaryTint,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: primaryColor.withValues(alpha: 0.45),
                        width: 1.6,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            wayHome.hasArrived
                                ? Icons.check_rounded
                                : Icons.arrow_upward_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                step.instructionAr,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                step.subInstructionAr,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Route Destination & ETA Card (`المنزل` · `٨ دقائق · ٦٠٠ متر` `#10:3222`)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'المنزل',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'وجهتك إلى البيت • ١٤ شارع الجلاء',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              wayHome.distanceSummaryAr,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'مشيًا · وقت تقريبي',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Primary CTA: `ابدأ التوجيه الصوتي`
                  SizedBox(
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        notifier.toggleVoiceGuidance();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              !wayHome.isVoiceGuidanceActive
                                  ? '🔊 بدأ التوجيه الصوتي خطوة بخطوة: ${step.instructionAr}'
                                  : 'تم إيقاف التوجيه الصوتي المؤقت',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: wayHome.isVoiceGuidanceActive
                            ? AppColors.success
                            : primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: Icon(
                        wayHome.isVoiceGuidanceActive
                            ? Icons.volume_up_rounded
                            : Icons.navigation_rounded,
                        size: 24,
                      ),
                      label: Text(
                        wayHome.isVoiceGuidanceActive
                            ? 'التوجيه الصوتي يعمل الآن (اضغط للإيقاف)'
                            : 'ابدأ التوجيه الصوتي',
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Secondary CTA: `اتصل بعائلتي`
                  SizedBox(
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              '📞 جارٍ الاتصال بابنتك ليلى ومشاركة موقعك الحالي على الخريطة…',
                            ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textPrimary,
                        backgroundColor: surfaceColor,
                        side: BorderSide(color: borderColor, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      icon: Icon(Icons.phone_in_talk_rounded, color: primaryColor),
                      label: const Text(
                        'اتصل بعائلتي',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  RafiqEmergencyButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const EmergencyScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapMarkerBadge extends StatelessWidget {
  const _MapMarkerBadge({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: textColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// CustomPainter recreating the Figma neighborhood map (`Route to home` `#10:3183`).
class _NeighborhoodRouteMapPainter extends CustomPainter {
  const _NeighborhoodRouteMapPainter({
    required this.isDark,
    required this.progress,
  });

  final bool isDark;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final blockPaint = Paint()
      ..color = isDark ? const Color(0xFF1E2F4D) : const Color(0xFFDCE6F7)
      ..style = PaintingStyle.fill;

    final parkPaint = Paint()
      ..color = isDark ? const Color(0xFF193C32) : const Color(0xFFD1FAE5)
      ..style = PaintingStyle.fill;

    final roadPaint = Paint()
      ..color = isDark ? const Color(0xFF283B5E) : Colors.white
      ..style = PaintingStyle.fill;

    // Neighborhood city blocks matching Figma `#10:3183`
    final blocks = <RRect>[
      RRect.fromRectAndRadius(
        Rect.fromLTWH(16, 16, size.width * 0.28, size.height * 0.34),
        const Radius.circular(12),
      ),
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.64,
          16,
          size.width * 0.30,
          size.height * 0.36,
        ),
        const Radius.circular(12),
      ),
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          16,
          size.height * 0.60,
          size.width * 0.30,
          size.height * 0.32,
        ),
        const Radius.circular(12),
      ),
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.60,
          size.height * 0.62,
          size.width * 0.34,
          size.height * 0.30,
        ),
        const Radius.circular(12),
      ),
    ];

    // Roads
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.44, size.width, 26),
      roadPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.46, 0, 26, size.height),
      roadPaint,
    );

    for (final b in blocks) {
      canvas.drawRRect(b, blockPaint);
    }

    // Green Park block in center-left
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.34,
          size.height * 0.14,
          size.width * 0.24,
          size.height * 0.26,
        ),
        const Radius.circular(14),
      ),
      parkPaint,
    );

    // Walking route path (`#10:3192` & `#10:3193`)
    final start = Offset(size.width * 0.22, size.height * 0.78);
    final turn1 = Offset(size.width * 0.50, size.height * 0.78);
    final turn2 = Offset(size.width * 0.50, size.height * 0.28);
    final homePos = Offset(size.width * 0.78, size.height * 0.28);

    final routeOutline = Paint()
      ..color = Colors.white.withValues(alpha: isDark ? 0.35 : 0.90)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 11
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final routeMain = Paint()
      ..color = isDark ? AppColorsDark.rafiqAccentBlue : AppColors.rafiqPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final routePath = Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(turn1.dx, turn1.dy)
      ..lineTo(turn2.dx, turn2.dy)
      ..lineTo(homePos.dx, homePos.dy);

    canvas.drawPath(routePath, routeOutline);
    canvas.drawPath(routePath, routeMain);

    // Home marker circle
    final homeHalo = Paint()
      ..color = AppColors.success.withValues(alpha: 0.25);
    canvas.drawCircle(homePos, 20, homeHalo);
    canvas.drawCircle(homePos, 10, Paint()..color = AppColors.success);

    // Current user pulsing halo
    final currentPos = Offset(
      start.dx + (homePos.dx - start.dx) * progress,
      start.dy + (homePos.dy - start.dy) * progress,
    );
    final userHalo = Paint()
      ..color = (isDark ? AppColorsDark.rafiqAccentBlue : AppColors.rafiqPrimary)
          .withValues(alpha: 0.28);
    canvas.drawCircle(currentPos, 24, userHalo);
    canvas.drawCircle(currentPos, 11, Paint()..color = Colors.white);
    canvas.drawCircle(
      currentPos,
      7.5,
      Paint()
        ..color =
            isDark ? AppColorsDark.rafiqAccentBlue : AppColors.rafiqPrimary,
    );
  }

  @override
  bool shouldRepaint(covariant _NeighborhoodRouteMapPainter oldDelegate) {
    return oldDelegate.isDark != isDark || oldDelegate.progress != progress;
  }
}
