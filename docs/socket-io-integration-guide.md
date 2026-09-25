# Socket.io Integration Guide & Architecture (Flutter Client)

This document explains the architecture, connection flow, and step-by-step implementation for integrating Socket.io in this Flutter mobile client.

---

## 1. Architecture Overview

In this app, we follow strict separation of concerns and Riverpod state management rules:

```
[ Backend Socket.io Server ]
          ↕ (WebSocket / Polling)
[ SocketService ] (Single instance in lib/core/socket/)
          ↓ (StreamControllers)
[ Riverpod StreamProviders ] (socket_providers.dart)
          ↓ (ref.watch)
[ UI Screens & Widgets ] (Home, Voice, Banners, etc.)
```

### Key Architectural Rules:
1. **Single Connection Instance**: One shared `SocketService` instance lives in `lib/core/socket/socket_service.dart`. Screens never instantiate or store raw socket references.
2. **Exposed via Riverpod Streams**: Events are converted into Dart typed model streams (`StreamProvider.autoDispose`).
3. **Connection State Feedback**: Any UI listening to live streams surfaces connection state changes (`connecting`, `reconnecting`, `error`, `connected`, `idle`).
4. **Resilience & Fallback**: We configure Socket.io with both `websocket` and `polling` transports, automatic reconnections, and delays.

---

## 2. Step-by-Step Implementation Flow

### Step 1: Add Dependency
In `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.6.1
  socket_io_client: ^3.0.2 # Specific to Socket.io protocol (not web_socket_channel)
```

### Step 2: Define Data Models
Create strongly-typed immutable models in `lib/core/socket/socket_event_models.dart`:
- `ConnectionAck`: Acknowledgment from server on handshake.
- `ElderStatusUpdate`: Live updates for elder status (`active`, `idle`, `alert`).
- `AlertTriggered`: Real-time emergency or notification alert with severity.

### Step 3: Core SocketService (`lib/core/socket/socket_service.dart`)
Create the connection manager:
- Manages connection lifecycle (`connect()`, `retryConnect()`, `dispose()`).
- Broadcast `StreamController`s for events and connection state.
- Configures reconnection settings:
  ```dart
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
  ```

### Step 4: Riverpod Bridge (`lib/core/socket/socket_providers.dart`)
Bridge service events into reactive providers:
```dart
final socketServiceProvider = Provider<SocketService>((ref) {
  final service = SocketService(serverUrl: AppConfig.socketUrl);
  ref.onDispose(service.dispose);
  return service;
});

final socketConnectionStateProvider =
    StreamProvider.autoDispose<SocketConnectionState>((ref) {
  return ref.watch(socketServiceProvider).connectionStateStream;
});

final elderStatusStreamProvider =
    StreamProvider.autoDispose<ElderStatusUpdate>((ref) {
  return ref.watch(socketServiceProvider).elderStatusStream;
});
```

### Step 5: Consuming in UI Screens
In screens (e.g. `HomeShellScreen` or `VoiceAssistantScreen`):
```dart
class ElderStatusWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(elderStatusStreamProvider);

    return statusAsync.when(
      data: (status) => StatusCard(status: status),
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => ErrorView(
        message: 'Could not connect to live status',
        onRetry: () => ref.read(socketServiceProvider).retryConnect(),
      ),
    );
  }
}
```

---

## 3. How to Run with Backend URL

The socket URL is passed via compile-time environment variables (`--dart-define`):

```bash
# Local development against backend on local network:
flutter run -d edge --dart-define=SOCKET_URL=http://localhost:3000

# Testing against staging server:
flutter run -d edge --dart-define=SOCKET_URL=https://staging-api.yourdomain.com
```
