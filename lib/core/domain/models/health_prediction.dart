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
    return HealthPrediction(
      id: json['id'] as String?,
      documentId: json['documentId'] as String?,
      analysis: json['analysis'] != null
          ? HealthAnalysis.fromJson(json['analysis'] as Map<String, dynamic>)
          : null,
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
