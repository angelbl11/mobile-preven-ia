import 'package:mobile_preven_ia_app/core/domain/models/health_prediction.dart';

class HealthFile {
  final String id;
  final String fileName;
  final DateTime uploadDate;
  final String processedText;
  final HealthPrediction geminiAnalysis;
  final String documentId;

  HealthFile({
    required this.id,
    required this.fileName,
    required this.uploadDate,
    required this.processedText,
    required this.geminiAnalysis,
    required this.documentId,
  });
}
