import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:mobile_preven_ia_app/cmd/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/cmd/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_button.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_password_input.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text_button.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text_input.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
                  PviText(text: 'Crea tu cuenta', style: AppFonts.headline1),
                  PviText(
                      text: 'Ingresa tus datos para registrarte',
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
                  const PviPasswordInput(
                    prefixIcon: Icon(
                      CommunityMaterialIcons.lock_check,
                      color: AppColors.primary,
                    ),
                    label: 'Confirmar contraseña',
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PviText(
                              text: 'Al registrarte aceptas nuestros',
                              style: AppFonts.body1),
                          PviTextButton(
                              onPressed: () => '',
                              text: 'Términos y condiciones',
                              textStyle:
                                  AppFonts.button1.copyWith(fontSize: 14)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PviText(text: 'y nuestra', style: AppFonts.body1),
                          PviTextButton(
                              onPressed: () => '',
                              text: 'Política de privacidad',
                              textStyle:
                                  AppFonts.button1.copyWith(fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: PviButton(
                        child: PviText(
                            text: 'Crear cuenta',
                            style:
                                AppFonts.button1.copyWith(color: Colors.white)),
                        onPressed: () =>
                            Navigator.pushNamed(context, '/health-info')),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PviText(
                          text: '¿Ya tienes una cuenta?',
                          style: AppFonts.body1),
                      PviTextButton(
                          onPressed: () =>
                              Navigator.pushReplacementNamed(context, '/'),
                          text: 'Inicia sesión',
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
