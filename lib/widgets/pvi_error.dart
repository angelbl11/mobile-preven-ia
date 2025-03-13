import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';

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
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            Lottie.asset(
              'assets/lotties/error.json',
              width: 80,
              height: 80,
            ),
            PviText(
              text: '¡Hubo un problema!',
              style: AppFonts.headline2,
            ),
            PviText(
              text: customMessage ??
                  'Lo sentimos, pero no puedes realizar esta acción en este momento.',
              style: AppFonts.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
