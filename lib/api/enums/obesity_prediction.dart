class ObesityPrediction {
  final String riskCategory;
  final num probability;
  final bool isObese;

  ObesityPrediction({
    required this.riskCategory,
    required this.probability,
    required this.isObese,
  });

  factory ObesityPrediction.fromJson(Map<String, dynamic> json) {
    return ObesityPrediction(
      riskCategory: json['risk_category'] as String,
      probability: json['probability'] as num,
      isObese: json['is_obese'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'risk_category': riskCategory,
      'probability': probability,
      'is_obese': isObese,
    };
  }
}
