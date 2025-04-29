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
