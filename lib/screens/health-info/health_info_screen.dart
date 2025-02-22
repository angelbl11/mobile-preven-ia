import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:mobile_preven_ia_app/cmd/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/cmd/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_button.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text_input.dart';

class HealthInfoScreen extends StatelessWidget {
  const HealthInfoScreen({super.key});

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
                      text: 'Completa tu perfil', style: AppFonts.headline1),
                  PviText(
                      text: 'Ayúdanos a mejorar la precisión de tus resultados',
                      style: AppFonts.subtitle2),
                  const PviTextInput(
                    keyboardType: TextInputType.name,
                    label: 'Nombre completo',
                    prefixIcon: Icon(
                      Icons.person,
                      color: AppColors.primary,
                    ),
                  ),
                  const PviTextInput(
                    keyboardType: TextInputType.datetime,
                    label: 'Fecha de nacimiento (dd/mm/aaaa)',
                    prefixIcon: Icon(
                      Icons.calendar_today,
                      color: AppColors.primary,
                    ),
                  ),
                  const Row(
                    spacing: 8,
                    children: [
                      Expanded(
                        child: PviTextInput(
                          keyboardType: TextInputType.number,
                          label: 'Peso (kg)',
                          prefixIcon: Icon(
                            CommunityMaterialIcons.weight_kilogram,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: PviTextInput(
                          keyboardType: TextInputType.text,
                          label: 'Estatura (m)',
                          prefixIcon: Icon(
                            CommunityMaterialIcons.human_male_height,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const PviTextInput(
                    keyboardType: TextInputType.text,
                    label: 'Género (M/F)',
                    prefixIcon: Icon(
                      CommunityMaterialIcons.gender_male_female,
                      color: AppColors.primary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.gray4,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PviText(
                          text: 'Condiciones géneticas',
                          style: AppFonts.headline4,
                        ),
                        PviText(
                            text:
                                '¿Posees alguna condición génetica que afecte tus valores en sangre de los siguientes marcadores?',
                            style: AppFonts.body1),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(value: false, onChanged: (value) => null),
                            PviText(
                                text: 'LDL (colesterol malo)',
                                style: AppFonts.body1),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(value: false, onChanged: (value) => null),
                            PviText(
                                text: 'Hba1c (hemoglobina glucosilada)',
                                style: AppFonts.body1),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(value: false, onChanged: (value) => null),
                            PviText(
                                text: 'Triglicéridos', style: AppFonts.body1),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(value: false, onChanged: (value) => null),
                            PviText(text: 'Creatinina', style: AppFonts.body1),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.gray4,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      spacing: 8,
                      children: [
                        const Icon(CommunityMaterialIcons.information,
                            color: AppColors.primary),
                        Expanded(
                          child: PviText(
                              text:
                                  'Esta información nos ayuda a otorgarte resultados más precisos y personalizados en base a tus condiciones médicas',
                              style: AppFonts.body1),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: PviButton(
                        child: PviText(
                            text: 'Completar perfil',
                            style:
                                AppFonts.button1.copyWith(color: Colors.white)),
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, '/')),
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
