class AnalysisData {
  final String id;
  final String userId;
  final DateTime createdAt;
  final Map<String, dynamic> exams;
  final Map<String, dynamic> diagnosis;
  final Map<String, dynamic> variables;

  AnalysisData({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.exams,
    required this.diagnosis,
    required this.variables,
  });

  factory AnalysisData.fromMap(Map<String, dynamic> map) {
    return AnalysisData(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      exams: map['exams'] as Map<String, dynamic>,
      diagnosis: map['diagnosis'] as Map<String, dynamic>,
      variables: map['variables'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'exams': exams,
      'diagnosis': diagnosis,
      'variables': variables,
    };
  }
}
