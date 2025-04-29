import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_preven_ia_app/core/domain/controllers/health-form/health_form_controller.dart';
import 'package:mobile_preven_ia_app/core/domain/models/health_form_info.dart';
import 'package:mobile_preven_ia_app/core/functions/show_date_picker.dart';
import 'package:mobile_preven_ia_app/core/functions/status_handler_function.dart';
import 'package:mobile_preven_ia_app/core/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/core/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/core/utils/date_and_calculations_utils.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_form_button.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text_input.dart';
import 'package:mobile_preven_ia_app/screens/health-info/health_info_screen.dart';
import 'package:mobile_preven_ia_app/screens/health-info/models/health_form_field.dart';
import 'package:page_transition/page_transition.dart';

class HealthFormPersonalInfo extends ConsumerStatefulWidget {
  const HealthFormPersonalInfo({super.key});

  @override
  ConsumerState<HealthFormPersonalInfo> createState() =>
      _HealthFormPersonalInfoState();
}

class _HealthFormPersonalInfoState
    extends ConsumerState<HealthFormPersonalInfo> {
  final List<bool> _selectedGender = [false, false];
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;

  // Controllers
  final _fullNameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  late final Map<String, HealthFormField> _formFields;

  @override
  void initState() {
    super.initState();
    _initializeFormFields();
  }

  void _initializeFormFields() {
    _formFields = {
      'fullName': HealthFormField(
        label: 'Nombre completo',
        controller: _fullNameController,
        keyboardType: TextInputType.name,
        prefixIcon: LucideIcons.user,
        validator: _validateRequired,
        onChanged: validateForm,
      ),
      'birthDate': HealthFormField(
        label: 'Fecha de nacimiento',
        controller: _birthDateController,
        keyboardType: TextInputType.datetime,
        prefixIcon: LucideIcons.calendar,
        readOnly: true,
        onTap: () => showPlatformDatePicker(context, _birthDateController),
        validator: _validateBirthDate,
        onChanged: validateForm,
      ),
      'weight': HealthFormField(
        label: 'Peso (kg)',
        controller: _weightController,
        keyboardType: TextInputType.text,
        prefixIcon: CommunityMaterialIcons.weight_kilogram,
        validator: _validateWeight,
        onChanged: validateForm,
      ),
      'height': HealthFormField(
        label: 'Estatura (m)',
        controller: _heightController,
        keyboardType: TextInputType.text,
        prefixIcon: CommunityMaterialIcons.human_male_height,
        validator: _validateHeight,
        onChanged: validateForm,
      ),
    };
  }

  void validateForm() {
    if (!mounted) return;
    setState(() {
      final formState = _formKey.currentState;
      if (formState == null) {
        _isFormValid = false;
        return;
      }
      _isFormValid = formState.validate() && _selectedGender.contains(true);
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _birthDateController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es requerido';
    }
    return null;
  }

  String? _validateBirthDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La fecha de nacimiento es requerida';
    }
    try {
      final parts = value.split('-');
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
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      if (age < 18 || age > 65) {
        return 'Debes tener entre 18 y 65 años';
      }
    } catch (e) {
      return 'Fecha de nacimiento inválida';
    }
    return null;
  }

  String? _validateWeight(String? value) {
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
    return null;
  }

  String? _validateHeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingresa una estatura válida';
    }
    final height = double.tryParse(value.replaceAll(',', '.'));
    if (height == null) {
      return 'Ingresa un número válido';
    }
    if (height < 1.0 || height > 2.2) {
      return 'La estatura debe estar entre 1.0 y 2.2 metros';
    }
    return null;
  }

  /// Maneja la selección del género cuando el usuario hace clic en uno de los botones
  /// [index] 0 para masculino, 1 para femenino
  void _onGenderSelected(int index) {
    setState(() {
      // Actualizar el array de selección
      for (int i = 0; i < _selectedGender.length; i++) {
        _selectedGender[i] = i == index;
      }
      // Validar el formulario después de cambiar el género
      validateForm();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
          spacing: 32,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PviText(
              text: 'Información personal',
              variant: TextVariant.headline2,
            ),
            const PviText(
              text: 'Por favor, ingresa tus datos personales',
              variant: TextVariant.body1,
            ),
            ..._formFields.values.map((field) => PviTextInput(
                  controller: field.controller,
                  keyboardType: field.keyboardType,
                  label: field.label,
                  prefixIcon: field.prefixIcon != null
                      ? Icon(
                          field.prefixIcon,
                          color: AppColors.primary,
                          size: 18,
                        )
                      : null,
                  readOnly: field.readOnly,
                  onTap: field.onTap,
                  validator: field.validator,
                  onChanged: (_) => field.onChanged?.call(),
                )),
            SizedBox(
              width: double.infinity,
              child: ToggleButtons(
                isSelected: _selectedGender,
                onPressed: _onGenderSelected,
                borderRadius: BorderRadius.circular(8),
                selectedColor: Colors.white,
                fillColor: AppColors.primary,
                color: AppColors.primary,
                constraints: BoxConstraints.expand(
                  height: 40,
                  width: MediaQuery.of(context).size.width / 2 - 24,
                ),
                children: [
                  Row(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        CommunityMaterialIcons.gender_male,
                        size: 18,
                      ),
                      Text(
                        'Masculino',
                        style: AppFonts.body1.copyWith(
                          color: _selectedGender[0]
                              ? Colors.white
                              : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        CommunityMaterialIcons.gender_female,
                        size: 18,
                      ),
                      Text(
                        'Femenino',
                        style: AppFonts.body1.copyWith(
                          color: _selectedGender[1]
                              ? Colors.white
                              : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PviFormButton(
                buttonText: 'Guardar',
                onSubmit: _isFormValid
                    ? () {
                        if (_formKey.currentState?.validate() == false) return;

                        final birthDate =
                            _birthDateController.text.toDateTime();
                        if (birthDate == null) return;

                        final age = birthDate.calculateAge();
                        final weight = _weightController.text.toDouble() ?? 0;
                        final height = _heightController.text.toDouble() ?? 0;
                        StatusHandlerFunction.handleStatus(
                          context: context,
                          action: ref
                              .read(healthFormControllerProvider.notifier)
                              .updateHealthForm(
                                HealthFormInfo(
                                  name: _fullNameController.text,
                                  dateOfBirth: birthDate,
                                  personalInfo: PersonalInfo(
                                    age: age,
                                    gender:
                                        _selectedGender[0] ? 'male' : 'female',
                                    height: height * 100,
                                    weight: weight,
                                  ),
                                  step: 1,
                                  completed: false,
                                ),
                              ),
                          onSuccessCallBack: () {
                            ref
                                .read(healthFormControllerProvider.notifier)
                                .updateStep(1);
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
                    : null)
          ]),
    );
  }
}
