import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../screens/home_shell_screen.dart';

/// Home tab — the landing screen users see first.
///
/// Design decisions per ui.md:
/// • All body text ≥ 18sp. Greeting text 26sp.
/// • Quick actions: vertical list (1-column), not grid — easier for elderly eyes.
/// • One primary action visible (voice orb), supporting actions below.
/// • Prompt chips enlarged (18sp text, 52dp height).
/// • Every card has icon + bold label + supporting sentence — never label-only.
/// • Full dark mode support for all components.
class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  void _open(BuildContext context, String route) {
    Navigator.of(context).pushNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark ? AppColorsDark.primary : AppColors.primary;
    final primaryContainer = isDark ? AppColorsDark.primaryContainer : AppColors.primaryContainer;
    final emergencyColor = isDark ? AppColorsDark.emergency : AppColors.emergency;
    final emergencyContainer = isDark ? AppColorsDark.emergencyContainer : AppColors.emergencyContainer;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ─── Welcome / Greeting Banner ────────────────────────────────────
          _GreetingBanner(isDark: isDark, l10n: l10n),

          const SizedBox(height: 24),

          // ─── Voice Orb — primary action ───────────────────────────────────
          Center(
            child: Semantics(
              label: l10n.tapToSpeak,
              button: true,
              child: _VoiceOrb(
                onTap: () => _open(context, AppShellRoutes.voice),
                isDark: isDark,
                l10n: l10n,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ─── Quick-prompt chips ───────────────────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            clipBehavior: Clip.none,
            child: Row(
              children: [
                _PromptChip(
                  icon: Icons.medication,
                  label: l10n.medicationStatus,
                  isDark: isDark,
                  onTap: () => _open(context, AppShellRoutes.reminders),
                ),
                const SizedBox(width: 12),
                _PromptChip(
                  icon: Icons.local_hospital,
                  label: l10n.bookDoctor,
                  isDark: isDark,
                  onTap: () => _open(context, AppShellRoutes.doctors),
                ),
                const SizedBox(width: 12),
                _PromptChip(
                  icon: Icons.phone_in_talk,
                  label: l10n.callFamily,
                  isDark: isDark,
                  onTap: () => _open(context, AppShellRoutes.family),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // ─── Section title ────────────────────────────────────────────────
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 16),

          // ─── Feature list — vertical, one card per row ────────────────────
          _FeatureListItem(
            icon: Icons.local_hospital_outlined,
            iconColor: primaryColor,
            iconBg: primaryContainer,
            title: l10n.findDoctor,
            subtitle: l10n.findDoctorSubtitle,
            onTap: () => _open(context, AppShellRoutes.doctors),
          ),
          const SizedBox(height: 14),
          _FeatureListItem(
            icon: Icons.medication_outlined,
            iconColor: primaryColor,
            iconBg: primaryContainer,
            title: l10n.medicationReminders,
            subtitle: l10n.neverMissMed,
            onTap: () => _open(context, AppShellRoutes.reminders),
          ),
          const SizedBox(height: 14),
          _FeatureListItem(
            icon: Icons.people_outline,
            iconColor: primaryColor,
            iconBg: primaryContainer,
            title: l10n.contactFamily,
            subtitle: l10n.quicklyReachFamily,
            onTap: () => _open(context, AppShellRoutes.family),
          ),
          const SizedBox(height: 14),
          // Emergency — distinct visual identity
          _FeatureListItem(
            icon: Icons.sos_rounded,
            iconColor: emergencyColor,
            iconBg: emergencyContainer,
            title: l10n.emergencyHelp,
            subtitle: l10n.getImmediateAssistance,
            isEmergency: true,
            onTap: () => _open(context, AppShellRoutes.emergency),
          ),
        ],
      ),
    );
  }
}

// ─── Greeting Banner ──────────────────────────────────────────────────────────
class _GreetingBanner extends StatelessWidget {
  const _GreetingBanner({required this.isDark, required this.l10n});
  final bool isDark;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final primaryColor = isDark ? AppColorsDark.primary : AppColors.primary;
    final warningColor = isDark ? AppColorsDark.warning : AppColors.warning;
    final subtitleColor = isDark ? AppColorsDark.textSecondary : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF141E30), const Color(0xFF1F2B44)]
              : [const Color(0xFFE9ECFF), const Color(0xFFDDE3FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: primaryColor.withValues(alpha: isDark ? 0.35 : 0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time-of-day chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: warningColor.withValues(alpha: isDark ? 0.22 : 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.wb_sunny_rounded, color: warningColor, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        l10n.goodMorning,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: warningColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.goodMorningName('Adel'),
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: primaryColor,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.howCanIHelp,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
          ),
          // Decorative icon
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: isDark ? 0.2 : 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.assistant_rounded,
              size: 36,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Voice Orb ───────────────────────────────────────────────────────────────
class _VoiceOrb extends StatelessWidget {
  const _VoiceOrb({
    required this.onTap,
    required this.isDark,
    required this.l10n,
  });
  final VoidCallback onTap;
  final bool isDark;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final primaryColor = isDark ? AppColorsDark.primary : AppColors.primary;
    final textTitleColor = isDark ? AppColorsDark.textPrimary : AppColors.textPrimary;
    final textSubtitleColor = isDark ? AppColorsDark.textSecondary : AppColors.textSecondary;

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF3B68C4), const Color(0xFF204899), const Color(0xFF142B60)]
                    : [const Color(0xFF2259D0), const Color(0xFF1647AD), const Color(0xFF10275A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: isDark ? 0.5 : 0.4),
                  blurRadius: 36,
                  spreadRadius: 6,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Inner ring decoration
                Container(
                  width: 142,
                  height: 142,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                      width: 2,
                    ),
                  ),
                ),
                const Icon(
                  Icons.mic_rounded,
                  size: 68,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          l10n.tapToSpeak,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: textTitleColor,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.orSayHey,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: textSubtitleColor,
          ),
        ),
      ],
    );
  }
}

// ─── Prompt Chip ─────────────────────────────────────────────────────────────
class _PromptChip extends StatelessWidget {
  const _PromptChip({
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
    final primaryColor = isDark ? AppColorsDark.primary : AppColors.primary;
    final containerColor = isDark ? AppColorsDark.primaryContainer : AppColors.primaryContainer;
    final borderColor = isDark ? AppColorsDark.border : AppColors.primary.withValues(alpha: 0.25);

    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: borderColor,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 22, color: primaryColor),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Feature List Item — one per row, full width ─────────────────────────────
class _FeatureListItem extends StatelessWidget {
  const _FeatureListItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isEmergency = false,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isEmergency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardBg = isEmergency
        ? (isDark
            ? AppColorsDark.emergencyContainer.withValues(alpha: 0.5)
            : AppColors.emergencyContainer.withValues(alpha: 0.4))
        : (isDark ? AppColorsDark.surface : AppColors.surface);

    final borderColor = isEmergency
        ? (isDark ? AppColorsDark.emergency.withValues(alpha: 0.5) : AppColors.emergency.withValues(alpha: 0.35))
        : (isDark ? AppColorsDark.border : AppColors.border);

    return Semantics(
      button: true,
      label: '$title. $subtitle',
      child: Material(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          splashColor: iconColor.withValues(alpha: 0.12),
          highlightColor: iconColor.withValues(alpha: 0.06),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: borderColor,
                width: isEmergency ? 2.0 : 1.5,
              ),
            ),
            child: Row(
              children: [
                // Icon badge
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: iconColor, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: isEmergency
                              ? (isDark ? AppColorsDark.emergency : AppColors.emergency)
                              : (isDark
                                  ? AppColorsDark.textPrimary
                                  : AppColors.textPrimary),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColorsDark.textSecondary
                              : AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  color: iconColor.withValues(alpha: 0.7),
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
