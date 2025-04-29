enum RiskLevel {
  alto,
  bajo,
  moderado;

  String toJson() => name;

  static RiskLevel fromJson(String json) {
    return RiskLevel.values.firstWhere(
      (e) => e.name == json.toLowerCase(),
      orElse: () => RiskLevel.bajo,
    );
  }
}

extension RiskLevelExtension on RiskLevel {
  String get displayName {
    switch (this) {
      case RiskLevel.alto:
        return 'Alto';
      case RiskLevel.bajo:
        return 'Bajo';
      case RiskLevel.moderado:
        return 'Moderado';
    }
  }
}
