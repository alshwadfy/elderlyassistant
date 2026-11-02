import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../config/app_config.dart';
import 'socket_service.dart';

/// Reactive Cubit managing the Socket.io connection lifecycle for real-time
/// Family Caregiver Portal events (`reminder_created`, `visit_plan_updated`, `emergency_alert`).
class SocketCubit extends Cubit<SocketConnectionState> {
  SocketCubit({SocketService? service})
      : _service = service ?? SocketService(serverUrl: AppConfig.socketUrl),
        super(SocketConnectionState.idle) {
    _sub = _service.connectionStateStream.listen((nextState) {
      if (!isClosed) emit(nextState);
    });
  }

  final SocketService _service;
  StreamSubscription<SocketConnectionState>? _sub;

  SocketService get service => _service;

  void connect() => _service.connect();

  void retryConnect() => _service.retryConnect();

  @override
  Future<void> close() async {
    await _sub?.cancel();
    _service.dispose();
    return super.close();
  }
}
