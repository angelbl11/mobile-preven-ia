class AnalysisData {
  final String id;
  final String userId;
  final DateTime createdAt;
  final Map<String, dynamic> exams;
  final Map<String, dynamic> diagnosis;
  final Map<String, dynamic> variables;
  final Map<String, dynamic> models;

  AnalysisData({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.exams,
    required this.diagnosis,
    required this.variables,
    required this.models,
  });

  factory AnalysisData.fromMap(Map<String, dynamic> map) {
    return AnalysisData(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? '',
      createdAt: DateTime.tryParse(map['created_at']?.toString() ?? '') ??
          DateTime.now(),
      exams: (map['exams'] as Map<String, dynamic>?) ?? {},
      diagnosis: (map['diagnosis'] as Map<String, dynamic>?) ??
          {
            'global_status': 'ACCEPTABLE',
            'observations': '',
          },
      variables: (map['variables'] as Map<String, dynamic>?) ?? {},
      models: (map['models'] as Map<String, dynamic>?) ??
          {
            'diabetes': {
              'risk': 'no_aplicable',
              'probability': -1,
            },
            'hipertension': {
              'risk': 'no_aplicable',
              'probability': -1,
            },
            'obesidad': {
              'risk': 'no_aplicable',
              'probability': -1,
            },
          },
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
      'models': models,
    };
  }
}
