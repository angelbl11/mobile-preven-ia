import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/core/domain/controllers/health-form/health_form_controller.dart';
import 'package:mobile_preven_ia_app/core/domain/models/health_form_info.dart';
import 'package:mobile_preven_ia_app/core/functions/status_handler_function.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_button.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_form_button.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_info_message.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text.dart';
import 'package:mobile_preven_ia_app/screens/health-info/health_info_screen.dart';
import 'package:mobile_preven_ia_app/screens/health-info/widgets/health_conditions_checkboxes.dart';
import 'package:mobile_preven_ia_app/screens/health-info/widgets/health_monitoring_checkboxes.dart';
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
  // Family history state
  bool _hasFamilyDiabetes = false;
  bool _hasFamilyObesity = false;
  bool _hasFamilyHypertension = false;

  // Monitoring preferences state
  bool _monitorDiabetes = false;
  bool _monitorObesity = false;
  bool _monitorHypertension = false;

  bool get _isFormValid => true; // All fields are optional

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  void _loadExistingData() {
    final healthForm = ref.read(healthFormControllerProvider).value;
    if (healthForm != null) {
      setState(() {
        // Load family history data
        _hasFamilyDiabetes = healthForm.familyHistory?.diabetes == 1;
        _hasFamilyHypertension = healthForm.familyHistory?.hypertension == 1;
        _hasFamilyObesity = healthForm.familyHistory?.obesity == 1;

        // Load monitoring preferences
        _monitorDiabetes = healthForm.monitoring?.diabetes ?? false;
        _monitorHypertension = healthForm.monitoring?.hypertension ?? false;
        _monitorObesity = healthForm.monitoring?.obesity ?? false;
      });
    }
  }

  void _updateFamilyHistory({
    bool? diabetes,
    bool? hypertension,
    bool? obesity,
  }) {
    setState(() {
      if (diabetes != null) _hasFamilyDiabetes = diabetes;
      if (hypertension != null) _hasFamilyHypertension = hypertension;
      if (obesity != null) _hasFamilyObesity = obesity;
    });
  }

  void _updateMonitoringPreferences({
    bool? diabetes,
    bool? hypertension,
    bool? obesity,
  }) {
    setState(() {
      if (diabetes != null) _monitorDiabetes = diabetes;
      if (hypertension != null) _monitorHypertension = hypertension;
      if (obesity != null) _monitorObesity = obesity;
    });
  }

  void _handleSubmit() {
    final currentState = ref.read(healthFormControllerProvider).value;
    if (currentState == null) return;

    StatusHandlerFunction.handleStatus(
      context: context,
      action: ref.read(healthFormControllerProvider.notifier).updateHealthForm(
            HealthFormInfo(
              name: currentState.name,
              dateOfBirth: currentState.dateOfBirth,
              personalInfo: currentState.personalInfo,
              lifestyle: currentState.lifestyle,
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
  }

  void _handleBack() {
    ref.read(healthFormControllerProvider.notifier).updateStep(1);
    ref.invalidate(healthFormControllerProvider);
    Navigator.of(context).push(
      PageTransition(
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 300),
        child: const HealthInfoScreen(),
      ),
    );
  }

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
          onDiabetesChanged: (value) => _updateFamilyHistory(diabetes: value),
          onHypertensionChanged: (value) =>
              _updateFamilyHistory(hypertension: value),
          onObesityChanged: (value) => _updateFamilyHistory(obesity: value),
        ),
        const SizedBox(height: 24),

        // Monitoring preferences section
        HealthMonitoringCheckboxes(
          monitorDiabetes: _monitorDiabetes,
          monitorHypertension: _monitorHypertension,
          monitorObesity: _monitorObesity,
          onDiabetesChanged: (value) =>
              _updateMonitoringPreferences(diabetes: value),
          onHypertensionChanged: (value) =>
              _updateMonitoringPreferences(hypertension: value),
          onObesityChanged: (value) =>
              _updateMonitoringPreferences(obesity: value),
        ),
        const SizedBox(height: 24),

        const PviInfoMessage(
          message:
              'Esta información nos ayuda a proporcionarte un seguimiento personalizado de tu salud',
        ),

        const SizedBox(height: 24),

        PviFormButton(
          buttonText: 'Guardar',
          onSubmit: _isFormValid ? _handleSubmit : null,
        ),
        const SizedBox(height: 24),
        PviFormButton(
          buttonText: 'Volver',
          buttonVariant: ButtonVariant.secondary,
          onSubmit: _handleBack,
        ),
      ],
    );
  }
}
