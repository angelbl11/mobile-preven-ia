// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:mobile_preven_ia_app/cmd/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/screens/health-info/health_info_screen.dart';
import 'package:mobile_preven_ia_app/screens/sign-in/sign_in_screen.dart';
import 'package:mobile_preven_ia_app/screens/sign-up/sign_up_screen.dart';

/// The main entry point for the application.
class App extends StatelessWidget {
  /// Creates the application.
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (_) => const SignInScreen(),
        '/sign-up': (_) => const SignUpScreen(),
        '/health-info': (_) => const HealthInfoScreen(),
      },
    );
  }
}
