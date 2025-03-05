import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/classes/environment_keys.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/screens/health-info/health_info_screen.dart';
import 'package:mobile_preven_ia_app/screens/manual-parameters/manual_parameters_screen.dart';
import 'package:mobile_preven_ia_app/screens/navigation-handler/navigation_handler_screen.dart';
import 'package:mobile_preven_ia_app/screens/sign-in/sign_in_screen.dart';
import 'package:mobile_preven_ia_app/screens/sign-up/sign_up_screen.dart';
import 'package:mobile_preven_ia_app/screens/upload-file/upload_file_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Gemini.init(apiKey: EnvironmentKeys.geminiApiKey);
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
          '/home': (_) => NavigationHandlerScreen(),
          '/upload-file': (_) => const UploadFileScreen(),
          '/manual-parameters': (_) => const ManualParametersScreen(),
        },
      ),
    );
  }
}
