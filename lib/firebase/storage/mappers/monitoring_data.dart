class MonitoringData {
  final DateTime date;
  final double glucose;
  final double ldl;

  MonitoringData({
    required this.date,
    required this.glucose,
    required this.ldl,
  });

  // Factory constructor para mapear desde un Map<String, dynamic>
  factory MonitoringData.fromMap(Map<String, dynamic> map) {
    return MonitoringData(
      date: map['date'] is DateTime
          ? map['date']
          : DateTime.parse(map['date'].toString()),
      glucose: map['glucose'] == null
          ? 0.0
          : double.tryParse(map['glucose'].toString()) ?? 0.0,
      ldl: map['ldl'] == null
          ? 0.0
          : double.tryParse(map['ldl'].toString()) ?? 0.0,
    );
  }
}
