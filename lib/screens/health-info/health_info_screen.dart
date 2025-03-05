import 'dart:async';
import 'dart:io';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_preven_ia_app/classes/message_status.dart';
import 'package:mobile_preven_ia_app/firebase/auth/providers/fire_auth_controller.dart';
import 'package:mobile_preven_ia_app/functions/show_toast.dart';
import 'package:mobile_preven_ia_app/functions/status_handler_function.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_button.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text_input.dart';

class HealthInfoScreen extends ConsumerStatefulWidget {
  const HealthInfoScreen({super.key});

  @override
  ConsumerState<HealthInfoScreen> createState() => _HealthInfoScreenState();
}

class _HealthInfoScreenState extends ConsumerState<HealthInfoScreen> {
  // Controllers for text inputs.
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _maternalLastNameController =
      TextEditingController();

  // Checkbox states for genetic conditions.
  bool _hasDiabetes = false;
  bool _hasHypertension = false;
  bool _hasObesity = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _fullNameController.dispose();
    _birthDateController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _genderController.dispose();
    _lastNameController.dispose();
    _maternalLastNameController.dispose();
    super.dispose();
  }

  /// Opens a native date picker (Cupertino on iOS, Material on Android)
  /// and sets the selected date on the birthdate field.
  Future<void> _selectBirthDate(BuildContext context) async {
    DateTime? selectedDate;
    if (Platform.isIOS) {
      selectedDate = await _showCupertinoDatePicker(context);
    } else {
      selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime(2000, 1, 1),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
      );
    }
    if (selectedDate != null) {
      // Format the date as dd/MM/yyyy.
      String formattedDate =
          "${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}";
      setState(() {
        _birthDateController.text = formattedDate;
      });
    }
  }

  Future<DateTime?> _showCupertinoDatePicker(BuildContext context) {
    DateTime selectedDate = DateTime(2000, 1, 1);
    return showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          top: false,
          child: Container(
            height: 260,
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: selectedDate,
                    minimumDate: DateTime(1900),
                    maximumDate: DateTime.now(),
                    onDateTimeChanged: (DateTime newDate) {
                      selectedDate = newDate;
                    },
                  ),
                ),
                CupertinoButton(
                  child: const Text('Confirmar'),
                  onPressed: () {
                    Navigator.of(context).pop(selectedDate);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  /// Submits the form after validating all fields.
  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final fullName = _fullNameController.text.trim();
      final lastName = _lastNameController.text.trim();
      final maternalLastName = _maternalLastNameController.text.trim();
      final birthDateStr = _birthDateController.text.trim();
      final weight = double.tryParse(_weightController.text) ?? 0.0;
      final height = double.tryParse(_heightController.text) ?? 0.0;
      final gender = _genderController.text.trim().toUpperCase();
      final hasDiabetes = _hasDiabetes;
      final hasHypertension = _hasHypertension;
      final hasObesity = _hasObesity;
      await StatusHandlerFunction.handleStatus(
        context: context,
        action: ref
            .read(fireAuthControllerProvider.notifier)
            .completeHealthForm(
              uid: ref.read(fireAuthControllerProvider).value?.user.uid ?? '',
              name: fullName,
              lastName: lastName,
              maternalLastName: maternalLastName,
              gender: gender,
              birthDate: birthDateStr,
              weight: weight,
              height: height,
              isGeneticRiskDiabetes: hasDiabetes,
              isGeneticRiskHypertension: hasHypertension,
              isGeneticRiskObesity: hasObesity,
            ),
        onSuccessCallBack: () {
          showToast(
              status: MessageStatus.success,
              context: context,
              message: 'Perfil completado exitosamente');
          Navigator.pushNamed(context, '/home');
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  spacing: 22,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PviText(
                      text: 'Completa tu perfil',
                      style: AppFonts.headline1,
                    ),
                    PviText(
                      text: 'Ayúdanos a mejorar la precisión de tus resultados',
                      style: AppFonts.subtitle2,
                    ),
                    // Full Name Input
                    PviTextInput(
                      controller: _fullNameController,
                      keyboardType: TextInputType.name,
                      label: 'Nombre',
                      prefixIcon: const Icon(
                        LucideIcons.user,
                        color: AppColors.primary,
                        size: 18,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El nombre es requerido';
                        }
                        return null;
                      },
                    ),
                    // Last Name Input
                    PviTextInput(
                      controller: _lastNameController,
                      keyboardType: TextInputType.name,
                      label: 'Apellido paterno',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El apellido paterno es requerido';
                        }
                        return null;
                      },
                    ),
                    PviTextInput(
                      controller: _maternalLastNameController,
                      keyboardType: TextInputType.name,
                      label: 'Apellido materno',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El apellido materno es requerido';
                        }
                        return null;
                      },
                    ),

                    PviTextInput(
                      controller: _birthDateController,
                      keyboardType: TextInputType.datetime,
                      label: 'Fecha de nacimiento (dd/mm/aaaa)',
                      prefixIcon: const Icon(
                        LucideIcons.calendar,
                        color: AppColors.primary,
                        size: 18,
                      ),
                      readOnly: true,
                      onTap: () => _selectBirthDate(context),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'La fecha de nacimiento es requerida';
                        }
                        try {
                          final parts = value.split('/');
                          if (parts.length != 3) {
                            return 'Formato de fecha inválido';
                          }
                          final day = int.parse(parts[0]);
                          final month = int.parse(parts[1]);
                          final year = int.parse(parts[2]);
                          final birthDate = DateTime(year, month, day);
                          final today = DateTime.now();
                          int age = today.year - birthDate.year;
                          if (today.month < birthDate.month ||
                              (today.month == birthDate.month &&
                                  today.day < birthDate.day)) {
                            age--;
                          }
                          if (age < 18 || age > 65) {
                            return 'Debes tener entre 18 y 65 años';
                          }
                        } catch (e) {
                          return 'Fecha de nacimiento inválida';
                        }
                        return null;
                      },
                    ),
                    Row(
                      spacing: 8,
                      children: [
                        Expanded(
                          child: PviTextInput(
                            controller: _weightController,
                            keyboardType: TextInputType.text,
                            label: 'Peso (kg)',
                            prefixIcon: const Icon(
                              CommunityMaterialIcons.weight_kilogram,
                              color: AppColors.primary,
                              size: 18,
                            ),
                            validator: (value) {
                              final weight = double.tryParse(value ?? '');
                              if (weight == null || weight <= 0) {
                                return 'Ingresa un peso válido';
                              }
                              return null;
                            },
                          ),
                        ),
                        Expanded(
                          child: PviTextInput(
                            controller: _heightController,
                            keyboardType: TextInputType.text,
                            label: 'Estatura (m)',
                            prefixIcon: const Icon(
                              CommunityMaterialIcons.human_male_height,
                              color: AppColors.primary,
                              size: 18,
                            ),
                            validator: (value) {
                              final height = double.tryParse(value ?? '');
                              if (height == null || height <= 0) {
                                return 'Ingresa una estatura válida';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    // Gender Input
                    PviTextInput(
                      controller: _genderController,
                      keyboardType: TextInputType.text,
                      label: 'Género (M/F)',
                      prefixIcon: const Icon(
                        CommunityMaterialIcons.gender_male_female,
                        color: AppColors.primary,
                        size: 18,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El género es requerido';
                        }
                        final gender = value.trim().toUpperCase();
                        if (gender != 'M' && gender != 'F') {
                          return 'El género debe ser "M" o "F"';
                        }
                        return null;
                      },
                    ),

                    Container(
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
                          Row(
                            children: [
                              Checkbox(
                                activeColor: AppColors.primary,
                                checkColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                value: _hasDiabetes,
                                onChanged: (value) {
                                  setState(() {
                                    _hasDiabetes = value ?? false;
                                  });
                                },
                              ),
                              PviText(
                                text: 'Diabetes',
                                style: AppFonts.body1,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                activeColor: AppColors.primary,
                                checkColor: Colors.white,
                                value: _hasHypertension,
                                onChanged: (value) {
                                  setState(() {
                                    _hasHypertension = value ?? false;
                                  });
                                },
                              ),
                              PviText(
                                text: 'Hipertensión',
                                style: AppFonts.body1,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                activeColor: AppColors.primary,
                                checkColor: Colors.white,
                                value: _hasObesity,
                                onChanged: (value) {
                                  setState(() {
                                    _hasObesity = value ?? false;
                                  });
                                },
                              ),
                              PviText(
                                text: 'Obesidad',
                                style: AppFonts.body1,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Information Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.gray4,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        spacing: 8,
                        children: [
                          const Icon(
                            LucideIcons.info,
                            color: AppColors.primary,
                          ),
                          Expanded(
                            child: PviText(
                              text:
                                  'Esta información nos ayuda a otorgarte resultados más precisos y personalizados en base a tus condiciones médicas',
                              style: AppFonts.body1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: PviButton(
                        onPressed: _submit,
                        child: PviText(
                          text: 'Completar perfil',
                          style: AppFonts.button1.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
