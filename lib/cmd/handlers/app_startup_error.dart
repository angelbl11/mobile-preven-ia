import 'package:flutter/material.dart';

class AppStartupError extends StatelessWidget {
  const AppStartupError({super.key, this.message, this.onRetry});

  /// The error message.
  final String? message;

  /// The retry action.
  final void Function()? onRetry;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
