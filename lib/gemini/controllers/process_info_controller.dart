import 'dart:convert';

import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:mobile_preven_ia_app/api/controllers/api_controller.dart';
import 'package:mobile_preven_ia_app/firebase/storage/clinical-analysis/clinical_analysis_controller.dart';
import 'package:mobile_preven_ia_app/firebase/storage/mappers/analysis_data.dart';
import 'package:mobile_preven_ia_app/firebase/storage/user/user_controller.dart';
import 'package:mobile_preven_ia_app/gemini/controllers/gemini_controller.dart';
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
  Future<AnalysisData?> build() async {
    return null;
  }

  DateTime? _parseBirthDate(String? birthDateStr) {
    if (birthDateStr == null || birthDateStr.isEmpty) return null;
    // Debug log
    try {
      final parts = birthDateStr.split('-');
      if (parts.length != 3) return null;
      // Debug log
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      final parsedDate = DateTime(year, month, day);
      // Debug log
      return parsedDate;
    } catch (e) {
      // Debug log
      return null;
    }
  }

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    // Debug log
    // Debug log
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    // Debug log
    return age;
  }

  String parseGender(String gender) {
    return (gender == 'MALE') ? 'Masculino' : 'Femenino';
  }

  Future<AnalysisData?> analyzeTextWithoutModel(String plainText) async {
    try {
      final gemini = ref.read(geminiControllerProvider.notifier);
      final extractionResponse = await gemini.prompt(
        [
          Part.text(extractionPrompt),
          Part.text(plainText),
        ],
      );

      final userProfile = await ref.read(userControllerProvider.future);

      int age = 0;
      final birthDate = _parseBirthDate(userProfile?.birthDate);
      if (birthDate != null) {
        age = _calculateAge(birthDate);
      }

      final modifiedAnalyzePrompt = analyzeWithoutModelPrompt
          .replaceAll('valor_de_IMC', userProfile?.bmi.toString() ?? '0')
          .replaceAll(
              'valor_de_sexo', parseGender(userProfile?.gender ?? 'MALE'))
          .replaceAll('valor_de_edad', age.toString());

      final analysisResponse = await gemini.prompt([
        Part.text(modifiedAnalyzePrompt),
        Part.text(extractionResponse),
      ]);

      if (analysisResponse.isEmpty) {
        throw Exception('La respuesta del análisis está vacía');
      }

      final currentUser = ref.read(fireAuthControllerProvider).value?.user;
      if (currentUser != null) {
        // Remove markdown and clean response
        String cleanResponse =
            analysisResponse.replaceAll(RegExp(r'```json\n?'), '');
        cleanResponse = cleanResponse.replaceAll(RegExp(r'```\n?'), '');
        cleanResponse = cleanResponse.trim();

        // Handle truncated JSON
        if (!cleanResponse.endsWith('}')) {
          // Find the last complete exam entry
          final lastCompleteExam =
              RegExp(r'.*},[^}]*$').firstMatch(cleanResponse);
          if (lastCompleteExam != null) {
            // Truncate at the last complete exam and close the JSON structure
            cleanResponse = '${lastCompleteExam.group(0)}}}}';
          } else {
            // If we can't find a clean cut point, throw an error
            throw Exception(
                'No se pudo procesar la respuesta completa. Por favor, intente con menos parámetros.');
          }
        }

        try {
          // Validate JSON before parsing

          final persistedAnalysis = await ref
              .read(clinicalAnalysisControllerProvider.notifier)
              .createUserAnalysis(currentUser.uid, cleanResponse);
          state = AsyncData(persistedAnalysis);
          return persistedAnalysis;
        } catch (e) {
          rethrow;
        }
      }
    } catch (e) {
      rethrow;
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

  Future<AnalysisData?> analyzeTextWithModel(
    String plainText,
    Map<String, String> parameterValues,
  ) async {
    try {
      final gemini = ref.read(geminiControllerProvider.notifier);
      final extractionResponse = await gemini.prompt(
        [
          Part.text(extractionPrompt),
          Part.text(plainText),
        ],
      );

      Map<String, dynamic> extractedData = {};
      final sanitizedOutput = sanitizeJson(extractionResponse);
      try {
        extractedData = json.decode(sanitizedOutput) as Map<String, dynamic>;
      } catch (e) {
        extractedData = {};
      }

      final exams = extractedData;

      final userProfile = await ref.read(userControllerProvider.future);
      // Debug log

      int age = 0;
      final birthDate = _parseBirthDate(userProfile?.birthDate);
      if (birthDate != null) {
        age = _calculateAge(birthDate);
      }
      // Debug log

      final gender = (userProfile?.gender ?? 'MALE').toLowerCase();

      final finalLDL = _getValueFromExamMultiple(
              exams, ['ldl', 'colesterol ldl directo']) ??
          (parameterValues['ldl'] != null && parameterValues['ldl']!.isNotEmpty
              ? num.tryParse(parameterValues['ldl']!)?.toDouble() ?? 0.0
              : 0.0);
      final finalTriglycerides = _getValueFromExamMultiple(
              exams, ['trigliceridos', 'triglicéridos']) ??
          (parameterValues['triglicéridos'] != null &&
                  parameterValues['triglicéridos']!.isNotEmpty
              ? num.tryParse(parameterValues['triglicéridos']!)?.toDouble() ??
                  0.0
              : 0.0);
      final finalFastingGlucose =
          _getValueFromExamMultiple(exams, ['glucosa en ayunas', 'glucosa']) ??
              (parameterValues['glucosa'] != null &&
                      parameterValues['glucosa']!.isNotEmpty
                  ? num.tryParse(parameterValues['glucosa']!)?.toDouble() ?? 0.0
                  : 0.0);
      final finalCreatinine = _getValueFromExamMultiple(
              exams, ['creatinina']) ??
          (parameterValues['creatinina'] != null &&
                  parameterValues['creatinina']!.isNotEmpty
              ? num.tryParse(parameterValues['creatinina']!)?.toDouble() ?? 0.0
              : 0.0);
      final finalSystolicPressure =
          _getValueFromExamMultiple(exams, ['presión arterial sistólica']) ??
              (parameterValues['presión arterial sistólica'] != null &&
                      parameterValues['presión arterial sistólica']!.isNotEmpty
                  ? num.tryParse(parameterValues['presión arterial sistólica']!)
                          ?.toDouble() ??
                      0.0
                  : 0.0);
      final finalDiastolicPressure = _getValueFromExamMultiple(
              exams, ['presión arterial diastólica']) ??
          (parameterValues['presión arterial diastólica'] != null &&
                  parameterValues['presión arterial diastólica']!.isNotEmpty
              ? num.tryParse(parameterValues['presión arterial diastólica']!)
                      ?.toDouble() ??
                  0.0
              : 0.0);

      final finalHbA1c = _getValueFromExamMultiple(exams, ['hba1c']) ??
          (parameterValues['hba1c'] != null &&
                  parameterValues['hba1c']!.isNotEmpty
              ? num.tryParse(parameterValues['hba1c']!)?.toDouble() ?? 0.0
              : 0.0);

      // Llamadas a los modelos premium:
      final obesityPrediction =
          await ref.read(apiControllerProvider.notifier).getObesityPrediction(
                userProfile?.bmi ?? 0,
                finalLDL,
                finalTriglycerides,
                gender,
                age,
                userProfile?.isGeneticRiskObesity ?? false,
              );

      final diabetesPrediction =
          await ref.read(apiControllerProvider.notifier).getDiabetesPrediction(
                finalFastingGlucose,
                finalHbA1c,
                userProfile?.isGeneticRiskDiabetes ?? false,
                gender,
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
            gender,
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
          .replaceAll('valor_de_sexo', parseGender(gender))
          .replaceAll('valor_de_edad', age.toString());

      final analysisResponse = await gemini.prompt([
        Part.text(modifiedAnalyzePrompt),
        Part.text(plainText),
        Part.text(predictionsJson),
      ]);

      if (analysisResponse.isEmpty) {
        throw Exception('La respuesta del análisis está vacía');
      }

      final currentUser = ref.read(fireAuthControllerProvider).value?.user;
      if (currentUser != null) {
        final sanitizedOutput = sanitizeJson(analysisResponse);
        try {
          final persistedAnalysis = await ref
              .read(clinicalAnalysisControllerProvider.notifier)
              .createUserAnalysis(currentUser.uid, sanitizedOutput);
          state = AsyncData(persistedAnalysis);
          return persistedAnalysis;
        } catch (e) {
          rethrow;
        }
      }
    } catch (e) {
      rethrow;
    }

    return null;
  }
}
