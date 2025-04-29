import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/core/providers/connection/connectivity_controller.dart';
import 'package:mobile_preven_ia_app/core/startup/app_startup_error.dart';
import 'package:mobile_preven_ia_app/core/startup/app_startup_loading.dart';
import 'package:mobile_preven_ia_app/core/startup/auth_wrapper.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_error.dart';

/// The widget that shows the network state of the app.
class AppStartupNetworkState extends ConsumerWidget {
  /// The widget key.
  const AppStartupNetworkState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// 1. eagerly initialize connectivityControllerProvider.
    final connectivityState = ref.watch(connectivityControllerProvider);

    /// 2. show the appropriate UI based on the connectivity state (loading, error, data)
    return connectivityState.when(
      /// Data is the result of the connectivity check (ConnectivityResult.none or ConnectivityResult.mobile or ConnectivityResult.wifi)
      data: (result) {
        if (result.contains(ConnectivityResult.none)) {
          return const PviError(
            isNetworkError: true,
            customMessage:
                'No tienes conexión a internet, por favor revisa tu conexión e intenta de nuevo.',
          );
        }

        /// If there is connectivity, load the main app with auth wrapper
        return const AuthWrapper();
      },
      // 3. loading state - show a loading widget
      loading: () => const AppStartupLoading(),
      // 4. error state - invalidate the connectivityControllerProvider
      error: (e, _) => AppStartupError(
        message: 'Connectivity error $e',
        onRetry: () => ref.invalidate(connectivityControllerProvider),
      ),
    );
  }
}
