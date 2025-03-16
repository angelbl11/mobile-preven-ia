class MonitoringPreferences {
  final bool ldl;
  final bool glucose;
  final bool weight;

  MonitoringPreferences({
    required this.ldl,
    required this.glucose,
    required this.weight,
  });

  factory MonitoringPreferences.fromMap(Map<String, dynamic> map) {
    return MonitoringPreferences(
      ldl: map['ldl'] as bool? ?? false,
      glucose: map['glucose'] as bool? ?? false,
      weight: map['weight'] as bool? ?? false,
    );
  }

  Map<String, bool> toMap() {
    return {
      'ldl': ldl,
      'glucose': glucose,
      'weight': weight,
    };
  }
}
