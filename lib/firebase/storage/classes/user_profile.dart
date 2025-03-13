class UserProfile {
  final String birthDate;
  final double bmi;
  final String gender;
  final double height;
  final bool isGeneticRiskDiabetes;
  final bool isGeneticRiskHypertension;
  final bool isGeneticRiskObesity;
  final String lastName;
  final String maternalLastName;
  final String name;
  final String nextStep;
  final double weight;
  final bool monitorGlucose;
  final bool monitorLdl;
  final bool monitorWeight;
  final String? photoUrl;

  UserProfile({
    required this.birthDate,
    required this.bmi,
    required this.gender,
    required this.height,
    required this.isGeneticRiskDiabetes,
    required this.isGeneticRiskHypertension,
    required this.isGeneticRiskObesity,
    required this.lastName,
    required this.maternalLastName,
    required this.name,
    required this.nextStep,
    required this.weight,
    required this.monitorGlucose,
    required this.monitorLdl,
    required this.monitorWeight,
    this.photoUrl,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      birthDate: map['birth_date'] as String? ?? '',
      bmi: (map['bmi'] as num?)?.toDouble() ?? 0.0,
      gender: map['gender'] as String? ?? '',
      height: (map['height'] as num?)?.toDouble() ?? 0.0,
      isGeneticRiskDiabetes: map['is_genetic_risk_diabetes'] as bool? ?? false,
      isGeneticRiskHypertension:
          map['is_genetic_risk_hypertension'] as bool? ?? false,
      isGeneticRiskObesity: map['is_genetic_risk_obesity'] as bool? ?? false,
      lastName: map['last_name'] as String? ?? '',
      maternalLastName: map['maternal_last_name'] as String? ?? '',
      name: map['name'] as String? ?? '',
      nextStep: map['next_step'] as String? ?? '',
      weight: (map['weight'] as num?)?.toDouble() ?? 0.0,
      monitorGlucose: map['monitor_glucose'] as bool? ?? false,
      monitorLdl: map['monitor_ldl'] as bool? ?? false,
      monitorWeight: map['monitor_weight'] as bool? ?? false,
      photoUrl: map['photo_url'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'birth_date': birthDate,
      'bmi': bmi,
      'gender': gender,
      'height': height,
      'is_genetic_risk_diabetes': isGeneticRiskDiabetes,
      'is_genetic_risk_hypertension': isGeneticRiskHypertension,
      'is_genetic_risk_obesity': isGeneticRiskObesity,
      'last_name': lastName,
      'maternal_last_name': maternalLastName,
      'name': name,
      'next_step': nextStep,
      'weight': weight,
      'monitor_glucose': monitorGlucose,
      'monitor_ldl': monitorLdl,
      'monitor_weight': monitorWeight,
      'photo_url': photoUrl,
    };
  }
}
