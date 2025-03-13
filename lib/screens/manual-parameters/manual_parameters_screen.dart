import 'package:flutter/material.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/screens/processing-file/processing_file_screen.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_button.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text_button.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text_input.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class ManualParametersScreen extends StatefulWidget {
  const ManualParametersScreen({super.key});

  @override
  State<ManualParametersScreen> createState() => _ManualParametersScreenState();
}

class _ManualParametersScreenState extends State<ManualParametersScreen> {
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
        newErrors[param] = null;
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
      parameterValues[standardizedKey] = _controllers[param]?.text.trim() ?? "";
    }

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
                    "Ingrese los parámetros faltantes para continuar con el diagnóstico",
                style: AppFonts.subtitle2,
              ),
              const SizedBox(height: 16),
              ...missingParams.map(
                (param) => PviTextInput(
                  controller: _controllers[param],
                  label: formattedLabels[param] ?? param,
                  errorText: _errors[param],
                  onChanged: (_) => _validateForm(),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
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
