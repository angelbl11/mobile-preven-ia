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

  // Mapeo para formatear el nombre de cada parámetro con sus unidades.
  final Map<String, String> formattedLabels = {
    "ldl": "LDL (mg/dL)",
    "triglicéridos": "Triglicéridos (mg/dL)",
    "glucosa": "Glucosa (mg/dL)",
    "hba1c": "Hb1Ac (%)",
    "creatinina": "Creatinina (mg/dL)",
    "presión arterial sistólica": "Presión arterial sistólica (mmHg)",
    "presión arterial diastólica": "Presión arterial diastólica (mmHg)",
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Recupera la lista de parámetros faltantes desde los argumentos de la ruta.
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      missingParams = args['missingParameters'] as List<String>;
      extractedText = args['extractedText'] as String;
      // Para cada parámetro faltante, se crea el controlador (si no existe) y se inicializa el error.
      for (var param in missingParams) {
        if (!_controllers.containsKey(param)) {
          _controllers[param] = TextEditingController();
          // Agrega un listener para validar el campo cada vez que cambie.
          _controllers[param]!.addListener(_validateForm);
        }
        _errors[param] = null;
      }
      // Validamos inicialmente en caso de que ya haya algún valor.
      _validateForm();
    }
  }

  @override
  void dispose() {
    // Limpia todos los controladores.
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  /// Valida que cada input tenga valor y que sea un número decimal válido.
  void _validateForm() {
    bool valid = true;
    final Map<String, String?> newErrors = {};
    for (var param in missingParams) {
      final value = _controllers[param]?.text.trim() ?? '';
      if (value.isEmpty) {
        newErrors[param] = "Campo requerido";
        valid = false;
      } else if (double.tryParse(value) == null) {
        newErrors[param] = "Debe ser un número decimal válido";
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
    final Map<String, String> parameterValues = {};
    for (var param in missingParams) {
      final formattedKey = formattedLabels[param] ?? param;
      parameterValues[formattedKey] = _controllers[param]?.text.trim() ?? "";
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
              // Genera un PviTextInput para cada parámetro faltante.
              ...missingParams.map(
                (param) => PviTextInput(
                  controller: _controllers[param],
                  label: formattedLabels[param] ?? param,
                  errorText: _errors[param],
                  onChanged: (value) => _validateForm(),
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
                    onPressed: () => PersistentNavBarNavigator.pop(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
