import 'dart:convert';

import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:mobile_preven_ia_app/api/controllers/api_controller.dart';
import 'package:mobile_preven_ia_app/firebase/storage/providers/fire_storage_analysis_controller.dart';
import 'package:mobile_preven_ia_app/firebase/storage/providers/fire_storage_user_controller.dart';
import 'package:mobile_preven_ia_app/gemini/prompts/analyze_with_model_prompt.dart';
import 'package:mobile_preven_ia_app/gemini/prompts/analyze_without_model_prompt.dart';
import 'package:mobile_preven_ia_app/gemini/prompts/extraction_prompt.dart';
import 'package:mobile_preven_ia_app/firebase/auth/providers/fire_auth_controller.dart';
import 'package:mobile_preven_ia_app/utils/sanitize_json.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'process_info_controller.g.dart';

@riverpod
class ProcessInfoController extends _$ProcessInfoController {
  @override
  Future<Map<String, dynamic>?> build() async {
    return null;
  }

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
    return (gender == 'MALE') ? 'Masculino' : 'Femenino';
  }

  Future<Map<String, dynamic>?> analyzeTextWithoutModel(
      String plainText) async {
    final gemini = Gemini.instance;
    final extractionResponse = await gemini.prompt(
      parts: [
        Part.text(extractionPrompt),
        Part.text(plainText),
      ],
    );

    final userProfile =
        await ref.read(fireStorageUserControllerProvider.future);

    int age = 0;
    final birthDate = _parseBirthDate(userProfile?.birthDate);
    if (birthDate != null) {
      age = _calculateAge(birthDate);
    }

    final modifiedAnalyzePrompt = analyzeWithoutModelPrompt
        .replaceAll('valor_de_IMC', userProfile?.bmi.toString() ?? '0')
        .replaceAll('valor_de_sexo', parseGender(userProfile?.gender ?? 'M'))
        .replaceAll('valor_de_edad', age.toString());

    final analysisResponse = await gemini.prompt(
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
      state = AsyncData(persistedAnalysis);
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
    final gemini = Gemini.instance;

    final extractionResponse = await gemini.prompt(
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

    final finalHbA1c = _getValueFromExamMultiple(exams, ['hba1c']) ??
        num.parse(parameterValues['hba1c'] ?? '0').toDouble();

    // Llamadas a los modelos premium:
    final obesityPrediction =
        await ref.read(apiControllerProvider.notifier).getObesityPrediction(
              userProfile?.bmi ?? 0,
              finalLDL,
              finalTriglycerides,
              userProfile?.gender ?? 'male',
              age,
              userProfile?.isGeneticRiskObesity ?? false,
            );

    final diabetesPrediction =
        await ref.read(apiControllerProvider.notifier).getDiabetesPrediction(
              finalFastingGlucose,
              finalHbA1c,
              userProfile?.isGeneticRiskDiabetes ?? false,
              userProfile?.gender ?? 'male',
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
          userProfile?.gender ?? 'male',
          age,
          userProfile?.bmi ?? 0,
        );

    final predictionsMap = {
      "obesidad": obesityPrediction.toJson(),
      "diabetes": diabetesPrediction.toJson(),
      "hipertension": hypertensionPrediction.toJson(),
    };

    final predictionsJson = json.encode(predictionsMap);

    final modifiedAnalyzePrompt = analyzeWithModelPrompt
        .replaceAll('valor_de_IMC', userProfile?.bmi.toString() ?? '0')
        .replaceAll('valor_de_sexo', parseGender(userProfile?.gender ?? 'M'))
        .replaceAll('valor_de_edad', age.toString());

    final analysisResponse = await gemini.prompt(
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

      state = AsyncData(persistedAnalysis);
      return persistedAnalysis;
    }

    return null;
  }
}
