import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_preven_ia_app/core/classes/message_status.dart';
import 'package:mobile_preven_ia_app/core/domain/controllers/health-form/health_form_controller.dart';
import 'package:mobile_preven_ia_app/core/domain/controllers/weight/weight_controller.dart';
import 'package:mobile_preven_ia_app/core/domain/models/health_form_info.dart';
import 'package:mobile_preven_ia_app/core/functions/show_toast.dart';
import 'package:mobile_preven_ia_app/core/functions/status_handler_function.dart';
import 'package:mobile_preven_ia_app/core/providers/auth/auth0_controller.dart';
import 'package:mobile_preven_ia_app/core/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/core/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_error.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_loader.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text_button.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text_input.dart';
import 'package:mobile_preven_ia_app/screens/auth/auth_screen.dart';
import 'package:page_transition/page_transition.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  String _getUserInitials(String name) {
    if (name.isEmpty) return '';
    final parts = name.split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthForm = ref.watch(healthFormControllerProvider);
    final auth0State = ref.watch(auth0ControllerProvider);

    return healthForm.when(
      data: (healthFormInfo) {
        final userProfile = healthFormInfo;
        final userEmail = auth0State.credentials?.user.email ?? '';

        return Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            surfaceTintColor: AppColors.background,
            backgroundColor: AppColors.background,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.secondary,
                      child: Center(
                        child: Text(
                          _getUserInitials(userProfile.name ?? ''),
                          style:
                              AppFonts.headline3.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        PviText(
                          text: userProfile.name ?? '',
                          variant: TextVariant.headline3,
                        ),
                        PviText(
                          text: userEmail,
                          variant: TextVariant.subtitle2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const PviText(
                    text: 'Información personal',
                    variant: TextVariant.headline3,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.gray4,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const PviText(
                          text: 'Nombre completo',
                          variant: TextVariant.body1,
                        ),
                        PviText(
                          text: userProfile.name ?? '',
                          variant: TextVariant.body1,
                        ),
                        const PviText(
                          text: 'Fecha de nacimiento',
                          variant: TextVariant.body1,
                        ),
                        PviText(
                          text: DateFormat('dd/MM/yyyy').format(
                              userProfile.dateOfBirth ?? DateTime.now()),
                          variant: TextVariant.body1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const PviText(
                    text: 'Información de salud',
                    variant: TextVariant.headline3,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.gray4,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const PviText(
                          text: 'Peso (kg)',
                          variant: TextVariant.body1,
                        ),
                        Row(
                          children: [
                            PviText(
                              text:
                                  '${userProfile.personalInfo?.weight.toString()} kg',
                              variant: TextVariant.body1,
                            ),
                            IconButton(
                              icon: const Icon(
                                size: 20,
                                LucideIcons.pen,
                                color: AppColors.primary,
                              ),
                              onPressed: () {
                                final weightController = TextEditingController(
                                  text: userProfile.personalInfo?.weight
                                      .toString(),
                                );
                                final formKey = GlobalKey<FormState>();
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: AppColors.background,
                                      title: const PviText(
                                        text: 'Editar peso',
                                        variant: TextVariant.headline2,
                                      ),
                                      content: SizedBox(
                                        width: 300,
                                        child: Form(
                                          key: formKey,
                                          child: PviTextInput(
                                            controller: weightController,
                                            keyboardType: TextInputType.number,
                                            label: 'Peso (kg)',
                                            prefixIcon: const Icon(
                                              CommunityMaterialIcons
                                                  .weight_kilogram,
                                              color: AppColors.primary,
                                              size: 18,
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.trim().isEmpty) {
                                                return 'Ingresa un peso válido';
                                              }
                                              final weight = double.tryParse(
                                                  value.replaceAll(',', '.'));
                                              if (weight == null) {
                                                return 'Ingresa un número válido';
                                              }
                                              if (weight < 30 || weight > 200) {
                                                return 'El peso debe estar entre 30 y 200 kg';
                                              }
                                              if (weight ==
                                                  userProfile
                                                      .personalInfo?.weight) {
                                                return 'El peso debe ser diferente al actual';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        PviTextButton(
                                          onPressed: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              final newWeight = double.tryParse(
                                                  weightController.text
                                                      .replaceAll(',', '.'));
                                              if (newWeight != null) {
                                                StatusHandlerFunction
                                                    .handleStatus(
                                                  context: context,
                                                  action: ref
                                                      .read(
                                                          weightControllerProvider
                                                              .notifier)
                                                      .updateWeight(
                                                        newWeight,
                                                      ),
                                                  onSuccessCallBack: () {
                                                    ref.invalidate(
                                                        healthFormControllerProvider);
                                                    Navigator.of(context).pop();
                                                    showToast(
                                                      context: context,
                                                      message:
                                                          'Peso actualizado correctamente',
                                                      status:
                                                          MessageStatus.success,
                                                    );
                                                  },
                                                );
                                              }
                                            }
                                          },
                                          text: 'Aceptar',
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        const PviText(
                          text: 'Altura (m)',
                          variant: TextVariant.body1,
                        ),
                        PviText(
                          text:
                              '${(userProfile.personalInfo?.height ?? 0) / 100} m',
                          variant: TextVariant.body1,
                        ),
                        const PviText(
                          text: 'Preexistencias familiares',
                          variant: TextVariant.body1,
                        ),
                        Visibility(
                          visible: !(userProfile.familyHistory?.diabetes ==
                                  1) &&
                              !(userProfile.familyHistory?.hypertension == 1) &&
                              !(userProfile.familyHistory?.obesity == 1),
                          child: const PviText(
                            text: 'Ninguna',
                            variant: TextVariant.body1,
                          ),
                        ),
                        Visibility(
                          visible: userProfile.familyHistory?.diabetes == 1,
                          child: const PviText(
                            text: '- Diabetes',
                            variant: TextVariant.body1,
                          ),
                        ),
                        Visibility(
                          visible: userProfile.familyHistory?.hypertension == 1,
                          child: const PviText(
                            text: '- Hipertensión',
                            variant: TextVariant.body1,
                          ),
                        ),
                        Visibility(
                          visible: userProfile.familyHistory?.obesity == 1,
                          child: const PviText(
                            text: '- Obesidad',
                            variant: TextVariant.body1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const PviText(
                    text: 'Enfermedades monitoreadas',
                    variant: TextVariant.headline3,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.gray4,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const PviText(
                              text: 'Enfermedades que monitoreas',
                              variant: TextVariant.body1,
                            ),
                            IconButton(
                              icon: const Icon(
                                LucideIcons.settings,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    bool tempMonitorDiabetes =
                                        userProfile.monitoring?.diabetes ??
                                            false;
                                    bool tempMonitorHypertension =
                                        userProfile.monitoring?.hypertension ??
                                            false;
                                    bool tempMonitorObesity =
                                        userProfile.monitoring?.obesity ??
                                            false;

                                    return AlertDialog(
                                      backgroundColor: AppColors.background,
                                      title: const PviText(
                                        text: 'Editar parámetros monitoreados',
                                        variant: TextVariant.headline2,
                                      ),
                                      content: StatefulBuilder(
                                        builder: (BuildContext context,
                                            StateSetter setState) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CheckboxListTile(
                                                title: const PviText(
                                                  text: 'Diabetes',
                                                  variant: TextVariant.body1,
                                                ),
                                                value: tempMonitorDiabetes,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    tempMonitorDiabetes =
                                                        value ?? false;
                                                  });
                                                },
                                                activeColor: AppColors.primary,
                                              ),
                                              CheckboxListTile(
                                                title: const PviText(
                                                  text: 'Hipertensión',
                                                  variant: TextVariant.body1,
                                                ),
                                                value: tempMonitorHypertension,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    tempMonitorHypertension =
                                                        value ?? false;
                                                  });
                                                },
                                                activeColor: AppColors.primary,
                                              ),
                                              CheckboxListTile(
                                                title: const PviText(
                                                  text: 'Obesidad',
                                                  variant: TextVariant.body1,
                                                ),
                                                value: tempMonitorObesity,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    tempMonitorObesity =
                                                        value ?? false;
                                                  });
                                                },
                                                activeColor: AppColors.primary,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      actions: [
                                        PviTextButton(
                                          textStyle: AppFonts.button1
                                              .copyWith(color: AppColors.gray5),
                                          text: 'Cancelar',
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                        PviTextButton(
                                          text: 'Guardar',
                                          onPressed: () {
                                            StatusHandlerFunction.handleStatus(
                                              context: context,
                                              action: ref
                                                  .read(
                                                      healthFormControllerProvider
                                                          .notifier)
                                                  .updateHealthForm(
                                                    HealthFormInfo(
                                                      monitoring: Monitoring(
                                                        diabetes:
                                                            tempMonitorDiabetes,
                                                        hypertension:
                                                            tempMonitorHypertension,
                                                        obesity:
                                                            tempMonitorObesity,
                                                      ),
                                                      step: userProfile.step,
                                                      completed:
                                                          userProfile.completed,
                                                    ),
                                                  ),
                                              onSuccessCallBack: () {
                                                ref.invalidate(
                                                    healthFormControllerProvider);
                                                Navigator.pop(context);
                                                showToast(
                                                  context: context,
                                                  message:
                                                      'Enfermedades monitoreadas actualizadas correctamente',
                                                  status: MessageStatus.success,
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        Visibility(
                          visible: userProfile.monitoring?.diabetes ?? false,
                          child: const PviText(
                            text: '- Diabetes',
                            variant: TextVariant.body1,
                          ),
                        ),
                        Visibility(
                          visible:
                              userProfile.monitoring?.hypertension ?? false,
                          child: const PviText(
                            text: '- Hipertensión',
                            variant: TextVariant.body1,
                          ),
                        ),
                        Visibility(
                          visible: userProfile.monitoring?.obesity ?? false,
                          child: const PviText(
                            text: '- Obesidad',
                            variant: TextVariant.body1,
                          ),
                        ),
                        Visibility(
                          visible:
                              !(userProfile.monitoring?.diabetes ?? false) &&
                                  !(userProfile.monitoring?.hypertension ??
                                      false) &&
                                  !(userProfile.monitoring?.obesity ?? false),
                          child: const PviText(
                            text: 'No hay parámetros seleccionados',
                            variant: TextVariant.body1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  InkWell(
                    onTap: () async {
                      try {
                        await StatusHandlerFunction.handleStatus(
                          context: context,
                          action: ref
                              .read(auth0ControllerProvider.notifier)
                              .logout(),
                          onSuccessCallBack: () {
                            if (context.mounted) {
                              Navigator.of(context).pushAndRemoveUntil(
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  duration: const Duration(milliseconds: 300),
                                  child: const AuthScreen(),
                                ),
                                (route) => false,
                              );
                            }
                          },
                        );
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Error al cerrar sesión: ${e.toString()}'),
                              backgroundColor: AppColors.error,
                            ),
                          );
                        }
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.gray4,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        spacing: 8,
                        children: [
                          const Icon(
                            LucideIcons.logOut,
                            color: AppColors.error,
                            size: 20,
                          ),
                          const PviText(
                            text: 'Cerrar sesión',
                            variant: TextVariant.body2,
                            color: AppColors.error,
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.gray4,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Icon(
                              LucideIcons.chevronRight,
                              color: AppColors.gray5,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const PviLoader(),
      error: (error, _) =>
          PviError(customMessage: 'Error al cargar datos: $error'),
    );
  }
}
