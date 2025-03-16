import 'package:flutter/material.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/screens/sign-up/widgets/sign_up_form.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_scaffold.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PviScaffold(
        screenContent: Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Image.asset(
            'assets/images/logo.png',
            width: 150,
            height: 150,
          ),
        ),
        PviText(text: 'Crea tu cuenta', style: AppFonts.headline1),
        PviText(
            text: 'Ingresa tus datos para registrarte',
            style: AppFonts.subtitle2),
        const SignUpForm(),
      ],
    ));
  }
}
