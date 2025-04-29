import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/core/classes/message_status.dart';
import 'package:mobile_preven_ia_app/core/domain/controllers/weight/weight_controller.dart';
import 'package:mobile_preven_ia_app/core/functions/show_toast.dart';
import 'package:mobile_preven_ia_app/core/functions/status_handler_function.dart';
import 'package:mobile_preven_ia_app/core/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_button.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_form_button.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text_input.dart';

class PviWeightUpdateModal extends ConsumerWidget {
  final double currentWeight;
  final VoidCallback? onWeightUpdated;
  final bool showSkipButton;

  const PviWeightUpdateModal({
    super.key,
    required this.currentWeight,
    this.onWeightUpdated,
    this.showSkipButton = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weightController =
        TextEditingController(text: currentWeight.toString());
    final formKey = GlobalKey<FormState>();

    return AlertDialog(
      backgroundColor: AppColors.background,
      title: const PviText(
        text: 'Actualizar peso',
        variant: TextVariant.headline2,
      ),
      content: SizedBox(
        width: 300,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const PviText(
                text: '¿Deseas actualizar tu peso actual?',
                variant: TextVariant.body1,
              ),
              const SizedBox(height: 16),
              PviTextInput(
                controller: weightController,
                keyboardType: TextInputType.number,
                label: 'Peso (kg)',
                prefixIcon: const Icon(
                  CommunityMaterialIcons.weight_kilogram,
                  color: AppColors.primary,
                  size: 18,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa un peso válido';
                  }
                  final weight = double.tryParse(value.replaceAll(',', '.'));
                  if (weight == null) {
                    return 'Ingresa un número válido';
                  }
                  if (weight < 30 || weight > 200) {
                    return 'El peso debe estar entre 30 y 200 kg';
                  }
                  if (weight == currentWeight) {
                    return 'El peso debe ser diferente al actual';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (showSkipButton)
          PviFormButton(
            buttonVariant: ButtonVariant.text,
            buttonColor: AppColors.primary,
            buttonText: 'Mantener peso actual',
            onSubmit: () {
              Navigator.of(context).pop();
              onWeightUpdated?.call();
            },
          ),
        PviFormButton(
          buttonVariant: ButtonVariant.primary,
          buttonText: 'Actualizar',
          onSubmit: () {
            if (formKey.currentState!.validate()) {
              final newWeight =
                  double.tryParse(weightController.text.replaceAll(',', '.'));
              if (newWeight != null) {
                StatusHandlerFunction.handleStatus(
                  context: context,
                  action: ref
                      .read(weightControllerProvider.notifier)
                      .updateWeight(newWeight),
                  onSuccessCallBack: () {
                    showToast(
                      status: MessageStatus.success,
                      context: context,
                      message: 'Peso actualizado correctamente',
                    );
                    Navigator.of(context).pop();
                    onWeightUpdated?.call();
                  },
                );
              }
            }
          },
        ),
      ],
    );
  }
}
