import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/firebase/auth/providers/fire_auth_controller.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/screens/health-info/health_info_screen.dart';
import 'package:mobile_preven_ia_app/screens/navigation-handler/navigation_handler_screen.dart';
import 'package:mobile_preven_ia_app/screens/profile/profile_screen.dart';
import 'package:mobile_preven_ia_app/screens/sign-in/sign_in_screen.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_error.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_loader.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthStateHandler(),
      routes: {
        '/profile': (_) => const ProfileScreen(),
        '/login': (_) => const SignInScreen(),
      },
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
      ),
    );
  }
}

class AuthStateHandler extends ConsumerWidget {
  const AuthStateHandler({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(fireAuthControllerProvider);

    return authState.when(
      data: (session) {
        if (session == null) {
          return const SignInScreen();
        }

        if (session.needsProfileCompletion) {
          return const HealthInfoScreen();
        }

        return NavigationHandlerScreen();
      },
      loading: () => const Scaffold(
        body: Center(
          child: PviLoader(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: PviError(
            customMessage: error.toString(),
          ),
        ),
      ),
    );
  }
}
