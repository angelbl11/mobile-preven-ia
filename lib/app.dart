// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/firebase/auth/providers/fire_auth_controller.dart';
import 'package:mobile_preven_ia_app/firebase/classes/user_step.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/screens/analysis-details/analysis_details_screen.dart';
import 'package:mobile_preven_ia_app/screens/forgot-password/forgot_password_screen.dart';
import 'package:mobile_preven_ia_app/screens/health-info/health_info_screen.dart';
import 'package:mobile_preven_ia_app/screens/navigation-handler/navigation_handler_screen.dart';
import 'package:mobile_preven_ia_app/screens/profile/profile_screen.dart';
import 'package:mobile_preven_ia_app/screens/sign-in/sign_in_screen.dart';
import 'package:mobile_preven_ia_app/screens/sign-up/sign_up_screen.dart';
import 'package:mobile_preven_ia_app/screens/verify-email/verify_email_screen.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_error.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'), // Español
      ],
      debugShowCheckedModeBanner: false,
      home: const AuthStateHandler(),
      routes: {
        '/profile': (_) => const ProfileScreen(),
        '/login': (_) => const SignInScreen(),
        '/verify': (_) => const VerifyEmailScreen(),
        '/forgot-password': (_) => const ForgotPasswordScreen(),
        '/sign-up': (_) => const SignUpScreen(),
        '/health-info': (_) => const HealthInfoScreen(),
        '/analysis-details': (_) => const AnalysisDetailsScreen(),
        '/sign-in': (_) => const SignInScreen(),
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
    final authController = ref.watch(fireAuthControllerProvider.notifier);
    final authState = ref.watch(fireAuthControllerProvider);

    if (authController.isLoggedIn) {
      if (authState is AsyncError) {
        return Scaffold(
          body: Center(
            child: PviError(
              customMessage: authState.error.toString(),
            ),
          ),
        );
      }
      if (authController.currentSession?.nextStep.step ==
          UserStepEnum.healthInfo) {
        return const SignInScreen();
      }
      return NavigationHandlerScreen();
    } else {
      return const SignInScreen();
    }
  }
}
