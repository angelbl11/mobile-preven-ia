import 'dart:convert';
import 'package:mobile_preven_ia_app/core/domain/models/health_prediction.dart';
import 'package:mobile_preven_ia_app/core/domain/models/health_analysis.dart';
import 'package:mobile_preven_ia_app/core/domain/models/exam_result.dart';
import 'package:mobile_preven_ia_app/core/domain/models/diagnosis.dart';
import 'package:mobile_preven_ia_app/core/domain/models/variables.dart';
import 'package:mobile_preven_ia_app/core/domain/models/model_prediction.dart';
import 'package:mobile_preven_ia_app/core/domain/models/exam_range.dart';
import 'package:mobile_preven_ia_app/core/domain/models/analysis_status.dart';

class HealthAnalysisMapper {
  static HealthPrediction fromResponse(Map<String, dynamic> response) {
    final data = response['data'] as Map<String, dynamic>;
    final analysisString = data['analysis'] as String;

    // Clean the string by removing the markdown code block markers
    final cleanAnalysisString =
        analysisString.replaceAll('```json\n', '').replaceAll('\n```', '');

    final analysisJson =
        jsonDecode(cleanAnalysisString) as Map<String, dynamic>;

    return HealthPrediction(
      id: data['id'] as String?,
      documentId: data['documentId'] as String?,
      analysis: _mapAnalysis(analysisJson),
    );
  }

  static HealthAnalysis _mapAnalysis(Map<String, dynamic> json) {
    return HealthAnalysis(
      exams: _mapExams(json['exams'] as Map<String, dynamic>),
      diagnosis: _mapDiagnosis(json['diagnosis'] as Map<String, dynamic>),
      variables: _mapVariables(json['variables'] as Map<String, dynamic>),
      models: _mapModels(json['models'] as Map<String, dynamic>),
      overallRiskLevel: json['models']['overall_risk_level'] as String,
      combinedRecommendations:
          List<String>.from(json['models']['combined_recommendations'] as List),
    );
  }

  static Map<String, ExamResult> _mapExams(Map<String, dynamic> exams) {
    return exams.map((key, value) {
      final exam = value as Map<String, dynamic>;
      return MapEntry(
          key,
          ExamResult(
            value: exam['value'] as String,
            range: ExamRange.fromString(exam['range'] as String),
            healthyRange: exam['healthy_range'] as String,
            explanation: exam['explanation'] as String,
          ));
    });
  }

  static Diagnosis _mapDiagnosis(Map<String, dynamic> diagnosis) {
    return Diagnosis(
      globalStatus:
          AnalysisStatus.fromString(diagnosis['global_status'] as String),
      observations: diagnosis['observations'] as String,
    );
  }

  static Variables _mapVariables(Map<String, dynamic> variables) {
    return Variables(
      imc: variables['IMC'] != null
          ? double.tryParse(variables['IMC'].toString())
          : null,
      sexo: variables['sexo'] as String?,
      edad: variables['edad'] as String?,
    );
  }

  static Map<String, ModelPrediction> _mapModels(Map<String, dynamic> models) {
    final result = <String, ModelPrediction>{};

    models.forEach((key, value) {
      if (key != 'overall_risk_level' && key != 'combined_recommendations') {
        final model = value as Map<String, dynamic>;
        result[key] = ModelPrediction(
          riskLevel: model['risk_level'] as String,
          probability: (model['probability'] as num).toDouble(),
          prediction: model['prediction'] as String,
          modelProbabilities: Map<String, double>.from(
            (model['model_probabilities'] as Map<String, dynamic>).map(
              (k, v) => MapEntry(k, (v as num).toDouble()),
            ),
          ),
        );
      }
    });

    return result;
  }
}
