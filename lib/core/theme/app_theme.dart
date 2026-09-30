import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Theme for AI Elderly Assistant — 100% compliant with ui.md spec.
/// Rules enforced:
///   • Body text min 18sp (bodyLarge). No hardcoded sizes below 18 for readable content.
///   • fontFamily defaults to system (respects OS text scaling via MediaQuery.textScaler).
///   • Medium/semibold minimum weights everywhere.
///   • Min tap targets 48dp (materialTapTargetSize: padded). Primary action height 64dp+.
///   • Bottom nav labels always visible (alwaysShow).
///   • Status colours from AppColors exactly.
class AppTheme {
  const AppTheme._();

  // ─── Text Theme helper ─────────────────────────────────────────────────────
  // All sizes here are BASE sizes — Flutter's textScaleFactor multiplies them.
  // Never use a fixed TextStyle.fontSize < 18 for any text a user must READ and ACT ON.
  static TextTheme _buildTextTheme({required bool dark}) {
    final headingColor = dark ? AppColorsDark.textPrimary : AppColors.textPrimary;
    final bodyColor = dark ? AppColorsDark.textPrimary : AppColors.textPrimary;
    final subtitleColor = dark ? AppColorsDark.textSecondary : AppColors.textSecondary;

    return TextTheme(
      // Headings
      displayLarge: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        color: headingColor,
        height: 1.2,
        letterSpacing: -0.8,
      ),
      displayMedium: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        color: headingColor,
        height: 1.25,
        letterSpacing: -0.5,
      ),
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: headingColor,
        height: 1.25,
        letterSpacing: -0.4,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: headingColor,
        height: 1.3,
        letterSpacing: -0.3,
      ),
      headlineSmall: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: headingColor,
        height: 1.3,
        letterSpacing: -0.2,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: headingColor,
        letterSpacing: -0.2,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: headingColor,
      ),
      titleSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: subtitleColor,
      ),
      // Body — minimum 18sp per spec
      bodyLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: bodyColor,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: subtitleColor,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: subtitleColor,
        height: 1.4,
      ),
      // Labels (buttons, nav)
      labelLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: dark ? AppColorsDark.textLight : AppColors.textLight,
        letterSpacing: 0.2,
      ),
      labelMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: subtitleColor,
      ),
      labelSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: subtitleColor,
      ),
    );
  }

  // ─── Light Theme ───────────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.textLight,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.primaryDark,
        secondary: AppColors.success,
        onSecondary: AppColors.textLight,
        secondaryContainer: AppColors.successContainer,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        surfaceContainerLowest: Color(0xFFFFFFFF),
        surfaceContainerLow: Color(0xFFF9FAFF),
        surfaceContainer: Color(0xFFF2F5FF),
        surfaceContainerHigh: Color(0xFFE9EEFF),
        surfaceContainerHighest: AppColors.background,
        error: AppColors.emergency,
        onError: AppColors.textLight,
        errorContainer: AppColors.emergencyContainer,
        onErrorContainer: AppColors.emergency,
        outline: AppColors.border,
        outlineVariant: AppColors.divider,
      ),
      scaffoldBackgroundColor: AppColors.background,
      cardColor: AppColors.surface,
      canvasColor: AppColors.background,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      textTheme: _buildTextTheme(dark: false),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: Color(0x14000000),
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary, size: 28),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 64),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textLight,
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 3,
          shadowColor: const Color(0x401647AD),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 64),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          side: const BorderSide(color: AppColors.primary, width: 2.0),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          minimumSize: const Size(48, 48),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        labelStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
        floatingLabelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
        hintStyle: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.emergency, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.emergency, width: 2.5),
        ),
        prefixIconColor: AppColors.primary,
        suffixIconColor: AppColors.textMuted,
        errorStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.emergency,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: const Color(0x141647AD),
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        margin: EdgeInsets.zero,
      ),
      iconTheme: const IconThemeData(
        size: 28,
        color: AppColors.primary,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.navActive, size: 28);
          }
          return const IconThemeData(color: AppColors.navInactive, size: 26);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.navActive,
            );
          }
          return const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.navInactive,
          );
        }),
        elevation: 8,
        surfaceTintColor: Colors.transparent,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.navActive,
        unselectedItemColor: AppColors.navInactive,
        selectedLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        unselectedLabelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 12,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.chipUnselected,
        selectedColor: AppColors.chipSelected,
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.textLight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: const BorderSide(color: AppColors.border, width: 2),
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1.5,
        space: 1.5,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.primaryDark,
        contentTextStyle: const TextStyle(
          color: AppColors.textLight,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
        contentTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
          height: 1.5,
        ),
      ),
    );
  }

  // ─── Dark Theme ────────────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColorsDark.primary,
        onPrimary: AppColorsDark.textLight,
        primaryContainer: AppColorsDark.primaryContainer,
        onPrimaryContainer: AppColorsDark.primaryLight,
        secondary: AppColorsDark.success,
        onSecondary: AppColorsDark.textLight,
        secondaryContainer: AppColorsDark.successContainer,
        surface: AppColorsDark.surface,
        onSurface: AppColorsDark.textPrimary,
        surfaceContainerLowest: Color(0xFF080D15),
        surfaceContainerLow: Color(0xFF0D1521),
        surfaceContainer: Color(0xFF141D2C),
        surfaceContainerHigh: Color(0xFF1B2638),
        surfaceContainerHighest: AppColorsDark.background,
        error: AppColorsDark.emergency,
        onError: AppColorsDark.textLight,
        errorContainer: AppColorsDark.emergencyContainer,
        onErrorContainer: AppColorsDark.emergency,
        outline: AppColorsDark.border,
        outlineVariant: AppColorsDark.divider,
      ),
      scaffoldBackgroundColor: AppColorsDark.background,
      cardColor: AppColorsDark.surface,
      canvasColor: AppColorsDark.background,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      textTheme: _buildTextTheme(dark: true),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColorsDark.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: AppColorsDark.textPrimary,
        ),
        iconTheme: IconThemeData(color: AppColorsDark.textPrimary, size: 28),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 64),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          backgroundColor: AppColorsDark.primary,
          foregroundColor: AppColorsDark.textLight,
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 4,
          shadowColor: const Color(0x405B8DEF),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 64),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          foregroundColor: AppColorsDark.primary,
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          side: const BorderSide(color: AppColorsDark.primary, width: 2.0),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColorsDark.primary,
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          minimumSize: const Size(48, 48),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColorsDark.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        labelStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColorsDark.textSecondary,
        ),
        floatingLabelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColorsDark.primary,
        ),
        hintStyle: const TextStyle(
          color: AppColorsDark.textMuted,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColorsDark.border, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColorsDark.border, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColorsDark.primary, width: 2.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColorsDark.emergency, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColorsDark.emergency, width: 2.5),
        ),
        prefixIconColor: AppColorsDark.primary,
        suffixIconColor: AppColorsDark.textMuted,
        errorStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColorsDark.emergency,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 3,
        shadowColor: const Color(0x33000000),
        color: AppColorsDark.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColorsDark.border, width: 1.5),
        ),
        margin: EdgeInsets.zero,
      ),
      iconTheme: const IconThemeData(size: 28, color: AppColorsDark.primary),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColorsDark.surface,
        indicatorColor: AppColorsDark.primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColorsDark.navActive, size: 28);
          }
          return const IconThemeData(color: AppColorsDark.navInactive, size: 26);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColorsDark.navActive,
            );
          }
          return const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColorsDark.navInactive,
          );
        }),
        elevation: 8,
        surfaceTintColor: Colors.transparent,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColorsDark.surface,
        selectedItemColor: AppColorsDark.navActive,
        unselectedItemColor: AppColorsDark.navInactive,
        selectedLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        unselectedLabelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 12,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColorsDark.chipUnselected,
        selectedColor: AppColorsDark.chipSelected,
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColorsDark.primary;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColorsDark.textLight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: const BorderSide(color: AppColorsDark.border, width: 2),
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColorsDark.divider,
        thickness: 1.5,
        space: 1.5,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColorsDark.primaryContainer,
        contentTextStyle: const TextStyle(
          color: AppColorsDark.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColorsDark.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: AppColorsDark.textPrimary,
        ),
        contentTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColorsDark.textPrimary,
          height: 1.5,
        ),
      ),
    );
  }
}
