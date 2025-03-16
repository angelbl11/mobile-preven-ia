import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/screens/legal-text/legal_text_screen.dart';
import 'package:mobile_preven_ia_app/screens/legal-text/text/privacy_policy.dart';
import 'package:mobile_preven_ia_app/screens/legal-text/text/terms_and_conditions.dart';

class LegalLinks extends StatelessWidget {
  const LegalLinks({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: AppFonts.body1,
        children: [
          const TextSpan(
            text: 'Al registrarte aceptas nuestros ',
          ),
          TextSpan(
            text: 'Términos y condiciones',
            style: AppFonts.button1
                .copyWith(fontSize: 14, color: AppColors.primary),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LegalTextScreen(
                      title: "Términos y Condiciones",
                      content: termsAndConditions,
                    ),
                  ),
                );
              },
          ),
          const TextSpan(
            text: ' y nuestra ',
          ),
          TextSpan(
            text: 'Política de privacidad',
            style: AppFonts.button1
                .copyWith(fontSize: 14, color: AppColors.primary),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LegalTextScreen(
                      title: "Política de Privacidad",
                      content: privacyPolicy,
                    ),
                  ),
                );
              },
          ),
        ],
      ),
    );
  }
}
