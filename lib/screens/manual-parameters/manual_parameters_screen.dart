import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/screens/processing-file/processing_file_screen.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_button.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_info_message.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text_button.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text_input.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_weight_update_modal.dart';
import 'package:mobile_preven_ia_app/firebase/storage/user/user_controller.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class ManualParametersScreen extends ConsumerStatefulWidget {
  const ManualParametersScreen({super.key});

  @override
  ConsumerState<ManualParametersScreen> createState() =>
      _ManualParametersScreenState();
}

class _ManualParametersScreenState
    extends ConsumerState<ManualParametersScreen> {
  List<String> missingParams = [];
  String extractedText = '';
  final Map<String, TextEditingController> _controllers = {};
  Map<String, String?> _errors = {};
  bool _isFormValid = false;
  bool _hasSubmitted = false;

  final Map<String, String> formattedLabels = {
    "ldl": "LDL (mg/dL)",
    "triglicéridos": "Triglicéridos (mg/dL)",
    "glucosa": "Glucosa (mg/dL)",
    "hba1c": "Hb1Ac (%)",
    "creatinina": "Creatinina (mg/dL)",
    "presión arterial sistólica": "Presión arterial sistólica (mmHg)",
    "presión arterial diastólica": "Presión arterial diastólica (mmHg)",
  };

  final Map<String, Map<String, double>> parameterRanges = {
    "ldl": {"min": 0, "max": 500},
    "triglicéridos": {"min": 0, "max": 1000},
    "glucosa": {"min": 0, "max": 400},
    "hba1c": {"min": 0, "max": 20},
    "creatinina": {"min": 0, "max": 10},
    "presión arterial sistólica": {"min": 70, "max": 250},
    "presión arterial diastólica": {"min": 40, "max": 150},
  };

  final Map<String, String> standardizedKeys = {
    "Hb1Ac (%)": "hba1c",
    "Presión arterial sistólica (mmHg)": "presion_arterial_sistolica",
    "Presión arterial diastólica (mmHg)": "presion_arterial_diastolica",
    "LDL (mg/dL)": "ldl",
    "Triglicéridos (mg/dL)": "trigliceridos",
    "Glucosa (mg/dL)": "glucosa",
    "Creatinina (mg/dL)": "creatinina",
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      missingParams = args['missingParameters'] as List<String>;
      extractedText = args['extractedText'] as String;
      for (var param in missingParams) {
        if (!_controllers.containsKey(param)) {
          _controllers[param] = TextEditingController();
          _controllers[param]!.addListener(_validateForm);
        }
        _errors[param] = null;
      }
      _validateForm();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _validateForm() {
    bool valid = true;
    final Map<String, String?> newErrors = {};
    for (var param in missingParams) {
      final value = _controllers[param]?.text.trim() ?? '';
      if (value.isEmpty) {
        if (_hasSubmitted) newErrors[param] = "Campo requerido";
        valid = false;
      } else if (double.tryParse(value) == null) {
        if (_hasSubmitted) {
          newErrors[param] = "Debe ser un número decimal válido";
        }
        valid = false;
      } else {
        final numericValue = double.parse(value);
        final ranges = parameterRanges[param.toLowerCase()];
        if (ranges != null) {
          if (numericValue < ranges["min"]! || numericValue > ranges["max"]!) {
            if (_hasSubmitted) {
              newErrors[param] =
                  "El valor debe estar entre ${ranges["min"]} y ${ranges["max"]}";
            }
            valid = false;
          } else {
            newErrors[param] = null;
          }
        } else {
          newErrors[param] = null;
        }
      }
    }
    setState(() {
      _errors = newErrors;
      _isFormValid = valid;
    });
  }

  void _submitParameters() {
    setState(() {
      _hasSubmitted = true;
    });
    _validateForm();
    if (!_isFormValid) {
      return;
    }
    final Map<String, String> parameterValues = {};
    for (var param in missingParams) {
      final standardizedKey = standardizedKeys[param] ?? param.toLowerCase();
      final controller = _controllers[param];
      if (controller != null && controller.text.isNotEmpty) {
        final value = controller.text.trim();
        if (value.isNotEmpty) {
          parameterValues[standardizedKey] = value;
        }
      }
    }

    // Debug prints

    if (parameterValues.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, ingrese al menos un parámetro válido'),
        ),
      );
      return;
    }

    // Show weight update modal before proceeding
    ref.read(userControllerProvider).whenData((userProfile) {
      if (userProfile != null) {
        showDialog(
          context: context,
          builder: (context) => PviWeightUpdateModal(
            currentWeight: userProfile.weight,
            showSkipButton: true,
            onWeightUpdated: () {
              _proceedWithSubmission(parameterValues);
            },
          ),
        );
      } else {
        _proceedWithSubmission(parameterValues);
      }
    });
  }

  void _proceedWithSubmission(Map<String, String> parameterValues) {
    PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
      context,
      screen: const ProcessingFileScreen(),
      withNavBar: false,
      pageTransitionAnimation: PageTransitionAnimation.fade,
      settings: RouteSettings(
        arguments: {
          'extractedText': extractedText,
          'parameterValues': parameterValues,
          'isUsingModel': true,
        },
      ),
    );
  }

  Widget _buildBloodPressureTooltip() {
    return Tooltip(
      message: 'Cómo medir la presión arterial',
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              backgroundColor: Colors.white,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.95,
                  maxHeight: MediaQuery.of(context).size.height * 0.95,
                ),
                child: Stack(
                  children: [
                    InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 4.0,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/images/blood-pressure.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      right: -8,
                      top: -8,
                      child: IconButton(
                        icon: const Icon(LucideIcons.x),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        child: const Icon(
          LucideIcons.info,
          color: AppColors.primary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
          child: Column(
            spacing: 22,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PviText(text: "Parámetros faltantes", style: AppFonts.headline1),
              PviText(
                text:
                    "Ingrese los parámetros faltantes para continuar con el diagnóstico utilizando el modelo de IA",
                style: AppFonts.subtitle2,
              ),
              const SizedBox(height: 16),
              ...missingParams.map(
                (param) => PviTextInput(
                  controller: _controllers[param],
                  label: formattedLabels[param] ?? param,
                  errorText: _errors[param],
                  suffixIcon: param.toLowerCase().contains('presión arterial')
                      ? _buildBloodPressureTooltip()
                      : missingParams.any((param) => _errors[param] != null)
                          ? const Icon(
                              LucideIcons.info,
                              color: AppColors.primary,
                            )
                          : null,
                  onChanged: (_) => _validateForm(),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              const PviInfoMessage(
                message:
                    "Si no conoces el valor de los parámetros, vuelve a la pantalla anterior y selecciona el botón de 'Continuar'",
              ),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: PviButton(
                  onPressed: _isFormValid ? _submitParameters : null,
                  child: PviText(
                    text: "Actualizar parámetros",
                    style: AppFonts.button1.copyWith(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: PviTextButton(
                  text: 'Cancelar',
                  onPressed: () => PersistentNavBarNavigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
