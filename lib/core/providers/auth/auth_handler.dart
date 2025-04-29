import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/core/domain/controllers/health-form/health_form_controller.dart';
import 'package:mobile_preven_ia_app/core/providers/auth/auth0_controller.dart';
import 'package:mobile_preven_ia_app/core/routes/app_routes.dart';
import 'package:mobile_preven_ia_app/screens/health-info/health_info_screen.dart';
import 'package:mobile_preven_ia_app/screens/navigation-handler/navigation_handler_screen.dart';
import 'package:page_transition/page_transition.dart';

/// Provider that handles authentication state and navigation
final authHandlerProvider = Provider<AuthHandler>((ref) {
  return AuthHandler(ref);
});

/// Class that handles authentication state and navigation
class AuthHandler {
  final Ref _ref;

  AuthHandler(this._ref);

  /// Check if user is authenticated and handle navigation accordingly
  Future<void> handleAuthState(BuildContext context) async {
    final isAuthenticated =
        _ref.read(auth0ControllerProvider.notifier).isAuthenticated;

    if (!isAuthenticated) {
      // If not authenticated, navigate to auth screen
      Navigator.of(context).pushReplacementNamed(AppRoutes.auth);
      return;
    }

    // If authenticated, check health form status
    try {
      final healthFormState =
          await _ref.read(healthFormControllerProvider.future);
      final completed = healthFormState.completed;
      final step = healthFormState.step.toInt();

      if (!context.mounted) return;

      if (completed || step == 3) {
        // If health form is completed or on last step, go to home
        Navigator.of(context).pushReplacement(
          PageTransition(
            type: PageTransitionType.fade,
            duration: const Duration(milliseconds: 300),
            child: NavigationHandlerScreen(),
          ),
        );
      } else {
        // If health form is not completed, go to health info screen
        Navigator.of(context).pushReplacement(
          PageTransition(
            type: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 300),
            child: const HealthInfoScreen(),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;

      if (e.toString().contains('No se encontró el formulario de salud')) {
        // If health form not found, go to health info screen
        Navigator.of(context).pushReplacement(
          PageTransition(
            type: PageTransitionType.fade,
            duration: const Duration(milliseconds: 300),
            child: const HealthInfoScreen(),
          ),
        );
      } else {
        // If other error, go to auth screen
        Navigator.of(context).pushReplacementNamed(AppRoutes.auth);
      }
    }
  }
}
