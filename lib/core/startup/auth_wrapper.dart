import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/app.dart';
import 'package:mobile_preven_ia_app/core/providers/auth/auth0_controller.dart';
import 'package:mobile_preven_ia_app/core/providers/auth/auth_handler.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_loader.dart';

/// Widget that wraps the app and handles authentication state
class AuthWrapper extends ConsumerStatefulWidget {
  /// Constructor
  const AuthWrapper({super.key});

  @override
  ConsumerState<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper> {
  bool _isCheckingAuth = true;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    if (!mounted) return;

    try {
      final auth0State = ref.read(auth0ControllerProvider);
      if (auth0State.isLoading) {
        await Future.delayed(const Duration(milliseconds: 100));
        _checkAuthState();
        return;
      }

      final authHandler = ref.read(authHandlerProvider);
      await authHandler.handleAuthState(context);
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingAuth = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingAuth) {
      return const PviLoader();
    }
    return const App();
  }
}
