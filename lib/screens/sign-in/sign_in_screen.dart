import 'package:flutter/material.dart';
import 'package:mobile_preven_ia_app/cmd/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/cmd/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_button.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_password_input.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text_button.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text_input.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 22,
                children: [
                  PviText(
                      text: 'Bienvenido de nuevo', style: AppFonts.headline1),
                  PviText(
                      text: 'Inicia sesión para continuar',
                      style: AppFonts.subtitle2),
                  const PviTextInput(
                    keyboardType: TextInputType.phone,
                    label: 'Número de télefono',
                    prefixIcon: Icon(
                      Icons.phone,
                      color: AppColors.primary,
                    ),
                  ),
                  const PviPasswordInput(
                    prefixIcon: Icon(
                      Icons.lock,
                      color: AppColors.primary,
                    ),
                    label: 'Contraseña',
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: PviTextButton(
                        onPressed: () => '', text: '¿Olvidaste tu contraseña?'),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: PviButton(
                        child: PviText(
                            text: 'Continuar',
                            style:
                                AppFonts.button1.copyWith(color: Colors.white)),
                        onPressed: () => ''),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PviText(
                          text: '¿No tienes una cuenta?',
                          style: AppFonts.body1),
                      PviTextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/sign-up'),
                          text: 'Regístrate aquí',
                          textStyle: AppFonts.button1.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
