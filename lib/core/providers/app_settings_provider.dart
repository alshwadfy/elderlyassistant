import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppSettingsState {
  const AppSettingsState({
    this.themeMode = ThemeMode.light,
    this.appearanceMode = 'auto', // 'auto', 'light', 'dark'
    this.locale = const Locale('ar'),
    this.fontScale = 1.0,
    this.letterSpacing = 0.0,
    this.contrastLevel = 1.0,
    this.highContrast = false,
    this.isReadingAloud = false,
    this.voicePersona = 'warm', // 'warm' | 'clear' | 'family'
    this.speechSpeed = 'normal', // 'slow' | 'normal' | 'fast'
    this.pillAlertVolume = 'high', // 'high' | 'medium' | 'low'
    this.pillVibration = true,
    this.pillSpokenReminder = true,
    this.dailyCheckInEnabled = true,
    this.notificationsEnabled = true,
    this.locationWhileUsingEnabled = true,
    this.trustedPersonSharingConsent = false,
  });

  final ThemeMode themeMode;
  final String appearanceMode;
  final Locale locale;
  final double fontScale;
  final double letterSpacing;
  final double contrastLevel;
  final bool highContrast;
  final bool isReadingAloud;

  // Rafiq Voice & Speech Settings
  final String voicePersona;
  final String speechSpeed;

  // Rafiq Medication Alert Settings
  final String pillAlertVolume;
  final bool pillVibration;
  final bool pillSpokenReminder;

  // Optional Daily Check-in
  final bool dailyCheckInEnabled;

  // Permissions & Privacy
  final bool notificationsEnabled;
  final bool locationWhileUsingEnabled;
  final bool trustedPersonSharingConsent;

  bool get isDarkMode => themeMode == ThemeMode.dark;
  bool get isArabic => locale.languageCode == 'ar';
  AppSettingsState get accessibility => this;

  String get voicePersonaLabelAr {
    return switch (voicePersona) {
      'clear' => 'واضح ومباشر',
      'family' => 'أسلوب فرد من العائلة',
      _ => 'دافئ ولطيف',
    };
  }

  String get speechSpeedLabelAr {
    return switch (speechSpeed) {
      'slow' => 'بطيء',
      'fast' => 'سريع',
      _ => 'عادي',
    };
  }

  double get numericSpeechRate {
    return switch (speechSpeed) {
      'slow' => 0.85,
      'fast' => 1.15,
      _ => 1.0,
    };
  }

  String get appearanceSubtitleAr {
    return switch (appearanceMode) {
      'light' => 'دائمًا فاتح · نهار',
      'dark' => 'دائمًا داكن · ليل',
      _ => isDarkMode ? 'تلقائي · ليل' : 'تلقائي · نهار',
    };
  }

  AppSettingsState copyWith({
    ThemeMode? themeMode,
    String? appearanceMode,
    Locale? locale,
    double? fontScale,
    double? letterSpacing,
    double? contrastLevel,
    bool? highContrast,
    bool? isReadingAloud,
    String? voicePersona,
    String? speechSpeed,
    String? pillAlertVolume,
    bool? pillVibration,
    bool? pillSpokenReminder,
    bool? dailyCheckInEnabled,
    bool? notificationsEnabled,
    bool? locationWhileUsingEnabled,
    bool? trustedPersonSharingConsent,
  }) {
    return AppSettingsState(
      themeMode: themeMode ?? this.themeMode,
      appearanceMode: appearanceMode ?? this.appearanceMode,
      locale: locale ?? this.locale,
      fontScale: fontScale ?? this.fontScale,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      contrastLevel: contrastLevel ?? this.contrastLevel,
      highContrast: highContrast ?? this.highContrast,
      isReadingAloud: isReadingAloud ?? this.isReadingAloud,
      voicePersona: voicePersona ?? this.voicePersona,
      speechSpeed: speechSpeed ?? this.speechSpeed,
      pillAlertVolume: pillAlertVolume ?? this.pillAlertVolume,
      pillVibration: pillVibration ?? this.pillVibration,
      pillSpokenReminder: pillSpokenReminder ?? this.pillSpokenReminder,
      dailyCheckInEnabled: dailyCheckInEnabled ?? this.dailyCheckInEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      locationWhileUsingEnabled:
          locationWhileUsingEnabled ?? this.locationWhileUsingEnabled,
      trustedPersonSharingConsent:
          trustedPersonSharingConsent ?? this.trustedPersonSharingConsent,
    );
  }
}

/// Manages global application settings, appearance (Day/Night/Auto),
/// accessibility scaling, voice persona, and privacy preferences via `Cubit`.
class AppSettingsCubit extends Cubit<AppSettingsState> {
  AppSettingsCubit() : super(const AppSettingsState());

  void toggleTheme() {
    final nextDark = state.themeMode != ThemeMode.dark;
    emit(
      state.copyWith(
        themeMode: nextDark ? ThemeMode.dark : ThemeMode.light,
        appearanceMode: nextDark ? 'dark' : 'light',
      ),
    );
  }

  void setThemeMode(ThemeMode mode) {
    emit(
      state.copyWith(
        themeMode: mode,
        appearanceMode: mode == ThemeMode.dark ? 'dark' : 'light',
      ),
    );
  }

  void setAppearanceMode(String mode) {
    if (mode == 'dark') {
      emit(
        state.copyWith(
          appearanceMode: 'dark',
          themeMode: ThemeMode.dark,
        ),
      );
    } else if (mode == 'light') {
      emit(
        state.copyWith(
          appearanceMode: 'light',
          themeMode: ThemeMode.light,
        ),
      );
    } else {
      final hour = DateTime.now().hour;
      final isNight = hour >= 18 || hour < 6;
      emit(
        state.copyWith(
          appearanceMode: 'auto',
          themeMode: isNight ? ThemeMode.dark : ThemeMode.light,
        ),
      );
    }
  }

  void setLocale(Locale locale) {
    emit(state.copyWith(locale: locale));
  }

  void toggleLocale() {
    emit(
      state.copyWith(
        locale: state.locale.languageCode == 'en'
            ? const Locale('ar')
            : const Locale('en'),
      ),
    );
  }

  void setFontScale(double scale) {
    final rounded = ((scale.clamp(0.85, 1.45) * 100).round()) / 100.0;
    emit(state.copyWith(fontScale: rounded));
  }

  void increaseFontScale() => setFontScale(state.fontScale + 0.15);
  void decreaseFontScale() => setFontScale(state.fontScale - 0.15);
  void increaseFontSize() => increaseFontScale();
  void decreaseFontSize() => decreaseFontScale();

  void setLetterSpacing(double spacing) {
    emit(state.copyWith(letterSpacing: spacing.clamp(0.0, 2.0)));
  }

  void increaseLetterSpacing() => setLetterSpacing(state.letterSpacing + 0.5);
  void decreaseLetterSpacing() => setLetterSpacing(state.letterSpacing - 0.5);
  void increaseTextSpacing() => increaseLetterSpacing();
  void decreaseTextSpacing() => decreaseLetterSpacing();

  void increaseContrast() {
    emit(
      state.copyWith(
        contrastLevel: (state.contrastLevel + 0.25).clamp(1.0, 1.5),
      ),
    );
  }

  void decreaseContrast() {
    emit(
      state.copyWith(
        contrastLevel: (state.contrastLevel - 0.25).clamp(1.0, 1.5),
      ),
    );
  }

  void toggleHighContrast() {
    emit(state.copyWith(highContrast: !state.highContrast));
  }

  void setHighContrast(bool enabled) {
    emit(state.copyWith(highContrast: enabled));
  }

  void toggleReadAloud() {
    emit(state.copyWith(isReadingAloud: !state.isReadingAloud));
  }

  void setVoicePersona(String persona) {
    emit(state.copyWith(voicePersona: persona));
  }

  void setSpeechSpeed(String speed) {
    emit(state.copyWith(speechSpeed: speed));
  }

  void setPillAlertVolume(String volume) {
    emit(state.copyWith(pillAlertVolume: volume));
  }

  void setPillVibration(bool value) {
    emit(state.copyWith(pillVibration: value));
  }

  void setPillSpokenReminder(bool value) {
    emit(state.copyWith(pillSpokenReminder: value));
  }

  void setDailyCheckInEnabled(bool value) {
    emit(state.copyWith(dailyCheckInEnabled: value));
  }

  void setNotificationsEnabled(bool value) {
    emit(state.copyWith(notificationsEnabled: value));
  }

  void setLocationWhileUsingEnabled(bool value) {
    emit(state.copyWith(locationWhileUsingEnabled: value));
  }

  void setTrustedPersonSharingConsent(bool value) {
    emit(state.copyWith(trustedPersonSharingConsent: value));
  }

  void resetAccessibility() {
    emit(
      state.copyWith(
        fontScale: 1.0,
        letterSpacing: 0.0,
        contrastLevel: 1.0,
        highContrast: false,
        isReadingAloud: false,
      ),
    );
  }

  void resetDefaults() => resetAccessibility();
}

typedef AccessibilityState = AppSettingsState;
typedef AccessibilityNotifier = AppSettingsCubit;
typedef AppSettingsNotifier = AppSettingsCubit;
