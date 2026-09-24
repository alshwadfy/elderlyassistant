/// Compile-time config. Pass values with `--dart-define`.
///
/// Socket URL is intentionally unset until the backend team confirms it.
/// Example: `flutter run --dart-define=SOCKET_URL=http://192.168.1.10:3000`
class AppConfig {
  const AppConfig._();

  static const String socketUrl = String.fromEnvironment('SOCKET_URL');

  static bool get isSocketConfigured => socketUrl.isNotEmpty;
}
