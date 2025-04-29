import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_preven_ia_app/core/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_button.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_form_button.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text_input.dart';
import 'package:mobile_preven_ia_app/screens/processing-file/processing_file_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:mobile_preven_ia_app/core/domain/controllers/weight/weight_controller.dart';
import 'package:mobile_preven_ia_app/core/functions/status_handler_function.dart';
import 'package:mobile_preven_ia_app/core/functions/show_toast.dart';
import 'package:mobile_preven_ia_app/core/classes/message_status.dart';

class ManualParametersScreen extends ConsumerStatefulWidget {
  const ManualParametersScreen({super.key});

  @override
  ConsumerState<ManualParametersScreen> createState() =>
      _ManualParametersScreenState();
}

class _ManualParametersScreenState
    extends ConsumerState<ManualParametersScreen> {
  final TextEditingController _systolicController = TextEditingController();
  final TextEditingController _diastolicController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final Map<String, String?> _errors = {};
  bool _isFormValid = false;
  bool _hasSubmitted = false;
  bool _showWeightField = false;

  final Map<String, Map<String, double>> parameterRanges = {
    "presión arterial sistólica": {"min": 70, "max": 250},
    "presión arterial diastólica": {"min": 40, "max": 150},
    "peso": {"min": 30, "max": 200},
  };

  @override
  void initState() {
    super.initState();
    _systolicController.addListener(_validateForm);
    _diastolicController.addListener(_validateForm);
    _weightController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _validateForm() {
    bool valid = true;
    final Map<String, String?> newErrors = {};

    // Validate systolic pressure
    final systolicValue = _systolicController.text.trim();
    if (systolicValue.isEmpty) {
      if (_hasSubmitted) newErrors['systolic'] = "Campo requerido";
      valid = false;
    } else if (double.tryParse(systolicValue) == null) {
      if (_hasSubmitted) {
        newErrors['systolic'] = "Debe ser un número decimal válido";
      }
      valid = false;
    } else {
      final numericValue = double.parse(systolicValue);
      final ranges = parameterRanges["presión arterial sistólica"];
      if (numericValue < ranges!["min"]! || numericValue > ranges["max"]!) {
        if (_hasSubmitted) {
          newErrors['systolic'] =
              "El valor debe estar entre ${ranges["min"]} y ${ranges["max"]}";
        }
        valid = false;
      } else {
        newErrors['systolic'] = null;
      }
    }

    // Validate diastolic pressure
    final diastolicValue = _diastolicController.text.trim();
    if (diastolicValue.isEmpty) {
      if (_hasSubmitted) newErrors['diastolic'] = "Campo requerido";
      valid = false;
    } else if (double.tryParse(diastolicValue) == null) {
      if (_hasSubmitted) {
        newErrors['diastolic'] = "Debe ser un número decimal válido";
      }
      valid = false;
    } else {
      final numericValue = double.parse(diastolicValue);
      final ranges = parameterRanges["presión arterial diastólica"];
      if (numericValue < ranges!["min"]! || numericValue > ranges["max"]!) {
        if (_hasSubmitted) {
          newErrors['diastolic'] =
              "El valor debe estar entre ${ranges["min"]} y ${ranges["max"]}";
        }
        valid = false;
      } else {
        newErrors['diastolic'] = null;
      }
    }

    // Validate weight if shown
    if (_showWeightField) {
      final weightValue = _weightController.text.trim();
      if (weightValue.isEmpty) {
        if (_hasSubmitted) newErrors['weight'] = "Campo requerido";
        valid = false;
      } else if (double.tryParse(weightValue) == null) {
        if (_hasSubmitted) {
          newErrors['weight'] = "Debe ser un número decimal válido";
        }
        valid = false;
      } else {
        final numericValue = double.parse(weightValue);
        final ranges = parameterRanges["peso"];
        if (numericValue < ranges!["min"]! || numericValue > ranges["max"]!) {
          if (_hasSubmitted) {
            newErrors['weight'] =
                "El valor debe estar entre ${ranges["min"]} y ${ranges["max"]}";
          }
          valid = false;
        } else {
          newErrors['weight'] = null;
        }
      }
    }

    setState(() {
      _errors.addAll(newErrors);
      _isFormValid = valid;
    });
  }

  void _submitParameters(String documentId) {
    setState(() {
      _hasSubmitted = true;
    });
    _validateForm();
    if (!_isFormValid) {
      return;
    }

    // Update weight if shown and valid
    if (_showWeightField && _weightController.text.isNotEmpty) {
      final newWeight =
          double.tryParse(_weightController.text.replaceAll(',', '.'));
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
          },
        );
      }
    }

    PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
      context,
      screen: const ProcessingFileScreen(),
      withNavBar: false,
      pageTransitionAnimation: PageTransitionAnimation.fade,
      settings: RouteSettings(arguments: {
        'documentId': documentId,
        'systolic': _systolicController.text,
        'diastolic': _diastolicController.text,
      }),
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
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};
    final documentId = args['documentId'] as String?;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const PviText(
                text: "Presión Arterial", variant: TextVariant.headline1),
            const PviText(
              text:
                  "Ingrese sus valores de presión arterial para continuar con el diagnóstico",
              variant: TextVariant.body1,
            ),
            const SizedBox(height: 16),
            PviTextInput(
              controller: _systolicController,
              label: "Presión arterial sistólica (mmHg)",
              errorText: _errors['systolic'],
              suffixIcon: _buildBloodPressureTooltip(),
              onChanged: (_) => _validateForm(),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            PviTextInput(
              controller: _diastolicController,
              label: "Presión arterial diastólica (mmHg)",
              errorText: _errors['diastolic'],
              suffixIcon: _buildBloodPressureTooltip(),
              onChanged: (_) => _validateForm(),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: PviFormButton(
                    buttonVariant: ButtonVariant.text,
                    buttonColor: AppColors.primary,
                    buttonText:
                        _showWeightField ? 'Ocultar peso' : 'Actualizar peso',
                    onSubmit: () {
                      setState(() {
                        _showWeightField = !_showWeightField;
                        if (!_showWeightField) {
                          _weightController.clear();
                          _errors.remove('weight');
                        }
                      });
                      _validateForm();
                    },
                  ),
                ),
              ],
            ),
            if (_showWeightField) ...[
              const SizedBox(height: 16),
              PviTextInput(
                controller: _weightController,
                label: "Peso (kg)",
                errorText: _errors['weight'],
                onChanged: (_) => _validateForm(),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: PviFormButton(
                buttonVariant: ButtonVariant.primary,
                buttonText: 'Continuar',
                onSubmit: _isFormValid
                    ? () => _submitParameters(documentId ?? '')
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: PviFormButton(
                buttonVariant: ButtonVariant.text,
                buttonColor: AppColors.primary,
                buttonText: 'Cancelar',
                onSubmit: () => PersistentNavBarNavigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
