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
      ldl: map['monitor_ldl'] as bool? ?? false,
      glucose: map['monitor_glucose'] as bool? ?? false,
      weight: map['monitor_weight'] as bool? ?? false,
    );
  }

  Map<String, bool> toMap() {
    return {
      'monitor_ldl': ldl,
      'monitor_glucose': glucose,
      'monitor_weight': weight,
    };
  }
}
