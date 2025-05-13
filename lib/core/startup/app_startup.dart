import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/core/startup/app_startup_error.dart';
import 'package:mobile_preven_ia_app/core/startup/app_startup_loading.dart';
import 'package:mobile_preven_ia_app/core/startup/app_startup_network_state.dart';
import 'package:mobile_preven_ia_app/core/startup/providers/app_startup_controller.dart';

/// The widget that initializes the app and shows the appropriate UI based on
/// the app startup state.
class AppStartupWidget extends ConsumerWidget {
  /// The widget key.
  const AppStartupWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. eagerly initialize appStartupProvider (and all the providers it
    // depends on)
    final appStartupState = ref.watch(appStartupControllerProvider);
    return appStartupState.when(
      // 2. loading state
      loading: () => const AppStartupLoading(),
      // 3. error state
      error: (e, _) => AppStartupError(
        message: e.toString(),
        // 4. invalidate the appStartupProvider
        onRetry: () => ref.invalidate(appStartupControllerProvider),
      ),
      // 5. success - now load the network state widget
      data: (_) => const AppStartupNetworkState(),
    );
  }
}
