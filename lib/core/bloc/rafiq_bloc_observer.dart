import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Centralized observability for all Blocs and Cubits in Rafiq (رفيق).
///
/// Logs every Event -> State transition and uncaught error so that mission-critical
/// flows (Emergency SOS 15s escalation & 9-step AI Voice Pipeline) have a deterministic
/// audit trail during development and production diagnostics.
class RafiqBlocObserver extends BlocObserver {
  const RafiqBlocObserver();

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    if (kDebugMode) {
      debugPrint('[RafiqBlocEvent] ${bloc.runtimeType} -> $event');
    }
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    if (kDebugMode) {
      debugPrint(
        '[RafiqBlocTransition] ${bloc.runtimeType}: '
        '${transition.currentState.runtimeType} --(${transition.event.runtimeType})--> '
        '${transition.nextState.runtimeType}',
      );
    }
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      debugPrint('[RafiqBlocError] ${bloc.runtimeType}: $error');
    }
    super.onError(bloc, error, stackTrace);
  }
}
