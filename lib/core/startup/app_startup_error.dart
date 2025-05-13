import 'package:flutter/widgets.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_error.dart';

/// The widget that shows the error state of the app startup.
class AppStartupError extends StatelessWidget {
  /// The error message.
  const AppStartupError({
    required this.message,
    required this.onRetry,
    super.key,
  });

  /// The error message.
  final String message;

  /// The retry action.
  final void Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return PviError(
      onRetry: onRetry,
      customMessage: message,
    );
  }
}
