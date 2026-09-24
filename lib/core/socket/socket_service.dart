import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../utils/json_map.dart';
import 'socket_event_models.dart';

enum SocketConnectionState {
  idle,
  connecting,
  connected,
  disconnected,
  reconnecting,
  error,
}

/// Shared Socket.io connection manager for real-time events.
class SocketService {
  SocketService({this.serverUrl = ''});

  final String serverUrl;
  io.Socket? _socket;

  final StreamController<SocketConnectionState> _connectionStateController =
      StreamController<SocketConnectionState>.broadcast();
  final StreamController<ElderStatusUpdate> _elderStatusController =
      StreamController<ElderStatusUpdate>.broadcast();
  final StreamController<AlertTriggered> _alertTriggeredController =
      StreamController<AlertTriggered>.broadcast();
  final StreamController<ConnectionAck> _connectionAckController =
      StreamController<ConnectionAck>.broadcast();

  Stream<SocketConnectionState> get connectionStateStream =>
      _connectionStateController.stream;
  Stream<ElderStatusUpdate> get elderStatusStream =>
      _elderStatusController.stream;
  Stream<AlertTriggered> get alertTriggeredStream =>
      _alertTriggeredController.stream;
  Stream<ConnectionAck> get connectionAckStream =>
      _connectionAckController.stream;

  SocketConnectionState _currentState = SocketConnectionState.idle;
  SocketConnectionState get currentState => _currentState;
  bool get isConfigured => serverUrl.isNotEmpty;

  void connect() {
    if (!isConfigured) {
      _updateState(SocketConnectionState.idle);
      return;
    }
    if (_socket != null && _socket!.connected) return;

    _updateState(SocketConnectionState.connecting);

    _socket = io.io(
      serverUrl,
      io.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .enableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(2000)
          .build(),
    );

    _socket!.onConnect((_) {
      _updateState(SocketConnectionState.connected);
    });

    _socket!.onDisconnect((_) {
      _updateState(SocketConnectionState.disconnected);
    });

    _socket!.onReconnectAttempt((_) {
      _updateState(SocketConnectionState.reconnecting);
    });

    _socket!.onConnectError((err) {
      _updateState(SocketConnectionState.error);
    });

    _socket!.onError((err) {
      _updateState(SocketConnectionState.error);
    });

    _socket!.on('connection_ack', (data) {
      final json = JsonMap.asStringKeyMap(data);
      if (json == null) return;
      _connectionAckController.add(ConnectionAck.fromJson(json));
    });

    _socket!.on('elder_status_update', (data) {
      final json = JsonMap.asStringKeyMap(data);
      if (json == null) return;
      _elderStatusController.add(ElderStatusUpdate.fromJson(json));
    });

    _socket!.on('alert_triggered', (data) {
      final json = JsonMap.asStringKeyMap(data);
      if (json == null) return;
      _alertTriggeredController.add(AlertTriggered.fromJson(json));
    });

    _socket!.connect();
  }

  void retryConnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    connect();
  }

  void _updateState(SocketConnectionState state) {
    _currentState = state;
    if (!_connectionStateController.isClosed) {
      _connectionStateController.add(state);
    }
  }

  void dispose() {
    _socket?.disconnect();
    _socket?.dispose();
    _connectionStateController.close();
    _elderStatusController.close();
    _alertTriggeredController.close();
    _connectionAckController.close();
  }
}
