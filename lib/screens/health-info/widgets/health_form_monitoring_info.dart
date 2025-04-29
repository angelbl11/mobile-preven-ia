import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/core/domain/controllers/health-form/health_form_controller.dart';
import 'package:mobile_preven_ia_app/core/domain/models/health_form_info.dart';
import 'package:mobile_preven_ia_app/core/functions/status_handler_function.dart';
import 'package:mobile_preven_ia_app/core/routes/app_routes.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_button.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_form_button.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_info_message.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text.dart';
import 'package:mobile_preven_ia_app/screens/health-info/health_info_screen.dart';
import 'package:mobile_preven_ia_app/screens/health-info/widgets/health_conditions_checkboxes.dart';
import 'package:mobile_preven_ia_app/screens/health-info/widgets/health_monitoring_checkboxes.dart';
import 'package:mobile_preven_ia_app/screens/home/home_screen.dart';
import 'package:mobile_preven_ia_app/screens/navigation-handler/navigation_handler_screen.dart';
import 'package:page_transition/page_transition.dart';

class HealthFormMonitoringInfo extends ConsumerStatefulWidget {
  const HealthFormMonitoringInfo({super.key});

  @override
  ConsumerState<HealthFormMonitoringInfo> createState() =>
      _HealthFormMonitoringInfoState();
}

class _HealthFormMonitoringInfoState
    extends ConsumerState<HealthFormMonitoringInfo> {
  // Family history
  bool _hasFamilyDiabetes = false;
  bool _hasFamilyObesity = false;
  bool _hasFamilyHypertension = false;

  // Monitoring preferences
  bool _monitorDiabetes = false;
  bool _monitorObesity = false;
  bool _monitorHypertension = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PviText(
          text: 'Información de monitoreo e historial familiar',
          variant: TextVariant.headline2,
        ),
        const PviText(
          text:
              'Por favor, ingresa tus preferencias de monitoreo y tu historial familiar para que podamos proporcionarte un seguimiento personalizado de tu salud',
          variant: TextVariant.body1,
        ),
        const SizedBox(height: 24),
        // Family history section
        HealthConditionsCheckboxes(
          hasDiabetes: _hasFamilyDiabetes,
          hasHypertension: _hasFamilyHypertension,
          hasObesity: _hasFamilyObesity,
          onDiabetesChanged: (value) {
            setState(() {
              _hasFamilyDiabetes = value;
            });
          },
          onHypertensionChanged: (value) {
            setState(() {
              _hasFamilyHypertension = value;
            });
          },
          onObesityChanged: (value) {
            setState(() {
              _hasFamilyObesity = value;
            });
          },
        ),
        const SizedBox(height: 24),

        // Monitoring preferences section
        HealthMonitoringCheckboxes(
          monitorDiabetes: _monitorDiabetes,
          monitorHypertension: _monitorHypertension,
          monitorObesity: _monitorObesity,
          onDiabetesChanged: (value) {
            setState(() {
              _monitorDiabetes = value;
            });
          },
          onHypertensionChanged: (value) {
            setState(() {
              _monitorHypertension = value;
            });
          },
          onObesityChanged: (value) {
            setState(() {
              _monitorObesity = value;
            });
          },
        ),
        const SizedBox(height: 24),

        const PviInfoMessage(
          message:
              'Esta información nos ayuda a proporcionarte un seguimiento personalizado de tu salud',
        ),

        const SizedBox(height: 24),

        PviFormButton(
            buttonText: 'Guardar',
            onSubmit: () {
              StatusHandlerFunction.handleStatus(
                context: context,
                action: ref
                    .read(healthFormControllerProvider.notifier)
                    .updateHealthForm(
                      HealthFormInfo(
                        familyHistory: FamilyHistory(
                          diabetes: _hasFamilyDiabetes ? 1 : 0,
                          hypertension: _hasFamilyHypertension ? 1 : 0,
                          obesity: _hasFamilyObesity ? 1 : 0,
                        ),
                        monitoring: Monitoring(
                          diabetes: _monitorDiabetes,
                          hypertension: _monitorHypertension,
                          obesity: _monitorObesity,
                        ),
                        step: 3,
                        completed: true,
                      ),
                    ),
                onSuccessCallBack: () {
                  ref.read(healthFormControllerProvider.notifier).updateStep(3);
                  ref.invalidate(healthFormControllerProvider);
                  Navigator.of(context).push(
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      duration: const Duration(milliseconds: 300),
                      child: NavigationHandlerScreen(),
                    ),
                  );
                },
              );
            }),
        const SizedBox(height: 24),
        PviFormButton(
          buttonText: 'Volver',
          buttonVariant: ButtonVariant.secondary,
          onSubmit: () {
            ref.read(healthFormControllerProvider.notifier).updateStep(1);
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
    );
  }
}
