import 'package:flutter/material.dart';

/// Color palette extracted from the Figma design for AI Elderly Assistant.
/// High-contrast, accessibility-first for elderly users.
class AppColors {
  const AppColors._();

  // Primary Blues — from Figma design
  static const Color primary = Color(0xFF3B5BDB); // Main blue (buttons, nav active)
  static const Color primaryLight = Color(0xFF6B8AFF); // Lighter blue accents
  static const Color primaryContainer = Color(0xFFEEF2FF); // Blue tinted background
  static const Color primarySurface = Color(0xFFF0F4FF); // Feature card background

  // Secondary / Teal
  static const Color secondary = Color(0xFF0F766E);
  static const Color secondaryContainer = Color(0xFFCCFBF1);

  // Background & Surface
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE2E8F0);

  // Emergency Red/Coral — from Figma emergency screen
  static const Color emergency = Color(0xFFE53E3E);
  static const Color emergencyLight = Color(0xFFFF6B6B);
  static const Color emergencyContainer = Color(0xFFFEE2E2);
  static const Color emergencyBg = Color(0xFFFFF5F5);

  // Text colors
  static const Color textPrimary = Color(0xFF1A202C); // Near black
  static const Color textSecondary = Color(0xFF64748B); // Grey subtitle
  static const Color textMuted = Color(0xFF94A3B8); // Muted/placeholder
  static const Color textLight = Color(0xFFFFFFFF);

  // Success / completion
  static const Color success = Color(0xFF38A169);
  static const Color successContainer = Color(0xFFC6F6D5);

  // Warning
  static const Color warning = Color(0xFFD69E2E);
  static const Color warningContainer = Color(0xFFFEFCBF);

  // Borders & dividers
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFEDF2F7);

  // Bottom navigation
  static const Color navInactive = Color(0xFF94A3B8);
  static const Color navActive = Color(0xFF3B5BDB);

  // Chip/filter
  static const Color chipSelected = Color(0xFF3B5BDB);
  static const Color chipUnselected = Color(0xFFF1F5F9);
  static const Color chipTextUnselected = Color(0xFF475569);
}
