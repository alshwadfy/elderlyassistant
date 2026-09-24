/// Safe JSON helpers for Socket.io and REST payloads.
class JsonMap {
  const JsonMap._();

  static Map<String, dynamic>? asStringKeyMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value));
    }
    return null;
  }

  static String requiredString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) {
      throw FormatException('Missing required field: $key');
    }
    return value.toString();
  }

  static String? optionalString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) return null;
    return value.toString();
  }

  static bool requiredBool(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is bool) return value;
    if (value == null) {
      throw FormatException('Missing required field: $key');
    }
    return value.toString().toLowerCase() == 'true';
  }

  static DateTime requiredIsoDate(Map<String, dynamic> json, String key) {
    return DateTime.parse(requiredString(json, key));
  }
}
