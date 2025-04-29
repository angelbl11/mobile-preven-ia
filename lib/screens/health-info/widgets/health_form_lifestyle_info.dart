import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/core/domain/controllers/health-form/health_form_controller.dart';
import 'package:mobile_preven_ia_app/core/domain/models/health_form_info.dart';
import 'package:mobile_preven_ia_app/core/functions/status_handler_function.dart';
import 'package:mobile_preven_ia_app/core/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_button.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_form_button.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_info_message.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text.dart';
import 'package:mobile_preven_ia_app/screens/health-info/health_info_screen.dart';
import 'package:mobile_preven_ia_app/screens/health-info/widgets/health_checkbox.dart';
import 'package:page_transition/page_transition.dart';

class HealthFormLifestyleInfo extends ConsumerStatefulWidget {
  const HealthFormLifestyleInfo({super.key});

  @override
  ConsumerState<HealthFormLifestyleInfo> createState() =>
      _HealthFormLifestyleInfoState();
}

class _HealthFormLifestyleInfoState
    extends ConsumerState<HealthFormLifestyleInfo> {
  // Physical activity level
  double _physicalActivityLevel = 0.0;
  final List<String> _activityLevels = [
    'none',
    'light',
    'moderate',
    'frequent',
  ];
  final List<String> _activityLevelsDisplay = [
    'Sedentario',
    'Leve',
    'Moderado',
    'Activo',
  ];

  // Smoking status
  bool _isSmoker = false;
  int _cigarettesPerDay = 0;

  // Alcohol consumption
  double _alcoholConsumption = 0.0;
  final List<String> _alcoholLevels = ['none', 'light', 'moderate', 'heavy'];
  final List<String> _alcoholLevelsDisplay = [
    'Nada',
    'Leve',
    'Moderado',
    'Alto'
  ];

  bool get _isFormValid => true; // All fields are optional

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          spacing: 18,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const PviText(
              text: 'Información de estilo de vida',
              variant: TextVariant.headline2,
            ),
            const PviText(
              text: 'Por favor, ingresa tus datos de estilo de vida',
              variant: TextVariant.body1,
            ),
            const PviText(
              text: 'Nivel de actividad física',
              variant: TextVariant.body1,
            ),
            Slider(
              value: _physicalActivityLevel,
              min: 0,
              max: 3,
              divisions: 3,
              label: _activityLevelsDisplay[_physicalActivityLevel.toInt()],
              activeColor: AppColors.primary,
              inactiveColor: AppColors.disabled,
              thumbColor: AppColors.primary,
              onChanged: (value) {
                setState(() {
                  _physicalActivityLevel = value;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                    _activityLevelsDisplay.map((level) => Text(level)).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Smoking status
            HealthCheckbox(
              label: '¿Eres fumador?',
              value: _isSmoker,
              onChanged: (value) {
                setState(() {
                  _isSmoker = value ?? false;
                  if (!_isSmoker) _cigarettesPerDay = 0;
                });
              },
            ),
            if (_isSmoker) ...[
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Cigarrillos al día',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _cigarettesPerDay = int.tryParse(value) ?? 0;
                  });
                },
              ),
            ],
            const SizedBox(height: 24),

            // Alcohol consumption
            const PviText(
              text: 'Consumo de alcohol',
              variant: TextVariant.body1,
            ),
            const SizedBox(height: 8),
            Slider(
              value: _alcoholConsumption,
              min: 0,
              max: 3,
              divisions: 3,
              label: _alcoholLevelsDisplay[_alcoholConsumption.toInt()],
              activeColor: AppColors.primary,
              inactiveColor: AppColors.disabled,
              thumbColor: AppColors.primary,
              onChanged: (value) {
                setState(() {
                  _alcoholConsumption = value;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                    _alcoholLevelsDisplay.map((level) => Text(level)).toList(),
              ),
            ),
            const SizedBox(height: 24),

            const PviInfoMessage(
              message:
                  'Esta información nos ayuda a evaluar mejor tu estilo de vida y proporcionar recomendaciones más precisas',
            ),
            const SizedBox(height: 24),

            PviFormButton(
              buttonText: 'Guardar',
              onSubmit: _isFormValid
                  ? () {
                      final lifestyle = Lifestyle(
                        physicalActivity:
                            _activityLevels[_physicalActivityLevel.toInt()],
                        smoker: _cigarettesPerDay,
                        alcoholConsumption:
                            _alcoholLevels[_alcoholConsumption.toInt()],
                      );

                      StatusHandlerFunction.handleStatus(
                        context: context,
                        action: ref
                            .read(healthFormControllerProvider.notifier)
                            .updateHealthForm(
                              HealthFormInfo(
                                lifestyle: lifestyle,
                                step: 2,
                                completed: false,
                              ),
                            ),
                        onSuccessCallBack: () {
                          ref
                              .read(healthFormControllerProvider.notifier)
                              .updateStep(2);
                          ref.invalidate(healthFormControllerProvider);
                          Navigator.of(context).push(
                            PageTransition(
                              type: PageTransitionType.fade,
                              duration: const Duration(milliseconds: 300),
                              child: const HealthInfoScreen(),
                            ),
                          );
                        },
                      );
                    }
                  : null,
            ),
            PviFormButton(
              buttonText: 'Volver',
              buttonVariant: ButtonVariant.secondary,
              onSubmit: () {
                ref.read(healthFormControllerProvider.notifier).updateStep(0);
                ref.invalidate(healthFormControllerProvider);
                Navigator.of(context).push(
                  PageTransition(
                    type: PageTransitionType.fade,
                    duration: const Duration(milliseconds: 300),
                    child: const HealthInfoScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
