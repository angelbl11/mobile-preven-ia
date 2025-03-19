import 'package:flutter/widgets.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/screens/health-info/widgets/health_checkbox.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';

class HealthMonitoringCheckboxes extends StatelessWidget {
  final bool monitorLDL;
  final bool monitorGlucose;
  final bool monitorWeight;
  final Function(bool) onLDLChanged;
  final Function(bool) onGlucoseChanged;
  final Function(bool) onWeightChanged;
  const HealthMonitoringCheckboxes(
      {super.key,
      required this.monitorLDL,
      required this.monitorGlucose,
      required this.monitorWeight,
      required this.onLDLChanged,
      required this.onGlucoseChanged,
      required this.onWeightChanged});

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
            text: 'Parámetros de salud',
            style: AppFonts.headline4,
          ),
          PviText(
            text: 'Elige los parámetros de salud más relevantes para ti',
            style: AppFonts.body1,
          ),
          HealthCheckbox(
            label: 'LDL (Colesterol malo)',
            value: monitorLDL,
            onChanged: (value) => onLDLChanged(value ?? false),
          ),
          HealthCheckbox(
            label: 'Glucosa',
            value: monitorGlucose,
            onChanged: (value) => onGlucoseChanged(value ?? false),
          ),
          HealthCheckbox(
            label: 'Peso (kg)',
            value: monitorWeight,
            onChanged: (value) => onWeightChanged(value ?? false),
          ),
        ],
      ),
    );
  }
}
