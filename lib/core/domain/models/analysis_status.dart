enum AnalysisStatus {
  observation,
  acceptable,
  critical;

  factory AnalysisStatus.fromString(String value) {
    return AnalysisStatus.values.firstWhere(
      (status) => status.name.toUpperCase() == value.toUpperCase(),
      orElse: () => AnalysisStatus.observation,
    );
  }
}

extension AnalysisStatusExtension on AnalysisStatus {
  String get displayName {
    switch (this) {
      case AnalysisStatus.observation:
        return 'Seguimiento';
      case AnalysisStatus.acceptable:
        return 'Aceptable';
      case AnalysisStatus.critical:
        return 'Crítico';
    }
  }
}
