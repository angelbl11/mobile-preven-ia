import 'health_analysis.dart';

class HealthPrediction {
  final String? id;
  final String? documentId;
  final HealthAnalysis? analysis;

  HealthPrediction({
    this.id,
    this.documentId,
    this.analysis,
  });

  factory HealthPrediction.fromJson(Map<String, dynamic> json) {
    // If the JSON has an 'analysis' field, use that
    if (json.containsKey('analysis')) {
      return HealthPrediction(
        id: json['id'] as String?,
        documentId: json['documentId'] as String?,
        analysis: json['analysis'] != null
            ? HealthAnalysis.fromJson(json['analysis'] as Map<String, dynamic>)
            : null,
      );
    }

    // If the JSON is the analysis itself, create a HealthAnalysis directly
    return HealthPrediction(
      id: null,
      documentId: null,
      analysis: HealthAnalysis.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'analysis': analysis?.toJson(),
    };
  }
}
