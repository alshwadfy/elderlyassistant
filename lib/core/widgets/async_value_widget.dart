import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'error_view.dart';
import '../theme/app_colors.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    required this.onRetry,
    this.loadingWidget,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback onRetry;
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      error: (err, stack) => ErrorView(
        message: err.toString(),
        onRetry: onRetry,
      ),
      loading: () =>
          loadingWidget ??
          const Center(
            child: CircularProgressIndicator(
              strokeWidth: 4.0,
              color: AppColors.primary,
            ),
          ),
    );
  }
}
