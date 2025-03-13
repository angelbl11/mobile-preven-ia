class WeightHistory {
  final String id;
  final double weight;
  final double bmi;
  final DateTime createdAt;

  WeightHistory({
    required this.id,
    required this.weight,
    required this.bmi,
    required this.createdAt,
  });

  factory WeightHistory.fromMap(Map<String, dynamic> map) {
    return WeightHistory(
      id: map['id'].toString(),
      weight: double.parse(map['weight'].toString()),
      bmi: double.parse(map['bmi'].toString()),
      createdAt: map['created_at'] is DateTime
          ? map['created_at']
          : DateTime.parse(map['created_at'].toString()),
    );
  }
}
