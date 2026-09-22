import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as io;

enum SocketConnectionState { connecting, connected, disconnected, reconnecting, error }

/// Shared Socket.io connection manager for real-time events.
class SocketService {
  SocketService({this.serverUrl = 'http://10.0.2.2:3000'});

  final String serverUrl;
  io.Socket? _socket;

  final StreamController<SocketConnectionState> _connectionStateController =
      StreamController<SocketConnectionState>.broadcast();
  final StreamController<Map<String, dynamic>> _elderStatusController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _alertTriggeredController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<SocketConnectionState> get connectionStateStream => _connectionStateController.stream;
  Stream<Map<String, dynamic>> get elderStatusStream => _elderStatusController.stream;
  Stream<Map<String, dynamic>> get alertTriggeredStream => _alertTriggeredController.stream;

  SocketConnectionState _currentState = SocketConnectionState.disconnected;
  SocketConnectionState get currentState => _currentState;

  void connect() {
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

    // Contract events: elder_status_update & alert_triggered
    _socket!.on('elder_status_update', (data) {
      if (data is Map) {
        _elderStatusController.add(Map<String, dynamic>.from(data));
      }
    });

    _socket!.on('alert_triggered', (data) {
      if (data is Map) {
        _alertTriggeredController.add(Map<String, dynamic>.from(data));
      }
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
  }
}
