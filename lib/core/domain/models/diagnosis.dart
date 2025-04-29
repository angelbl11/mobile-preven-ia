import 'analysis_status.dart';

class Diagnosis {
  final AnalysisStatus globalStatus;
  final String observations;

  Diagnosis({
    required this.globalStatus,
    required this.observations,
  });

  factory Diagnosis.fromJson(Map<String, dynamic> json) {
    return Diagnosis(
      globalStatus: AnalysisStatus.fromString(json['global_status'] as String),
      observations: json['observations'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'global_status': globalStatus.name.toUpperCase(),
      'observations': observations,
    };
  }
}
