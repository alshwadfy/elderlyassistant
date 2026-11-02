import 'package:flutter/material.dart';

/// Color tokens for Rafiq (رفيق) — Day (Sunny ☀) & Night (Moonlit ☾) palettes,
/// while preserving WCAG AA/AAA accessibility tokens from `docs/ui.md`.
class AppColors {
  AppColors._();

  // ───── Spec & Primary Brand (Day) ─────
  static const Color primary = Color(0xFF1647AD);
  static const Color primaryLight = Color(0xFF3B5BDB);
  static const Color primaryDark = Color(0xFF0E3484);
  static const Color primaryContainer = Color(0xFFE0ECFF);
  static const Color onPrimaryContainer = Color(0xFF0A2463);

  // ───── Rafiq Figma Day Tokens ─────
  static const Color rafiqPrimary = Color(0xFF3B5BDB);
  static const Color rafiqPrimaryTint = Color(0xFFEEF2FF);
  static const Color rafiqSkyTop = Color(0xFF9AC9FF);
  static const Color rafiqSkyMid = Color(0xFFBEDCFF);
  static const Color rafiqSkyBottom = Color(0xFFF0F4FF);
  static const Color rafiqSunGold = Color(0xFFFFCA3A);

  // ───── Backgrounds & Surfaces (Day) ─────
  static const Color background = Color(0xFFF0F4FF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFEEF2FF);
  static const Color cardBorder = Color(0xFFDDE4F5);
  static const Color border = Color(0xFFDDE4F5);

  // ───── Text Hierarchy (WCAG AAA / AA) ─────
  static const Color textPrimary = Color(0xFF1A2B4A);
  static const Color textSecondary = Color(0xFF42526E);
  static const Color textMuted = Color(0xFF556581);
  static const Color textHint = Color(0xFF556581);
  static const Color textLight = Color(0xFFFFFFFF);

  // ───── Semantic Status Colors ─────
  static const Color success = Color(0xFF15803D);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color successContainer = Color(0xFFDCFCE7);
  static const Color successBorder = Color(0xFF86EFAC);

  static const Color warning = Color(0xFFB45309);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color warningContainer = Color(0xFFFEF3C7);
  static const Color warningBorder = Color(0xFFFCD34D);

  // ───── Emergency / SOS ─────
  static const Color emergency = Color(0xFFD32F2F);
  static const Color emergencyRed = Color(0xFFD32F2F);
  static const Color emergencyRedDark = Color(0xFF991B1B);
  static const Color emergencyContainer = Color(0xFFFEE2E2);
  static const Color onEmergencyContainer = Color(0xFF7F1D1D);
  static const Color emergencyBorder = Color(0xFFFCA5A5);

  // ───── Chips ─────
  static const Color chipSelected = Color(0xFF3B5BDB);
  static const Color chipUnselected = Color(0xFFEEF2FF);

  // ───── Feature Card Accents ─────
  static const Color doctorCardBg = Color(0xFFE8F1FF);
  static const Color doctorIconColor = Color(0xFF1647AD);

  static const Color medicationCardBg = Color(0xFFDCFCE7);
  static const Color medicationIconColor = Color(0xFF15803D);

  static const Color familyCardBg = Color(0xFFF3E8FF);
  static const Color familyIconColor = Color(0xFF6B21A8);

  static const Color emergencyCardBg = Color(0xFFFEE2E2);
  static const Color emergencyIconColor = Color(0xFFB91C1C);

  // ───── Navigation Bar ─────
  static const Color navActive = Color(0xFF3B5BDB);
  static const Color navInactive = Color(0xFF42526E);

  // ───── Dividers & Borders ─────
  static const Color divider = Color(0xFFDDE4F5);
}

/// Rafiq Moonlit Night (ليل ☾) Palette matching Figma `#7:5300` & `#107:60`.
class AppColorsDark {
  AppColorsDark._();

  static const Color primary = Color(0xFF516BEA);
  static const Color primaryLight = Color(0xFF7396FF);
  static const Color primaryDark = Color(0xFF3B5BDB);
  static const Color primaryContainer = Color(0xFF263555);
  static const Color onPrimaryContainer = Color(0xFFEDF2FF);

  static const Color rafiqAccentBlue = Color(0xFF7396FF);
  static const Color rafiqMoonGold = Color(0xFFF5E5AD);
  static const Color rafiqSkyNightTop = Color(0xFF0E1B38);
  static const Color rafiqSkyNightMid = Color(0xFF1D3363);
  static const Color rafiqSkyNightBottom = Color(0xFF111A30);

  static const Color background = Color(0xFF111A30);
  static const Color surface = Color(0xFF1C2943);
  static const Color surfaceVariant = Color(0xFF263555);
  static const Color cardBorder = Color(0xFF344460);
  static const Color border = Color(0xFF344460);

  static const Color textPrimary = Color(0xFFEDF2FF);
  static const Color textSecondary = Color(0xFFAFBCD4);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textHint = Color(0xFF94A3B8);
  static const Color textLight = Color(0xFFFFFFFF);

  static const Color success = Color(0xFF4ADE80);
  static const Color successLight = Color(0xFF16382C);
  static const Color successContainer = Color(0xFF16382C);
  static const Color successBorder = Color(0xFF22C55E);

  static const Color warning = Color(0xFFFBBF24);
  static const Color warningLight = Color(0xFF3B2A14);
  static const Color warningContainer = Color(0xFF3B2A14);
  static const Color warningBorder = Color(0xFFD97706);

  static const Color emergency = Color(0xFFEF4444);
  static const Color emergencyRed = Color(0xFFEF4444);
  static const Color emergencyRedDark = Color(0xFF991B1B);
  static const Color emergencyContainer = Color(0xFF3B1A26);
  static const Color onEmergencyContainer = Color(0xFFFECACA);
  static const Color emergencyBorder = Color(0xFFDC2626);

  static const Color chipSelected = Color(0xFF516BEA);
  static const Color chipUnselected = Color(0xFF263555);

  static const Color doctorCardBg = Color(0xFF1E3A5F);
  static const Color doctorIconColor = Color(0xFF93C5FD);

  static const Color medicationCardBg = Color(0xFF16382C);
  static const Color medicationIconColor = Color(0xFF86EFAC);

  static const Color familyCardBg = Color(0xFF2E1D4A);
  static const Color familyIconColor = Color(0xFFD8B4FE);

  static const Color emergencyCardBg = Color(0xFF3B1A26);
  static const Color emergencyIconColor = Color(0xFFFCA5A5);

  static const Color navActive = Color(0xFF7396FF);
  static const Color navInactive = Color(0xFFAFBCD4);

  static const Color divider = Color(0xFF344460);
}
