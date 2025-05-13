import 'package:flutter/widgets.dart';
import 'package:mobile_preven_ia_app/core/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text.dart';
import 'package:mobile_preven_ia_app/screens/health-info/widgets/health_checkbox.dart';

class HealthMonitoringCheckboxes extends StatelessWidget {
  final bool monitorDiabetes;
  final bool monitorHypertension;
  final bool monitorObesity;
  final Function(bool) onDiabetesChanged;
  final Function(bool) onHypertensionChanged;
  final Function(bool) onObesityChanged;
  const HealthMonitoringCheckboxes(
      {super.key,
      required this.monitorDiabetes,
      required this.monitorHypertension,
      required this.monitorObesity,
      required this.onDiabetesChanged,
      required this.onHypertensionChanged,
      required this.onObesityChanged});

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
          const PviText(
            text: 'Enfermedades monitorizadas',
            variant: TextVariant.headline4,
          ),
          const PviText(
            text: 'Elige las enfermedades que quieres monitorizar',
            variant: TextVariant.body1,
          ),
          HealthCheckbox(
            label: 'Diabetes',
            value: monitorDiabetes,
            onChanged: (value) => onDiabetesChanged(value ?? false),
          ),
          HealthCheckbox(
            label: 'Hipertensión',
            value: monitorHypertension,
            onChanged: (value) => onHypertensionChanged(value ?? false),
          ),
          HealthCheckbox(
            label: 'Obesidad',
            value: monitorObesity,
            onChanged: (value) => onObesityChanged(value ?? false),
          ),
        ],
      ),
    );
  }
}
