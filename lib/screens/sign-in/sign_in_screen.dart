import 'package:flutter/material.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/screens/sign-in/widgets/sign_in_form.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_scaffold.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PviScaffold(
        screenContent: Column(
      spacing: 22,
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
        PviText(
          text: 'Bienvenido de nuevo',
          style: AppFonts.headline1,
        ),
        PviText(
          text: 'Inicia sesión para continuar',
          style: AppFonts.subtitle2,
        ),
        const SignInForm(),
      ],
    ));
  }
}
