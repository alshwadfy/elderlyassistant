import 'package:flutter/material.dart';

/// Exact palette from ui.md — AI Elderly Assistant
/// All values verified against WCAG AA (4.5:1 min), targeting AAA (7:1+).
class AppColors {
  const AppColors._();

  // ─── Brand ────────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF1647AD); // Buttons, active nav, primary actions
  static const Color primaryDark = Color(0xFF10275A); // Pressed states, dark-mode surfaces
  static const Color primaryContainer = Color(0xFFE9ECFF); // Selected states, subtle highlight fills

  // Legacy aliases kept so existing code referencing them still compiles
  static const Color primaryLight = Color(0xFF3D68D0); // Slightly lighter for hover states
  static const Color primarySurface = Color(0xFFE9ECFF);

  // ─── Background & Surface ─────────────────────────────────────────────────
  static const Color background = Color(0xFFF7F9FF); // App background
  static const Color surface = Color(0xFFFFFFFF); // Cards
  static const Color cardBorder = Color(0xFFD8DEFF);

  // ─── Text ─────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A2B4A); // Headings, primary body text (>7:1 on white)
  static const Color textSecondary = Color(0xFF4B5875); // 7.1:1 on white — replaces #66789E
  static const Color textMuted = Color(0xFF4B5875); // Same safe floor — never go lighter
  static const Color textLight = Color(0xFFFFFFFF);

  // ─── Status — required by spec ────────────────────────────────────────────
  static const Color success = Color(0xFF15803D); // 5.0:1 on white
  static const Color successContainer = Color(0xFFDCFCE7); // Tint for badges/cards
  static const Color warning = Color(0xFFB45309); // 5.0:1 on white
  static const Color warningContainer = Color(0xFFFEF3C7);
  static const Color emergency = Color(0xFFB91C1C); // Error/Emergency — 6.5:1 on white
  static const Color emergencyContainer = Color(0xFFFEE2E2);
  static const Color emergencyBg = Color(0xFFFFF5F5);

  // Legacy aliases
  static const Color emergencyLight = Color(0xFFDC2626);
  static const Color secondary = Color(0xFF15803D);
  static const Color secondaryContainer = Color(0xFFDCFCE7);

  // ─── Borders & dividers ───────────────────────────────────────────────────
  static const Color border = Color(0xFFD8DEFF);
  static const Color divider = Color(0xFFE9ECFF);

  // ─── Navigation ───────────────────────────────────────────────────────────
  static const Color navInactive = Color(0xFF4B5875); // 7.1:1 — always readable
  static const Color navActive = Color(0xFF1647AD);

  // ─── Chips ────────────────────────────────────────────────────────────────
  static const Color chipSelected = Color(0xFF1647AD);
  static const Color chipUnselected = Color(0xFFE9ECFF);
  static const Color chipTextUnselected = Color(0xFF1A2B4A);
}

/// Dark theme — high contrast, easy on eyes in low light.
class AppColorsDark {
  const AppColorsDark._();

  static const Color primary = Color(0xFF5B8DEF); // Lighter blue — readable on dark bg
  static const Color primaryDark = Color(0xFF1647AD);
  static const Color primaryContainer = Color(0xFF1E2D4A); // Dark tinted surface
  static const Color primaryLight = Color(0xFF7BA7FF);
  static const Color primarySurface = Color(0xFF1E2D4A);

  static const Color background = Color(0xFF0D1521); // Very dark navy
  static const Color surface = Color(0xFF182030); // Card surface
  static const Color cardBorder = Color(0xFF253553);

  static const Color textPrimary = Color(0xFFF0F4FF); // Near-white — high contrast
  static const Color textSecondary = Color(0xFFB8C8E8); // Readable on dark
  static const Color textMuted = Color(0xFF8FA8C8);
  static const Color textLight = Color(0xFFFFFFFF);

  static const Color success = Color(0xFF34D27A); // Bright enough on dark
  static const Color successContainer = Color(0xFF0C2B1A);
  static const Color warning = Color(0xFFFBBF24);
  static const Color warningContainer = Color(0xFF2A1800);
  static const Color emergency = Color(0xFFEF4444);
  static const Color emergencyContainer = Color(0xFF2D0A0A);
  static const Color emergencyBg = Color(0xFF1A0808);

  static const Color secondary = Color(0xFF34D27A);
  static const Color secondaryContainer = Color(0xFF0C2B1A);

  static const Color border = Color(0xFF253553);
  static const Color divider = Color(0xFF1E2D4A);

  static const Color navInactive = Color(0xFF8FA8C8);
  static const Color navActive = Color(0xFF5B8DEF);

  static const Color chipSelected = Color(0xFF5B8DEF);
  static const Color chipUnselected = Color(0xFF1E2D4A);
  static const Color chipTextUnselected = Color(0xFFB8C8E8);
}
