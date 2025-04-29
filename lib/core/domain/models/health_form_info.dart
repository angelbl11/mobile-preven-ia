class HealthFormInfo {
  final String? name;
  final DateTime? dateOfBirth;
  final PersonalInfo? personalInfo;
  final Lifestyle? lifestyle;
  final FamilyHistory? familyHistory;
  final Monitoring? monitoring;
  final num step;
  final bool completed;

  HealthFormInfo({
    this.name,
    this.dateOfBirth,
    this.personalInfo,
    this.lifestyle,
    this.familyHistory,
    this.monitoring,
    required this.step,
    required this.completed,
  });

  /// Creates an empty health form with default values
  factory HealthFormInfo.empty() {
    return HealthFormInfo(
      name: '',
      dateOfBirth: DateTime.now(),
      personalInfo: PersonalInfo(
        age: 0,
        gender: '',
        height: 0,
        weight: 0,
        bmi: 0,
      ),
      step: 0,
      completed: false,
    );
  }

  /// Converts the model to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'personalInfo': personalInfo?.toJson(),
      'lifestyle': lifestyle?.toJson(),
      'familyHistory': familyHistory?.toJson(),
      'monitoring': monitoring?.toJson(),
      'step': step,
      'completed': completed,
    };
  }

  /// Creates a model from a JSON map
  factory HealthFormInfo.fromJson(Map<String, dynamic> json) {
    return HealthFormInfo(
      name: json['name'] as String? ?? '',
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : DateTime.now(),
      personalInfo: PersonalInfo.fromJson(
          json['personalInfo'] as Map<String, dynamic>? ?? {}),
      lifestyle: json['lifestyle'] != null
          ? Lifestyle.fromJson(json['lifestyle'] as Map<String, dynamic>)
          : null,
      familyHistory: json['familyHistory'] != null
          ? FamilyHistory.fromJson(
              json['familyHistory'] as Map<String, dynamic>)
          : null,
      monitoring: json['monitoring'] != null
          ? Monitoring.fromJson(json['monitoring'] as Map<String, dynamic>)
          : null,
      step: json['step'] as num? ?? 0,
      completed: json['completed'] as bool? ?? false,
    );
  }
}

class PersonalInfo {
  final int age;
  final String gender;
  final double height;
  final double weight;
  final double? bmi;

  PersonalInfo({
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    this.bmi,
  });

  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'gender': gender,
      'height': height,
      'weight': weight,
      'bmi': bmi,
    };
  }

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      age: json['age'] as int? ?? 0,
      gender: json['gender'] as String? ?? '',
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      bmi: (json['bmi'] as num?)?.toDouble(),
    );
  }
}

class Lifestyle {
  final String physicalActivity;
  final int smoker;
  final String alcoholConsumption;

  Lifestyle({
    required this.physicalActivity,
    required this.smoker,
    required this.alcoholConsumption,
  });

  Map<String, dynamic> toJson() {
    return {
      'physicalActivity': physicalActivity,
      'smoker': smoker,
      'alcoholConsumption': alcoholConsumption,
    };
  }

  factory Lifestyle.fromJson(Map<String, dynamic> json) {
    return Lifestyle(
      physicalActivity: json['physicalActivity'] as String? ?? '',
      smoker: json['smoker'] as int? ?? 0,
      alcoholConsumption: json['alcoholConsumption'] as String? ?? '',
    );
  }
}

class FamilyHistory {
  final int diabetes;
  final int obesity;
  final int hypertension;

  FamilyHistory({
    required this.diabetes,
    required this.obesity,
    required this.hypertension,
  });

  Map<String, dynamic> toJson() {
    return {
      'diabetes': diabetes,
      'obesity': obesity,
      'hypertension': hypertension,
    };
  }

  factory FamilyHistory.fromJson(Map<String, dynamic> json) {
    return FamilyHistory(
      diabetes: json['diabetes'] as int? ?? 0,
      obesity: json['obesity'] as int? ?? 0,
      hypertension: json['hypertension'] as int? ?? 0,
    );
  }
}

class Monitoring {
  final bool diabetes;
  final bool obesity;
  final bool hypertension;

  Monitoring({
    required this.diabetes,
    required this.obesity,
    required this.hypertension,
  });

  Map<String, dynamic> toJson() {
    return {
      'diabetes': diabetes,
      'obesity': obesity,
      'hypertension': hypertension,
    };
  }

  factory Monitoring.fromJson(Map<String, dynamic> json) {
    return Monitoring(
      diabetes: json['diabetes'] as bool? ?? false,
      obesity: json['obesity'] as bool? ?? false,
      hypertension: json['hypertension'] as bool? ?? false,
    );
  }
}
