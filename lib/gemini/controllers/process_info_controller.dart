import 'dart:convert';

import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:mobile_preven_ia_app/api/controllers/api_controller.dart';
import 'package:mobile_preven_ia_app/firebase/storage/providers/fire_storage_analysis_controller.dart';
import 'package:mobile_preven_ia_app/firebase/storage/providers/fire_storage_user_controller.dart';
import 'package:mobile_preven_ia_app/gemini/controllers/gemini_controller.dart';
import 'package:mobile_preven_ia_app/gemini/prompts/analyze_without_model_prompt.dart';
import 'package:mobile_preven_ia_app/gemini/prompts/extraction_prompt.dart';
import 'package:mobile_preven_ia_app/firebase/auth/providers/fire_auth_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'process_info_controller.g.dart';

@Riverpod(keepAlive: true)
class ProcessInfoController extends _$ProcessInfoController {
  @override
  Future<String?> build() async {
    return null;
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
    if (gender == 'M') {
      return 'Masculino';
    }
    return 'Femenino';
  }

  String parseGenderForModel(String gender) {
    if (gender == 'M') {
      return 'male';
    }
    return 'female';
  }

  Future<Map<String, dynamic>?> analyzeTextWithoutModel(
      String plainText) async {
    final geminiController = ref.watch(geminiControllerProvider);

    // Primera etapa: extraer datos del texto.
    final extractionResponse = await geminiController.prompt(
      parts: [
        Part.text(extractionPrompt),
        Part.text(plainText),
      ],
    );

    // Obtenemos el perfil del usuario.
    final userProfile =
        await ref.watch(fireStorageUserControllerProvider.future);

    int age = 0;
    final birthDate = _parseBirthDate(userProfile?.birthDate);
    if (birthDate != null) {
      age = _calculateAge(birthDate);
    }

    // Reemplazamos los placeholders en el prompt con los valores reales.
    final modifiedAnalyzePrompt = analyzeWithoutModelPrompt
        .replaceAll('valor_de_IMC', userProfile?.bmi.toString() ?? '0')
        .replaceAll('valor_de_sexo', parseGender(userProfile?.gender ?? 'M'))
        .replaceAll('valor_de_edad', age.toString());

    // Segunda etapa: análisis del texto extraído con los valores actualizados.
    final analysisResponse = await geminiController.prompt(
      parts: [
        Part.text(modifiedAnalyzePrompt),
        Part.text(extractionResponse?.output ?? ''),
      ],
    );

    final analysisOutput = analysisResponse?.output;

    // Persistir el análisis en Firestore si se obtuvo resultado.
    final currentUser = ref.read(fireAuthControllerProvider).value?.user;
    if (analysisOutput != null && currentUser != null) {
      final persistedAnalysis = await ref
          .read(fireStorageAnalysisControllerProvider.notifier)
          .createUserAnalysis(currentUser.uid, analysisOutput);
      return persistedAnalysis;
    }

    return null;
  }

  double? _getValueFromExam(Map<String, dynamic> exams, String key) {
    if (exams.containsKey(key)) {
      final examEntry = exams[key] as Map<String, dynamic>;
      final rawValue = examEntry['value'] as String? ?? '';
      final numericString = rawValue.replaceAll(RegExp(r'[^\d\.]'), '');
      if (numericString.isNotEmpty) {
        return double.tryParse(numericString);
      }
    }
    return null;
  }

  Future<String?> analyzeTextWithModel(
    String plainText,
    String? ldl,
    String? triglycerides,
    String? fastingGlucose,
    String? hba1c,
    String? systolicPressure,
    String? diastolicPressure,
    String? creatinine,
  ) async {
    final geminiController = ref.watch(geminiControllerProvider);

    // Primera etapa: extraer datos del texto.
    final extractionResponse = await geminiController.prompt(
      parts: [
        Part.text(extractionPrompt),
        Part.text(plainText),
      ],
    );

    // Intentamos extraer un JSON con los exámenes, si es posible.
    Map<String, dynamic> extractedData = {};
    if (extractionResponse?.output != null) {
      try {
        extractedData =
            json.decode(extractionResponse!.output!) as Map<String, dynamic>;
      } catch (e) {
        extractedData = {};
      }
    }
    final exams = extractedData['exams'] as Map<String, dynamic>? ?? {};

    // Obtenemos el perfil del usuario.
    final userProfile =
        await ref.read(fireStorageUserControllerProvider.future);

    // Calculamos la edad a partir de la birthDate.
    int age = 0;
    final birthDate = _parseBirthDate(userProfile?.birthDate);
    if (birthDate != null) {
      age = _calculateAge(birthDate);
    }

    // Validación: usar valores del análisis extraído si existen, sino usar los parámetros.
    final finalLDL =
        _getValueFromExam(exams, 'LDL') ?? num.parse(ldl ?? '0').toDouble();
    final finalTriglycerides = _getValueFromExam(exams, 'Trigliceridos') ??
        num.parse(triglycerides ?? '0').toDouble();
    final finalFastingGlucose = _getValueFromExam(exams, 'Glucosa en ayunas') ??
        num.parse(fastingGlucose ?? '0').toDouble();
    final finalCreatinine = _getValueFromExam(exams, 'Creatinina') ??
        num.parse(creatinine ?? '0').toDouble();

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
              num.parse(hba1c ?? '0'),
              userProfile?.isGeneticRiskDiabetes ?? false,
              parseGenderForModel(userProfile?.gender ?? 'M'),
              age,
              userProfile?.bmi ?? 0,
            );

    final hypertensionPrediction = await ref
        .read(apiControllerProvider.notifier)
        .getHypertensionPrediction(
          num.parse(systolicPressure ?? '0'),
          num.parse(diastolicPressure ?? '0'),
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

    // Convertir el Map de predicciones a una cadena JSON.
    final predictionsJson = json.encode(predictionsMap);

    // Reemplazar placeholders en el prompt premium con los datos básicos.
    final modifiedAnalyzePrompt = analyzeWithoutModelPrompt
        .replaceAll('valor_de_IMC', userProfile?.bmi.toString() ?? '0')
        .replaceAll('valor_de_sexo', parseGender(userProfile?.gender ?? 'M'))
        .replaceAll('valor_de_edad', age.toString());

    // Llamar al prompt premium, pasando además la cadena de predicciones.
    final analysisResponse = await geminiController.prompt(
      parts: [
        Part.text(modifiedAnalyzePrompt),
        Part.text(plainText),
        Part.text(predictionsJson),
      ],
    );

    final analysisOutput = analysisResponse?.output;

    // Persistir el análisis en Firestore si se obtuvo resultado.
    final currentUser = ref.read(fireAuthControllerProvider).value?.user;
    if (analysisOutput != null && currentUser != null) {
      final persistedAnalysis = await ref
          .read(fireStorageAnalysisControllerProvider.notifier)
          .createUserAnalysis(currentUser.uid, analysisOutput);
      // Retornamos el análisis persistido en formato JSON.
      return json.encode(persistedAnalysis);
    }

    return analysisOutput;
  }
}
