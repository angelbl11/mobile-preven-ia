import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/screens/health-info/health_info_screen.dart';
import 'package:mobile_preven_ia_app/screens/sign-in/sign_in_screen.dart';
import 'package:mobile_preven_ia_app/screens/sign-up/sign_up_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.background,
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (_) => const SignInScreen(),
          '/sign-up': (_) => const SignUpScreen(),
          '/health-info': (_) => const HealthInfoScreen(),
        },
      ),
    );
  }
}
