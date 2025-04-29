import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text.dart';

/// YFErrorWidget
class PviError extends ConsumerWidget {
  /// Constructor
  const PviError({
    super.key,
    this.onRetry,
    this.onClose,
    this.customMessage,
    this.isNetworkError = false,
  });

  /// Function to retry
  final void Function()? onRetry;

  /// Function to close
  final void Function()? onClose;

  /// Custom message
  final String? customMessage;

  /// Is network error
  final bool isNetworkError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lotties/error.json',
                width: 80,
                height: 80,
              ),
              const SizedBox(height: 16),
              const PviText(
                text: '¡Hubo un problema!',
                variant: TextVariant.headline2,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: PviText(
                  text: customMessage ??
                      'Lo sentimos, pero no puedes realizar esta acción en este momento.',
                  variant: TextVariant.caption,
                  textAlign: TextAlign.center,
                ),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: onRetry,
                  child: const PviText(
                    text: 'Intentar de nuevo',
                    variant: TextVariant.button1,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
