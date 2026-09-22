import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'socket_service.dart';

/// Shared SocketService. Connection is opt-in until the backend URL is confirmed.
final socketServiceProvider = Provider<SocketService>((ref) {
  final service = SocketService();
  ref.onDispose(service.dispose);
  return service;
});

/// StreamProvider for connection state changes
final socketConnectionStateProvider =
    StreamProvider.autoDispose<SocketConnectionState>((ref) {
  final socketService = ref.watch(socketServiceProvider);
  return socketService.connectionStateStream;
});

/// StreamProvider for live elder status update event
final elderStatusStreamProvider =
    StreamProvider.autoDispose<Map<String, dynamic>>((ref) {
  final socketService = ref.watch(socketServiceProvider);
  return socketService.elderStatusStream;
});

/// StreamProvider for live alert triggered event
final alertTriggeredStreamProvider =
    StreamProvider.autoDispose<Map<String, dynamic>>((ref) {
  final socketService = ref.watch(socketServiceProvider);
  return socketService.alertTriggeredStream;
});
