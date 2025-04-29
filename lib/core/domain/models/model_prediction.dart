class ModelPrediction {
  final String riskLevel;
  final double probability;
  final String prediction;
  final Map<String, double> modelProbabilities;

  ModelPrediction({
    required this.riskLevel,
    required this.probability,
    required this.prediction,
    required this.modelProbabilities,
  });

  factory ModelPrediction.fromJson(Map<String, dynamic> json) {
    return ModelPrediction(
      riskLevel: json['risk_level'] as String,
      probability: (json['probability'] as num).toDouble(),
      prediction: json['prediction'] as String,
      modelProbabilities: Map<String, double>.from(
        (json['model_probabilities'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(key, (value as num).toDouble()),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'risk_level': riskLevel,
      'probability': probability,
      'prediction': prediction,
      'model_probabilities': modelProbabilities,
    };
  }
}
