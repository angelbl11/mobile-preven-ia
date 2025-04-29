import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:mobile_preven_ia_app/core/resources/app_colors.dart';

class HealthFormStepper extends StatefulWidget {
  final int currentStep;
  final int totalSteps;
  final Function(int) onStepChanged;

  const HealthFormStepper({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    required this.onStepChanged,
  }) : super(key: key);

  @override
  State<HealthFormStepper> createState() => _HealthFormStepperState();
}

class _HealthFormStepperState extends State<HealthFormStepper> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 32),
      width: double.infinity,
      child: EasyStepper(
        activeStep: widget.currentStep,
        direction: Axis.horizontal,
        enableStepTapping: true,
        showStepBorder: false,
        showLoadingAnimation: false,
        stepRadius: 16,
        steps: List.generate(
          widget.totalSteps,
          (index) => EasyStep(
            customStep: CircleAvatar(
              radius: 16,
              backgroundColor: index <= widget.currentStep
                  ? AppColors.primary
                  : AppColors.gray4,
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: index <= widget.currentStep
                      ? Colors.white
                      : AppColors.gray5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        onStepReached: (index) => widget.onStepChanged(index),
      ),
    );
  }
}
