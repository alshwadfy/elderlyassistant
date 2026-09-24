import 'package:flutter/material.dart';
import '../socket/socket_service.dart';
import '../theme/app_colors.dart';

/// Surfaces Socket.io connection changes. Hidden while connected or idle.
class ConnectionStatusBanner extends StatelessWidget {
  const ConnectionStatusBanner({
    super.key,
    required this.state,
    this.onRetry,
  });

  final SocketConnectionState state;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final config = _configFor(state);
    if (config == null) return const SizedBox.shrink();

    return Material(
      color: config.background,
      child: SafeArea(
        top: false,
        bottom: false,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(config.icon, color: config.foreground),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    config.message,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: config.foreground,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                if (config.showRetry && onRetry != null)
                  TextButton(
                    onPressed: onRetry,
                    child: Text(
                      'Retry',
                      style: TextStyle(
                        color: config.foreground,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _BannerConfig? _configFor(SocketConnectionState state) {
    return switch (state) {
      SocketConnectionState.reconnecting => const _BannerConfig(
          message: 'Reconnecting to live updates…',
          background: AppColors.warningContainer,
          foreground: AppColors.textPrimary,
          icon: Icons.wifi_protected_setup,
        ),
      SocketConnectionState.error => const _BannerConfig(
          message: 'Live updates unavailable. Tap Retry.',
          background: AppColors.emergencyContainer,
          foreground: AppColors.emergency,
          icon: Icons.wifi_off,
          showRetry: true,
        ),
      SocketConnectionState.disconnected ||
      SocketConnectionState.connecting ||
      SocketConnectionState.connected =>
        null,
    };
  }
}

class _BannerConfig {
  const _BannerConfig({
    required this.message,
    required this.background,
    required this.foreground,
    required this.icon,
    this.showRetry = false,
  });

  final String message;
  final Color background;
  final Color foreground;
  final IconData icon;
  final bool showRetry;
}
