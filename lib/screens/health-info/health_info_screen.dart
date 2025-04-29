import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/core/domain/controllers/health-form/health_form_controller.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_error.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_loader.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_scaffold.dart';
import 'package:mobile_preven_ia_app/screens/health-info/widgets/health_form_stepper.dart';
import 'package:mobile_preven_ia_app/screens/health-info/widgets/health_form_personal_info.dart';
import 'package:mobile_preven_ia_app/screens/health-info/widgets/health_form_lifestyle_info.dart';
import 'package:mobile_preven_ia_app/screens/health-info/widgets/health_form_monitoring_info.dart';
import 'package:dio/dio.dart';

class HealthInfoScreen extends ConsumerWidget {
  const HealthInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthFormController = ref.watch(healthFormControllerProvider);

    return healthFormController.when(
      data: (healthForm) => PviScaffold(
        screenContent: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HealthFormStepper(
                currentStep: healthForm.step.toInt(),
                totalSteps: 3,
                onStepChanged: (step) {
                  ref
                      .read(healthFormControllerProvider.notifier)
                      .updateStep(step);
                },
              ),
              const SizedBox(height: 24),
              _buildStepContent(healthForm.step.toInt()),
            ],
          ),
        ),
      ),
      loading: () => const PviLoader(),
      error: (error, _) {
        if (error is DioException) {
          final response = error.response;
          final message = response?.data['message'];
          if (message?.contains('No se encontró el formulario de salud') ??
              false) {
            return PviScaffold(
              screenContent: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 32,
                children: [
                  HealthFormStepper(
                    currentStep: 0,
                    totalSteps: 3,
                    onStepChanged: (step) {
                      ref
                          .read(healthFormControllerProvider.notifier)
                          .updateStep(step);
                    },
                  ),
                  const HealthFormPersonalInfo(),
                ],
              ),
            );
          }
        }
        return const PviError();
      },
    );
  }

  Widget _buildStepContent(int step) {
    switch (step) {
      case 0:
        return const HealthFormPersonalInfo();
      case 1:
        return const HealthFormLifestyleInfo();
      case 2:
        return const HealthFormMonitoringInfo();
      default:
        return const HealthFormPersonalInfo();
    }
  }
}
