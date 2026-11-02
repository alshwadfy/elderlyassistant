import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../providers/app_settings_provider.dart';
import '../theme/app_colors.dart';

/// Signature Rafiq (رفيق) Sky Header matching Figma `#2:98`, `#7:4773`, `#107:44`, `#107:60`, and `#2:562`.
class RafiqSkyHeader extends StatelessWidget {
  const RafiqSkyHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.backLabel,
    this.trailingAction,
    this.isEmergency = false,
    this.height = 178,
    this.bottomChild,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final String? backLabel;
  final Widget? trailingAction;
  final bool isEmergency;
  final double height;
  final Widget? bottomChild;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsCubit>().state;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = settings.isArabic;

    final Gradient skyGradient;
    if (isEmergency) {
      skyGradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? const [Color(0xFF7F1D1D), Color(0xFF450A0A)]
            : const [Color(0xFFD32F2F), Color(0xFFB91C1C)],
      );
    } else if (isDark) {
      skyGradient = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF0E1B38),
          Color(0xFF1D3363),
          Color(0xFF233B6E),
        ],
      );
    } else {
      skyGradient = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF8CC5FF),
          Color(0xFFBCE0FF),
          Color(0xFFDFF0FF),
        ],
      );
    }

    final titleColor = (isEmergency || isDark)
        ? Colors.white
        : AppColors.textPrimary;
    final subtitleColor = (isEmergency || isDark)
        ? Colors.white.withValues(alpha: 0.90)
        : AppColors.textSecondary;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: height),
      decoration: BoxDecoration(
        gradient: skyGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        child: Stack(
          children: [
            if (!isDark && !isEmergency)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.55,
                  child: Image.asset(
                    'assets/images/sky_header_day.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ),
            Positioned.fill(
              child: CustomPaint(
                painter: _SkyScenePainter(
                  isDark: isDark,
                  isEmergency: isEmergency,
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (onBack != null)
                          _HeaderPillButton(
                            icon: Icons.arrow_back_rounded,
                            label: backLabel ?? (isAr ? 'الرئيسية' : 'Back'),
                            isDark: isDark || isEmergency,
                            onTap: onBack!,
                          )
                        else if (trailingAction != null)
                          trailingAction!
                        else
                          const SizedBox(width: 4),
                        Semantics(
                          button: true,
                          label: isAr
                              ? 'الطقس ٢٤ درجة - اضغط للتبديل بين وضع النهار والليل'
                              : 'Weather 24 degrees - Tap to toggle Day and Night mode',
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(999),
                              onTap: () => context
                                  .read<AppSettingsCubit>()
                                  .toggleTheme(),
                              child: Container(
                                constraints: const BoxConstraints(
                                  minHeight: 48,
                                  minWidth: 88,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: (isDark || isEmergency)
                                      ? Colors.white.withValues(alpha: 0.16)
                                      : Colors.white.withValues(alpha: 0.85),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: (isDark || isEmergency)
                                        ? Colors.white.withValues(alpha: 0.25)
                                        : Colors.white,
                                    width: 1.2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isDark
                                          ? Icons.nightlight_round
                                          : Icons.wb_sunny_rounded,
                                      size: 20,
                                      color: isDark
                                          ? AppColorsDark.rafiqMoonGold
                                          : const Color(0xFFF59E0B),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      isAr ? '٢٤°' : '24°',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: (isDark || isEmergency)
                                            ? Colors.white
                                            : AppColors.textPrimary,
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
                    const SizedBox(height: 14),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: titleColor,
                        height: 1.2,
                      ),
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: subtitleColor,
                          height: 1.35,
                        ),
                      ),
                    ],
                    if (bottomChild != null) ...[
                      const SizedBox(height: 14),
                      bottomChild!,
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderPillButton extends StatelessWidget {
  const _HeaderPillButton({
    required this.icon,
    required this.label,
    required this.isDark,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 48, minWidth: 88),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.16)
                  : Colors.white.withValues(alpha: 0.88),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.28)
                    : AppColors.cardBorder,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.textPrimary,
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

class _SkyScenePainter extends CustomPainter {
  const _SkyScenePainter({
    required this.isDark,
    required this.isEmergency,
  });

  final bool isDark;
  final bool isEmergency;

  @override
  void paint(Canvas canvas, Size size) {
    final wavePaint = Paint()
      ..color = Colors.white.withValues(alpha: isDark ? 0.05 : 0.30)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.78)
      ..quadraticBezierTo(
        size.width * 0.28,
        size.height * 0.65,
        size.width * 0.56,
        size.height * 0.80,
      )
      ..quadraticBezierTo(
        size.width * 0.82,
        size.height * 0.92,
        size.width,
        size.height * 0.74,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, wavePaint);

    if (isEmergency) return;

    if (isDark) {
      final starPaint = Paint()
        ..color = const Color(0xFFF5E5AD).withValues(alpha: 0.65);
      final stars = <Offset>[
        Offset(size.width * 0.15, size.height * 0.24),
        Offset(size.width * 0.32, size.height * 0.18),
        Offset(size.width * 0.48, size.height * 0.30),
        Offset(size.width * 0.72, size.height * 0.22),
        Offset(size.width * 0.85, size.height * 0.38),
      ];
      for (final s in stars) {
        canvas.drawCircle(s, 2.2, starPaint);
      }

      final glowPaint = Paint()
        ..color = const Color(0xFFF5E5AD).withValues(alpha: 0.12);
      canvas.drawCircle(
        Offset(size.width * 0.18, size.height * 0.34),
        34,
        glowPaint,
      );
    } else {
      final sunGlow = Paint()
        ..color = const Color(0xFFFFE066).withValues(alpha: 0.32);
      canvas.drawCircle(
        Offset(size.width * 0.18, size.height * 0.28),
        38,
        sunGlow,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SkyScenePainter oldDelegate) {
    return oldDelegate.isDark != isDark ||
        oldDelegate.isEmergency != isEmergency;
  }
}
