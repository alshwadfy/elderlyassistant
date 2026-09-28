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

  // Text colors — High contrast for elderly accessibility
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900 (crisp near-black)
  static const Color textSecondary = Color(0xFF334155); // Slate 700 (high contrast subtitle/body)
  static const Color textMuted = Color(0xFF475569); // Slate 600 (accessible muted/placeholder text)
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
  static const Color navInactive = Color(0xFF475569); // Slate 600 (accessible inactive state)
  static const Color navActive = Color(0xFF3B5BDB);

  // Chip/filter
  static const Color chipSelected = Color(0xFF3B5BDB);
  static const Color chipUnselected = Color(0xFFF1F5F9);
  static const Color chipTextUnselected = Color(0xFF334155); // Slate 700
}

/// Dark theme color palette for AI Elderly Assistant.
/// High contrast, easy on the eyes in low light conditions.
class AppColorsDark {
  const AppColorsDark._();

  static const Color primary = Color(0xFF5C7CFA);
  static const Color primaryLight = Color(0xFF748FFC);
  static const Color primaryContainer = Color(0xFF1E293B);
  static const Color primarySurface = Color(0xFF1E293B);

  static const Color secondary = Color(0xFF14B8A6);
  static const Color secondaryContainer = Color(0xFF134E4A);

  static const Color background = Color(0xFF0F172A); // Slate 900
  static const Color surface = Color(0xFF1E293B); // Slate 800
  static const Color cardBorder = Color(0xFF334155); // Slate 700

  static const Color emergency = Color(0xFFEF4444);
  static const Color emergencyContainer = Color(0xFF450A0A);

  static const Color textPrimary = Color(0xFFF8FAFC); // Slate 50
  static const Color textSecondary = Color(0xFFCBD5E1); // Slate 300
  static const Color textMuted = Color(0xFF94A3B8); // Slate 400
  static const Color textLight = Color(0xFFFFFFFF);

  static const Color success = Color(0xFF4ADE80);
  static const Color successContainer = Color(0xFF052E16);

  static const Color warning = Color(0xFFFACC15);
  static const Color warningContainer = Color(0xFF422006);

  static const Color border = Color(0xFF334155);
  static const Color divider = Color(0xFF1E293B);

  static const Color navInactive = Color(0xFF94A3B8);
  static const Color navActive = Color(0xFF5C7CFA);

  static const Color chipSelected = Color(0xFF5C7CFA);
  static const Color chipUnselected = Color(0xFF334155);
  static const Color chipTextUnselected = Color(0xFFCBD5E1);
}

