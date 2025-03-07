import 'dart:convert';

import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:mobile_preven_ia_app/api/controllers/api_controller.dart';
import 'package:mobile_preven_ia_app/firebase/storage/providers/fire_storage_analysis_controller.dart';
import 'package:mobile_preven_ia_app/firebase/storage/providers/fire_storage_user_controller.dart';
import 'package:mobile_preven_ia_app/gemini/controllers/gemini_controller.dart';
import 'package:mobile_preven_ia_app/gemini/prompts/analyze_without_model_prompt.dart';
import 'package:mobile_preven_ia_app/gemini/prompts/extraction_prompt.dart';
import 'package:mobile_preven_ia_app/firebase/auth/providers/fire_auth_controller.dart';
import 'package:mobile_preven_ia_app/utils/sanitize_json.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'process_info_controller.g.dart';

@riverpod
class ProcessInfoController extends _$ProcessInfoController {
  // Variable para almacenar en caché el análisis con modelos.
  Map<String, dynamic>? _cachedAnalysisWithModel;
  // Bandera para evitar ejecuciones concurrentes.
  bool _isAnalyzingWithModel = false;

  @override
  Future<Map<String, dynamic>?> build() async {
    return _cachedAnalysisWithModel;
  }

  /// Parsea la fecha de nacimiento en formato "DD/MM/YYYY".
  DateTime? _parseBirthDate(String? birthDateStr) {
    if (birthDateStr == null || birthDateStr.isEmpty) return null;
    try {
      final parts = birthDateStr.split('/');
      if (parts.length != 3) return null;
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (e) {
      return null;
    }
  }

  /// Calcula la edad a partir de la fecha de nacimiento.
  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  String parseGender(String gender) {
    return (gender == 'M') ? 'Masculino' : 'Femenino';
  }

  String parseGenderForModel(String gender) {
    return (gender == 'M') ? 'male' : 'female';
  }

  Future<Map<String, dynamic>?> analyzeTextWithoutModel(
      String plainText) async {
    final geminiController = ref.watch(geminiControllerProvider);

    final extractionResponse = await geminiController.prompt(
      parts: [
        Part.text(extractionPrompt),
        Part.text(plainText),
      ],
    );

    final userProfile =
        await ref.watch(fireStorageUserControllerProvider.future);

    int age = 0;
    final birthDate = _parseBirthDate(userProfile?.birthDate);
    if (birthDate != null) {
      age = _calculateAge(birthDate);
    }

    final modifiedAnalyzePrompt = analyzeWithoutModelPrompt
        .replaceAll('valor_de_IMC', userProfile?.bmi.toString() ?? '0')
        .replaceAll('valor_de_sexo', parseGender(userProfile?.gender ?? 'M'))
        .replaceAll('valor_de_edad', age.toString());

    final analysisResponse = await geminiController.prompt(
      parts: [
        Part.text(modifiedAnalyzePrompt),
        Part.text(extractionResponse?.output ?? ''),
      ],
    );

    final analysisOutput = analysisResponse?.output;
    final currentUser = ref.read(fireAuthControllerProvider).value?.user;
    if (analysisOutput != null && currentUser != null) {
      final persistedAnalysis = await ref
          .read(fireStorageAnalysisControllerProvider.notifier)
          .createUserAnalysis(currentUser.uid, analysisOutput);
      return persistedAnalysis;
    }

    return null;
  }

  double? _getValueFromExamMultiple(
      Map<String, dynamic> exams, List<String> candidateKeys) {
    final lowerCandidates = candidateKeys.map((e) => e.toLowerCase()).toList();
    for (final entry in exams.entries) {
      final examKey = entry.key.toLowerCase();
      if (lowerCandidates.any((candidate) => examKey.contains(candidate))) {
        String rawValue;
        if (entry.value is Map<String, dynamic>) {
          rawValue = entry.value['value'] as String? ?? '';
        } else if (entry.value is String) {
          rawValue = entry.value;
        } else {
          continue;
        }
        final numericString = rawValue.replaceAll(RegExp(r'[^\d\.]'), '');
        if (numericString.isNotEmpty) {
          return double.tryParse(numericString);
        }
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> analyzeTextWithModel(
    String plainText,
    Map<String, String> parameterValues,
  ) async {
    // Si ya se obtuvo un resultado, retornarlo
    if (_cachedAnalysisWithModel != null) {
      return _cachedAnalysisWithModel;
    }
    // Evitar ejecuciones concurrentes
    if (_isAnalyzingWithModel) return null;
    _isAnalyzingWithModel = true;

    final geminiController = ref.read(geminiControllerProvider);

    // Primera etapa: extraer datos del texto.
    final extractionResponse = await geminiController.prompt(
      parts: [
        Part.text(extractionPrompt),
        Part.text(plainText),
      ],
    );

    Map<String, dynamic> extractedData = {};
    if (extractionResponse?.output != null) {
      final sanitizedOutput = sanitizeJson(extractionResponse?.output ?? '');
      try {
        extractedData = json.decode(sanitizedOutput) as Map<String, dynamic>;
      } catch (e) {
        extractedData = {};
      }
    }

    print('Valor de exams: $extractedData');
    final exams = extractedData;

    final userProfile =
        await ref.read(fireStorageUserControllerProvider.future);

    int age = 0;
    final birthDate = _parseBirthDate(userProfile?.birthDate);
    if (birthDate != null) {
      age = _calculateAge(birthDate);
    }

    final finalLDL =
        _getValueFromExamMultiple(exams, ['ldl', 'colesterol ldl directo']) ??
            num.parse(parameterValues['ldl'] ?? '0').toDouble();
    final finalTriglycerides =
        _getValueFromExamMultiple(exams, ['trigliceridos', 'triglicéridos']) ??
            num.parse(parameterValues['triglicéridos'] ?? '0').toDouble();
    final finalFastingGlucose =
        _getValueFromExamMultiple(exams, ['glucosa en ayunas', 'glucosa']) ??
            num.parse(parameterValues['glucosa'] ?? '0').toDouble();
    final finalCreatinine = _getValueFromExamMultiple(exams, ['creatinina']) ??
        num.parse(parameterValues['creatinina'] ?? '0').toDouble();
    final finalSystolicPressure =
        _getValueFromExamMultiple(exams, ['presión arterial sistólica']) ??
            num.parse(parameterValues['presión arterial sistólica'] ?? '0')
                .toDouble();
    final finalDiastolicPressure =
        _getValueFromExamMultiple(exams, ['presión arterial diastólica']) ??
            num.parse(parameterValues['presión arterial diastólica'] ?? '0')
                .toDouble();

    // Llamadas a los modelos premium:
    final obesityPrediction =
        await ref.read(apiControllerProvider.notifier).getObesityPrediction(
              userProfile?.bmi ?? 0,
              finalLDL,
              finalTriglycerides,
              parseGenderForModel(userProfile?.gender ?? 'M'),
              age,
              userProfile?.isGeneticRiskObesity ?? false,
            );

    final diabetesPrediction =
        await ref.read(apiControllerProvider.notifier).getDiabetesPrediction(
              finalFastingGlucose,
              num.parse(parameterValues['hba1c'] ?? '0'),
              userProfile?.isGeneticRiskDiabetes ?? false,
              parseGenderForModel(userProfile?.gender ?? 'M'),
              age,
              userProfile?.bmi ?? 0,
            );

    final hypertensionPrediction = await ref
        .read(apiControllerProvider.notifier)
        .getHypertensionPrediction(
          finalSystolicPressure,
          finalDiastolicPressure,
          finalCreatinine,
          finalLDL,
          userProfile?.isGeneticRiskHypertension ?? false,
          parseGenderForModel(userProfile?.gender ?? 'M'),
          age,
          userProfile?.bmi ?? 0,
        );

    // Construir un Map con los resultados de los modelos.
    final predictionsMap = {
      "obesidad": obesityPrediction.toJson(),
      "diabetes": diabetesPrediction.toJson(),
      "hipertension": hypertensionPrediction.toJson(),
    };

    // Convertir el Map de predicciones a cadena JSON.
    final predictionsJson = json.encode(predictionsMap);

    // Reemplazar los placeholders en el prompt premium con los datos básicos.
    final modifiedAnalyzePrompt = analyzeWithoutModelPrompt
        .replaceAll('valor_de_IMC', userProfile?.bmi.toString() ?? '0')
        .replaceAll('valor_de_sexo', parseGender(userProfile?.gender ?? 'M'))
        .replaceAll('valor_de_edad', age.toString());

    // Llamar al prompt premium, pasando la cadena de predicciones.
    final analysisResponse = await geminiController.prompt(
      parts: [
        Part.text(modifiedAnalyzePrompt),
        Part.text(plainText),
        Part.text(predictionsJson),
      ],
    );

    final analysisOutput = analysisResponse?.output;
    final currentUser = ref.read(fireAuthControllerProvider).value?.user;
    if (analysisOutput != null && currentUser != null) {
      final persistedAnalysis = await ref
          .read(fireStorageAnalysisControllerProvider.notifier)
          .createUserAnalysis(currentUser.uid, analysisOutput);
      // Guardar en caché el resultado para futuras llamadas.
      _cachedAnalysisWithModel = persistedAnalysis;
      _isAnalyzingWithModel = false;
      return persistedAnalysis;
    }

    _isAnalyzingWithModel = false;
    return null;
  }
}
