import '../utils/json_map.dart';

enum ElderLiveStatus { active, idle, alert }

enum AlertSeverity { low, medium, high }

class ElderStatusUpdate {
  const ElderStatusUpdate({
    required this.elderId,
    required this.status,
    required this.timestamp,
    this.location,
  });

  final String elderId;
  final ElderLiveStatus status;
  final DateTime timestamp;
  final String? location;

  factory ElderStatusUpdate.fromJson(Map<String, dynamic> json) {
    return ElderStatusUpdate(
      elderId: JsonMap.requiredString(json, 'elderId'),
      status: _parseElderStatus(JsonMap.requiredString(json, 'status')),
      timestamp: JsonMap.requiredIsoDate(json, 'timestamp'),
      location: JsonMap.optionalString(json, 'location'),
    );
  }
}

class AlertTriggered {
  const AlertTriggered({
    required this.alertId,
    required this.elderId,
    required this.alertType,
    required this.severity,
    required this.timestamp,
  });

  final String alertId;
  final String elderId;
  final String alertType;
  final AlertSeverity severity;
  final DateTime timestamp;

  factory AlertTriggered.fromJson(Map<String, dynamic> json) {
    return AlertTriggered(
      alertId: JsonMap.requiredString(json, 'alertId'),
      elderId: JsonMap.requiredString(json, 'elderId'),
      alertType: JsonMap.requiredString(json, 'alertType'),
      severity: _parseSeverity(JsonMap.requiredString(json, 'severity')),
      timestamp: JsonMap.requiredIsoDate(json, 'timestamp'),
    );
  }
}

class ConnectionAck {
  const ConnectionAck({
    required this.connected,
    required this.elderId,
  });

  final bool connected;
  final String elderId;

  factory ConnectionAck.fromJson(Map<String, dynamic> json) {
    return ConnectionAck(
      connected: JsonMap.requiredBool(json, 'connected'),
      elderId: JsonMap.requiredString(json, 'elderId'),
    );
  }
}

ElderLiveStatus _parseElderStatus(String raw) {
  return switch (raw.toLowerCase()) {
    'idle' => ElderLiveStatus.idle,
    'alert' => ElderLiveStatus.alert,
    _ => ElderLiveStatus.active,
  };
}

AlertSeverity _parseSeverity(String raw) {
  return switch (raw.toLowerCase()) {
    'medium' => AlertSeverity.medium,
    'high' => AlertSeverity.high,
    _ => AlertSeverity.low,
  };
}
