import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mobile_preven_ia_app/core/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/screens/auth/widgets/sign_in_form.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_scaffold.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PviScaffold(
      screenContent: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Column(
            spacing: 32,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
                'assets/images/logo-isotype.svg',
                width: 120,
                height: 120,
              )
                  .animate()
                  .fadeIn(duration: 900.ms)
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1, 1),
                    duration: 900.ms,
                  )
                  .then()
                  .shimmer(
                    duration: 1200.ms,
                    color: AppColors.primary.withAlpha(51),
                  )
                  .then()
                  .moveY(
                    begin: 0,
                    end: -5,
                    duration: 2000.ms,
                    curve: Curves.easeInOut,
                  )
                  .then()
                  .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.05, 1.05),
                    duration: 1000.ms,
                    curve: Curves.easeInOut,
                  )
                  .then()
                  .scale(
                    begin: const Offset(1.05, 1.05),
                    end: const Offset(1, 1),
                    duration: 1000.ms,
                    curve: Curves.easeInOut,
                  ),
              const PviText(
                text: 'Bienvenido a PrevenIA',
                variant: TextVariant.headline1,
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(duration: 900.ms)
                  .slideY(
                    begin: 0.2,
                    end: 0,
                    duration: 900.ms,
                    curve: Curves.easeOut,
                  )
                  .then()
                  .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.02, 1.02),
                    duration: 1000.ms,
                    curve: Curves.easeInOut,
                  )
                  .then()
                  .scale(
                    begin: const Offset(1.02, 1.02),
                    end: const Offset(1, 1),
                    duration: 1000.ms,
                    curve: Curves.easeInOut,
                  ),
              const PviText(
                text:
                    'Analiza tus estudios médicos y obtén una interpretación clara y útil sobre tu salud.',
                variant: TextVariant.subtitle2,
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(duration: 900.ms, delay: 200.ms)
                  .slideY(
                    begin: 0.2,
                    end: 0,
                    duration: 900.ms,
                    curve: Curves.easeOut,
                  )
                  .then()
                  .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.02, 1.02),
                    duration: 1000.ms,
                    curve: Curves.easeInOut,
                  )
                  .then()
                  .scale(
                    begin: const Offset(1.02, 1.02),
                    end: const Offset(1, 1),
                    duration: 1000.ms,
                    curve: Curves.easeInOut,
                  ),
              // Beneficios
              const Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BenefitItem(
                      text:
                          'Conoce tu estado de salud subiendo análisis médicos'),
                  _BenefitItem(text: 'Lleva tus registros a todas partes'),
                  _BenefitItem(
                      text: 'Interpreta resultados y obtén información clave'),
                  _BenefitItem(text: 'Tus datos son privados y seguros'),
                ],
              )
                  .animate()
                  .fadeIn(duration: 900.ms, delay: 400.ms)
                  .slideY(
                    begin: 0.2,
                    end: 0,
                    duration: 900.ms,
                    curve: Curves.easeOut,
                  )
                  .then()
                  .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.02, 1.02),
                    duration: 1000.ms,
                    curve: Curves.easeInOut,
                  )
                  .then()
                  .scale(
                    begin: const Offset(1.02, 1.02),
                    end: const Offset(1, 1),
                    duration: 1000.ms,
                    curve: Curves.easeInOut,
                  ),
              // Formulario de inicio de sesión y registro
              const SignInForm()
                  .animate()
                  .fadeIn(duration: 900.ms, delay: 600.ms)
                  .slideY(
                    begin: 0.2,
                    end: 0,
                    duration: 900.ms,
                    curve: Curves.easeOut,
                  )
                  .then()
                  .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.02, 1.02),
                    duration: 1000.ms,
                    curve: Curves.easeInOut,
                  )
                  .then()
                  .scale(
                    begin: const Offset(1.02, 1.02),
                    end: const Offset(1, 1),
                    duration: 1000.ms,
                    curve: Curves.easeInOut,
                  ),
              // Links legales
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text.rich(
                  TextSpan(
                    text: 'Al registrarte aceptas nuestros ',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    children: [
                      TextSpan(
                        text: 'Términos y condiciones',
                        style: const TextStyle(
                          color: AppColors.primary,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // TODO: Navegar a Términos y condiciones
                          },
                      ),
                      const TextSpan(text: ' y '),
                      TextSpan(
                        text: 'Aviso de privacidad',
                        style: const TextStyle(
                          color: AppColors.primary,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // TODO: Navegar a Aviso de privacidad
                          },
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              )
                  .animate()
                  .fadeIn(duration: 900.ms, delay: 800.ms)
                  .slideY(
                    begin: 0.2,
                    end: 0,
                    duration: 900.ms,
                    curve: Curves.easeOut,
                  )
                  .then()
                  .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.02, 1.02),
                    duration: 1000.ms,
                    curve: Curves.easeInOut,
                  )
                  .then()
                  .scale(
                    begin: const Offset(1.02, 1.02),
                    end: const Offset(1, 1),
                    duration: 1000.ms,
                    curve: Curves.easeInOut,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final String text;
  const _BenefitItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Row(
        spacing: 8,
        children: [
          const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
          Expanded(
            child: PviText(
              text: text,
              variant: TextVariant.body1,
            ),
          ),
        ],
      ),
    );
  }
}
