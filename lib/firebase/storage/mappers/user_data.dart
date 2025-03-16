class UserData {
  final String name;
  final String lastName;
  final String maternalLastName;
  final String? birthDate;
  final double? bmi;
  final bool isGeneticRiskObesity;
  final bool isGeneticRiskDiabetes;
  final bool isGeneticRiskHypertension;
  final bool monitorLdl;
  final bool monitorGlucose;
  final bool monitorWeight;

  UserData({
    required this.name,
    required this.lastName,
    required this.maternalLastName,
    this.birthDate,
    this.bmi,
    this.isGeneticRiskObesity = false,
    this.isGeneticRiskDiabetes = false,
    this.isGeneticRiskHypertension = false,
    this.monitorLdl = false,
    this.monitorGlucose = false,
    this.monitorWeight = false,
  });

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      name: map['name'] as String? ?? '',
      lastName: map['last_name'] as String? ?? '',
      maternalLastName: map['maternal_last_name'] as String? ?? '',
      birthDate: map['birth_date'] as String?,
      bmi: map['bmi'] as double?,
      isGeneticRiskObesity: map['is_genetic_risk_obesity'] as bool? ?? false,
      isGeneticRiskDiabetes: map['is_genetic_risk_diabetes'] as bool? ?? false,
      isGeneticRiskHypertension:
          map['is_genetic_risk_hypertension'] as bool? ?? false,
      monitorLdl: map['monitor_ldl'] as bool? ?? false,
      monitorGlucose: map['monitor_glucose'] as bool? ?? false,
      monitorWeight: map['monitor_weight'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'last_name': lastName,
      'maternal_last_name': maternalLastName,
      'birth_date': birthDate,
      'bmi': bmi,
      'is_genetic_risk_obesity': isGeneticRiskObesity,
      'is_genetic_risk_diabetes': isGeneticRiskDiabetes,
      'is_genetic_risk_hypertension': isGeneticRiskHypertension,
      'monitor_ldl': monitorLdl,
      'monitor_glucose': monitorGlucose,
      'monitor_weight': monitorWeight,
    };
  }
}
