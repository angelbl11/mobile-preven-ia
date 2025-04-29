import 'diagnosis.dart';
import 'exam_result.dart';
import 'model_prediction.dart';
import 'variables.dart';

class HealthAnalysis {
  final Map<String, ExamResult> exams;
  final Diagnosis diagnosis;
  final Variables variables;
  final Map<String, ModelPrediction> models;
  final String overallRiskLevel;
  final List<String> combinedRecommendations;

  HealthAnalysis({
    required this.exams,
    required this.diagnosis,
    required this.variables,
    required this.models,
    required this.overallRiskLevel,
    required this.combinedRecommendations,
  });

  factory HealthAnalysis.fromJson(Map<String, dynamic> json) {
    final models = json['models'] as Map<String, dynamic>;
    final modelPredictions = <String, ModelPrediction>{};

    models.forEach((key, value) {
      if (key != 'overall_risk_level' && key != 'combined_recommendations') {
        modelPredictions[key] =
            ModelPrediction.fromJson(value as Map<String, dynamic>);
      }
    });

    return HealthAnalysis(
      exams: Map<String, ExamResult>.from(
        (json['exams'] as Map<String, dynamic>).map(
          (key, value) =>
              MapEntry(key, ExamResult.fromJson(value as Map<String, dynamic>)),
        ),
      ),
      diagnosis: Diagnosis.fromJson(json['diagnosis'] as Map<String, dynamic>),
      variables: Variables.fromJson(json['variables'] as Map<String, dynamic>),
      models: modelPredictions,
      overallRiskLevel: models['overall_risk_level'] as String,
      combinedRecommendations:
          List<String>.from(models['combined_recommendations'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exams': exams.map((key, value) => MapEntry(key, value.toJson())),
      'diagnosis': diagnosis.toJson(),
      'variables': variables.toJson(),
      'models': {
        ...models.map((key, value) => MapEntry(key, value.toJson())),
        'overall_risk_level': overallRiskLevel,
        'combined_recommendations': combinedRecommendations,
      },
    };
  }
}
