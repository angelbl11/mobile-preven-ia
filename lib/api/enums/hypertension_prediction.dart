class HypertensionPrediction {
  final String riskCategory;
  final num probability;
  final bool isHypertensive;

  HypertensionPrediction({
    required this.riskCategory,
    required this.probability,
    required this.isHypertensive,
  });

  factory HypertensionPrediction.fromJson(Map<String, dynamic> json) {
    return HypertensionPrediction(
      riskCategory: json['risk_category'] as String,
      probability: json['probability'] as num,
      isHypertensive: json['is_hypertensive'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'risk_category': riskCategory,
      'probability': probability,
      'is_hypertensive': isHypertensive,
    };
  }
}
