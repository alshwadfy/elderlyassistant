/// Compile-time configuration for Rafiq (رفيق) Backend & AI APIs.
/// Pass values with `--dart-define`:
/// - `flutter run --dart-define=API_BASE_URL=http://192.168.1.10:3000`
/// - `flutter run --dart-define=AI_BASE_URL=http://192.168.1.10:8000`
/// - `flutter run --dart-define=SOCKET_URL=http://192.168.1.10:3000`
class AppConfig {
  const AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL');
  static const String aiBaseUrl = String.fromEnvironment('AI_BASE_URL');
  static const String socketUrl = String.fromEnvironment('SOCKET_URL');

  static bool get isApiConfigured => apiBaseUrl.isNotEmpty;
  static bool get isAiConfigured => aiBaseUrl.isNotEmpty;
  static bool get isSocketConfigured => socketUrl.isNotEmpty;
}
