import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import 'socket_event_models.dart';
import 'socket_service.dart';

/// Shared SocketService. Does not connect until SOCKET_URL is provided.
final socketServiceProvider = Provider<SocketService>((ref) {
  final service = SocketService(serverUrl: AppConfig.socketUrl);
  ref.onDispose(service.dispose);
  return service;
});

final socketConnectionStateProvider =
    StreamProvider.autoDispose<SocketConnectionState>((ref) {
  final socketService = ref.watch(socketServiceProvider);
  return socketService.connectionStateStream;
});

final elderStatusStreamProvider =
    StreamProvider.autoDispose<ElderStatusUpdate>((ref) {
  final socketService = ref.watch(socketServiceProvider);
  return socketService.elderStatusStream;
});

final alertTriggeredStreamProvider =
    StreamProvider.autoDispose<AlertTriggered>((ref) {
  final socketService = ref.watch(socketServiceProvider);
  return socketService.alertTriggeredStream;
});

final connectionAckStreamProvider =
    StreamProvider.autoDispose<ConnectionAck>((ref) {
  final socketService = ref.watch(socketServiceProvider);
  return socketService.connectionAckStream;
});
