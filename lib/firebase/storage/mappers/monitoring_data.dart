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
      glucose: double.parse(map['glucose'].toString()),
      ldl: double.parse(map['ldl'].toString()),
    );
  }
}
