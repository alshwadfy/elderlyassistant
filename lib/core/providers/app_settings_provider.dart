import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// StateNotifier for controlling the application Locale (English / Arabic).
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en'));

  void setLocale(Locale locale) {
    state = locale;
  }

  void toggleLanguage() {
    state = state.languageCode == 'en' ? const Locale('ar') : const Locale('en');
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

/// StateNotifier for controlling the application ThemeMode (Light / Dark).
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.light);

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

/// Accessibility settings supporting font size scaling, text spacing,
/// contrast adjustment, and high-contrast toggle.
class AccessibilitySettings {
  final double fontScale;
  final double letterSpacing;
  final double contrastLevel;
  final bool highContrast;

  const AccessibilitySettings({
    this.fontScale = 1.0,
    this.letterSpacing = 0.0,
    this.contrastLevel = 1.0,
    this.highContrast = false,
  });

  AccessibilitySettings copyWith({
    double? fontScale,
    double? letterSpacing,
    double? contrastLevel,
    bool? highContrast,
  }) {
    return AccessibilitySettings(
      fontScale: fontScale ?? this.fontScale,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      contrastLevel: contrastLevel ?? this.contrastLevel,
      highContrast: highContrast ?? this.highContrast,
    );
  }
}

class AccessibilityNotifier extends StateNotifier<AccessibilitySettings> {
  AccessibilityNotifier() : super(const AccessibilitySettings());

  void increaseFontSize() {
    final next = (state.fontScale + 0.15).clamp(0.85, 1.6);
    state = state.copyWith(fontScale: double.parse(next.toStringAsFixed(2)));
  }

  void decreaseFontSize() {
    final next = (state.fontScale - 0.15).clamp(0.85, 1.6);
    state = state.copyWith(fontScale: double.parse(next.toStringAsFixed(2)));
  }

  void increaseTextSpacing() {
    final next = (state.letterSpacing + 0.5).clamp(0.0, 2.5);
    state = state.copyWith(letterSpacing: double.parse(next.toStringAsFixed(1)));
  }

  void decreaseTextSpacing() {
    final next = (state.letterSpacing - 0.5).clamp(0.0, 2.5);
    state = state.copyWith(letterSpacing: double.parse(next.toStringAsFixed(1)));
  }

  void increaseContrast() {
    final next = (state.contrastLevel + 0.25).clamp(1.0, 1.75);
    state = state.copyWith(contrastLevel: double.parse(next.toStringAsFixed(2)));
  }

  void decreaseContrast() {
    final next = (state.contrastLevel - 0.25).clamp(1.0, 1.75);
    state = state.copyWith(contrastLevel: double.parse(next.toStringAsFixed(2)));
  }

  void toggleHighContrast() {
    state = state.copyWith(highContrast: !state.highContrast);
  }

  void resetDefaults() {
    state = const AccessibilitySettings();
  }
}

final accessibilityProvider =
    StateNotifierProvider<AccessibilityNotifier, AccessibilitySettings>((ref) {
  return AccessibilityNotifier();
});

