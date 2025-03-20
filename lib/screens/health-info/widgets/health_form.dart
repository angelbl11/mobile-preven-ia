import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_preven_ia_app/classes/message_status.dart';
import 'package:mobile_preven_ia_app/firebase/auth/providers/fire_auth_controller.dart';
import 'package:mobile_preven_ia_app/functions/show_date_picker.dart';
import 'package:mobile_preven_ia_app/functions/show_toast.dart';
import 'package:mobile_preven_ia_app/functions/status_handler_function.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/screens/health-info/models/health_form_field.dart';
import 'package:mobile_preven_ia_app/screens/health-info/widgets/health_monitoring_checkboxes.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_form_button.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_info_message.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text_input.dart';
import 'package:mobile_preven_ia_app/screens/health-info/widgets/health_conditions_checkboxes.dart';
import 'package:mobile_preven_ia_app/screens/navigation-handler/navigation_handler_screen.dart';

class HealthForm extends ConsumerStatefulWidget {
  const HealthForm({super.key});

  @override
  ConsumerState<HealthForm> createState() => _HealthFormState();
}

class _HealthFormState extends ConsumerState<HealthForm> {
  final _formKey = GlobalKey<FormState>();
  final List<bool> _selectedGender = [false, false];

  // Controllers
  final _fullNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _maternalLastNameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _genderController = TextEditingController();

  // Checkbox states
  bool _hasDiabetes = false;
  bool _hasHypertension = false;
  bool _hasObesity = false;
  bool _monitorLDL = false;
  bool _monitorGlucose = false;
  bool _monitorWeight = false;

  late final Map<String, HealthFormField> _formFields;

  @override
  void initState() {
    super.initState();
    _initializeFormFields();
  }

  void _initializeFormFields() {
    _formFields = {
      'fullName': HealthFormField(
        label: 'Nombre',
        controller: _fullNameController,
        keyboardType: TextInputType.name,
        prefixIcon: LucideIcons.user,
        validator: _validateRequired,
      ),
      'lastName': HealthFormField(
        label: 'Apellido paterno',
        controller: _lastNameController,
        keyboardType: TextInputType.name,
        validator: _validateRequired,
      ),
      'maternalLastName': HealthFormField(
        label: 'Apellido materno',
        controller: _maternalLastNameController,
        keyboardType: TextInputType.name,
        validator: _validateRequired,
      ),
      'birthDate': HealthFormField(
        label: 'Fecha de nacimiento',
        controller: _birthDateController,
        keyboardType: TextInputType.datetime,
        prefixIcon: LucideIcons.calendar,
        readOnly: true,
        onTap: () => showPlatformDatePicker(context, _birthDateController),
        validator: _validateBirthDate,
      ),
      'weight': HealthFormField(
        label: 'Peso (kg)',
        controller: _weightController,
        keyboardType: TextInputType.text,
        prefixIcon: CommunityMaterialIcons.weight_kilogram,
        validator: _validateWeight,
      ),
      'height': HealthFormField(
        label: 'Estatura (m)',
        controller: _heightController,
        keyboardType: TextInputType.text,
        prefixIcon: CommunityMaterialIcons.human_male_height,
        validator: _validateHeight,
      ),
    };
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

  void _onGenderSelected(int index) {
    setState(() {
      for (int i = 0; i < _selectedGender.length; i++) {
        _selectedGender[i] = i == index;
      }
      _genderController.text = index == 0 ? 'male' : 'female';
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      await StatusHandlerFunction.handleStatus(
        context: context,
        action: ref
            .read(fireAuthControllerProvider.notifier)
            .completeHealthForm(
              uid: ref.read(fireAuthControllerProvider).value?.user.uid ?? '',
              name: _fullNameController.text.trim(),
              lastName: _lastNameController.text.trim(),
              maternalLastName: _maternalLastNameController.text.trim(),
              gender: _genderController.text.trim().toUpperCase(),
              birthDate: _birthDateController.text.trim(),
              weight: double.tryParse(_weightController.text) ?? 0.0,
              height: double.tryParse(_heightController.text) ?? 0.0,
              isGeneticRiskDiabetes: _hasDiabetes,
              isGeneticRiskHypertension: _hasHypertension,
              isGeneticRiskObesity: _hasObesity,
              monitorLDL: _monitorLDL,
              monitorGlucose: _monitorGlucose,
              monitorWeight: _monitorWeight,
            ),
        onSuccessCallBack: () async {
          showToast(
            status: MessageStatus.success,
            context: context,
            message: 'Perfil completado exitosamente',
          );
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => NavigationHandlerScreen(),
              ),
              (route) => false,
            );
          }
        },
      );
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _lastNameController.dispose();
    _maternalLastNameController.dispose();
    _birthDateController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 22,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                width: MediaQuery.of(context).size.width / 2 - 27,
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
                    PviText(
                      text: 'Masculino',
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
                    PviText(
                      text: 'Femenino',
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
          HealthConditionsCheckboxes(
            hasDiabetes: _hasDiabetes,
            hasHypertension: _hasHypertension,
            hasObesity: _hasObesity,
            onDiabetesChanged: (value) {
              setState(() {
                _hasDiabetes = value;
              });
            },
            onHypertensionChanged: (value) {
              setState(() {
                _hasHypertension = value;
              });
            },
            onObesityChanged: (value) {
              setState(() {
                _hasObesity = value;
              });
            },
          ),
          HealthMonitoringCheckboxes(
            monitorLDL: _monitorLDL,
            monitorGlucose: _monitorGlucose,
            monitorWeight: _monitorWeight,
            onLDLChanged: (value) => setState(() => _monitorLDL = value),
            onGlucoseChanged: (value) =>
                setState(() => _monitorGlucose = value),
            onWeightChanged: (value) => setState(() => _monitorWeight = value),
          ),
          const PviInfoMessage(
            message:
                'Esta información nos ayuda a otorgarte resultados más precisos y personalizados en base a tus condiciones médicas',
          ),
          PviFormButton(
            onSubmit: _submit,
            buttonText: 'Completar perfil',
          ),
        ],
      ),
    );
  }
}
