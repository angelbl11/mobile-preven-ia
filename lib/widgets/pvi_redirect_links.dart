import 'package:flutter/material.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/screens/sign-in/sign_in_screen.dart';
import 'package:mobile_preven_ia_app/screens/sign-up/sign_up_screen.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text_button.dart';

class PviRedirectLinks extends StatelessWidget {
  const PviRedirectLinks({
    super.key,
    required this.isFromSignIn,
  });

  final bool isFromSignIn;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PviText(
          text: isFromSignIn
              ? '¿No tienes una cuenta?'
              : '¿Ya tienes una cuenta?',
          style: AppFonts.body1,
        ),
        PviTextButton(
          onPressed: () {
            if (isFromSignIn) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignUpScreen(),
                ),
              );
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignInScreen(),
                ),
                (route) => false,
              );
            }
          },
          text: isFromSignIn ? 'Regístrate' : 'Inicia sesión',
          textStyle: AppFonts.button1.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
