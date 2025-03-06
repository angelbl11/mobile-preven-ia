class DiabetesPrediction {
  final String riskCategory;
  final num probability;
  final bool isDiabetic;

  DiabetesPrediction({
    required this.riskCategory,
    required this.probability,
    required this.isDiabetic,
  });

  factory DiabetesPrediction.fromJson(Map<String, dynamic> json) {
    return DiabetesPrediction(
      riskCategory: json['risk_category'] as String,
      probability: json['probability'] as num,
      isDiabetic: json['is_diabetic'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'risk_category': riskCategory,
      'probability': probability,
      'is_diabetic': isDiabetic,
    };
  }
}
