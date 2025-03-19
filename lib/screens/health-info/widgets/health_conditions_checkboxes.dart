import 'package:flutter/widgets.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/screens/health-info/widgets/health_checkbox.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';

class HealthConditionsCheckboxes extends StatelessWidget {
  final bool hasDiabetes;
  final bool hasHypertension;
  final bool hasObesity;
  final ValueChanged<bool> onDiabetesChanged;
  final ValueChanged<bool> onHypertensionChanged;
  final ValueChanged<bool> onObesityChanged;

  const HealthConditionsCheckboxes({
    super.key,
    required this.hasDiabetes,
    required this.hasHypertension,
    required this.hasObesity,
    required this.onDiabetesChanged,
    required this.onHypertensionChanged,
    required this.onObesityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.gray4,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PviText(
            text: 'Condiciones géneticas',
            style: AppFonts.headline4,
          ),
          PviText(
            text:
                '¿Alguien en tu familia tiene alguna de las siguientes condiciones?',
            style: AppFonts.body1,
          ),
          HealthCheckbox(
            label: 'Diabetes',
            value: hasDiabetes,
            onChanged: (value) => onDiabetesChanged(value ?? false),
          ),
          HealthCheckbox(
            label: 'Hipertensión',
            value: hasHypertension,
            onChanged: (value) => onHypertensionChanged(value ?? false),
          ),
          HealthCheckbox(
            label: 'Obesidad',
            value: hasObesity,
            onChanged: (value) => onObesityChanged(value ?? false),
          ),
        ],
      ),
    );
  }
}
