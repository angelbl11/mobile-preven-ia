import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/app.dart';
import 'package:mobile_preven_ia_app/cmd/handlers/app_startup_error.dart';
import 'package:mobile_preven_ia_app/cmd/handlers/app_startup_loading.dart';
import 'package:mobile_preven_ia_app/cmd/handlers/controllers/app_startup_controller.dart';

class AppStartup extends ConsumerWidget {
  const AppStartup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStartupState = ref.watch(appStartupControllerProvider);
    return appStartupState.when(
      loading: () => const AppStartupLoading(),
      error: (e, _) => AppStartupError(
        message: e.toString(),
        onRetry: () => ref.invalidate(appStartupControllerProvider),
      ),
      data: (_) => const App(),
    );
  }
}
