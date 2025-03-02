import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';

class ClinicalResults extends StatelessWidget {
  const ClinicalResults({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.gray4,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        spacing: 16,
        children: [
          Row(
            spacing: 8,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      const Color.fromARGB(255, 74, 144, 226).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Icon(
                  LucideIcons.testTube,
                  color: AppColors.primary,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  PviText(text: 'Prueba de sangre', style: AppFonts.body2),
                  PviText(
                      text: '25-03-2025',
                      style: AppFonts.body1.copyWith(fontSize: 12)),
                ],
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: PviText(
                    text: 'Normal',
                    style: AppFonts.body1.copyWith(
                        fontSize: 12,
                        color: AppColors.success,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          Divider(
            color: AppColors.gray3.withOpacity(0.2),
            height: 1,
          ),
          Row(
            spacing: 12,
            children: [
              PviText(
                  text: 'HbA1c',
                  style: AppFonts.body2.copyWith(color: AppColors.gray5)),
              const Spacer(),
              PviText(
                  text: '10.5%',
                  style: AppFonts.body2.copyWith(color: AppColors.text3)),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(100),
                ),
              )
            ],
          ),
          Row(
            spacing: 12,
            children: [
              PviText(
                  text: 'LDL',
                  style: AppFonts.body2.copyWith(color: AppColors.gray5)),
              const Spacer(),
              PviText(
                  text: '100 mg/dL',
                  style: AppFonts.body2.copyWith(color: AppColors.text3)),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(100),
                ),
              )
            ],
          ),
          Row(
            spacing: 12,
            children: [
              PviText(
                  text: 'Triglicéridos',
                  style: AppFonts.body2.copyWith(color: AppColors.gray5)),
              const Spacer(),
              PviText(
                  text: '100 mg/dL',
                  style: AppFonts.body2.copyWith(color: AppColors.text3)),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(100),
                ),
              )
            ],
          ),
          Row(
            spacing: 12,
            children: [
              PviText(
                  text: 'Glucosa',
                  style: AppFonts.body2.copyWith(color: AppColors.gray5)),
              const Spacer(),
              PviText(
                  text: '100 mg/dL',
                  style: AppFonts.body2.copyWith(color: AppColors.text3)),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(100),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
