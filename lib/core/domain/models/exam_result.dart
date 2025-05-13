import 'exam_range.dart';

class ExamResult {
  final String value;
  final ExamRange range;
  final String healthyRange;
  final String explanation;

  ExamResult({
    required this.value,
    required this.range,
    required this.healthyRange,
    required this.explanation,
  });

  factory ExamResult.fromJson(Map<String, dynamic> json) {
    return ExamResult(
      value: json['value'] as String,
      range: ExamRange.fromString(json['range'] as String),
      healthyRange: json['healthy_range'] as String,
      explanation: json['explanation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'range': range.name.toUpperCase(),
      'healthy_range': healthyRange,
      'explanation': explanation,
    };
  }
}
