import 'package:mobile_preven_ia_app/core/domain/models/health_file.dart';
import 'package:mobile_preven_ia_app/core/domain/models/health_prediction.dart';
import 'package:mobile_preven_ia_app/core/domain/models/analysis_status.dart';
import 'dart:convert';

/// Mapper for health files
class HealthFilesMapper {
  /// Convert API response to list of health files
  static List<HealthFile> fromResponseHealthFiles(dynamic response) {
    if (response is Map<String, dynamic>) {
      // If response is a map, check if it has a data field
      final data = response['data'];
      if (data is List) {
        return _mapHealthFiles(data);
      }
      // If no data field or data is not a list, return empty list
      return [];
    } else if (response is List) {
      return _mapHealthFiles(response);
    }
    // If response is neither Map nor List, return empty list
    return [];
  }

  static HealthFile fromResponseHealthFile(dynamic response) {
    if (response is Map<String, dynamic>) {
      final data = response['data'];
      if (data is Map<String, dynamic>) {
        return _mapHealthFile(data);
      }
      // If no data field or data is not a map, throw exception
      throw Exception('Invalid response format for single health file');
    }
    // If response is not a Map, throw exception
    throw Exception('Invalid response format for single health file');
  }

  static List<HealthFile> _mapHealthFiles(List<dynamic> files) {
    return files
        .map((file) => HealthFile(
              id: file['id'] as String,
              fileName: file['fileName'] as String,
              uploadDate: DateTime.parse(file['uploadDate'] as String),
              processedText: file['processedText'] as String,
              geminiAnalysis: _parseGeminiAnalysis(file['geminiAnalysis']),
              documentId: file['documentId'] as String,
            ))
        .where((file) {
      final state = file.geminiAnalysis.analysis?.diagnosis.globalStatus;
      return state != null &&
          (state == AnalysisStatus.critical ||
              state == AnalysisStatus.observation ||
              state == AnalysisStatus.acceptable);
    }).toList();
  }

  static HealthFile _mapHealthFile(Map<String, dynamic> file) {
    return HealthFile(
      id: file['id']?.toString() ?? '',
      fileName: file['fileName']?.toString() ?? '',
      uploadDate: file['uploadDate'] != null
          ? DateTime.parse(file['uploadDate'].toString())
          : DateTime.now(),
      processedText: file['processedText']?.toString() ?? '',
      geminiAnalysis: _parseGeminiAnalysis(file['geminiAnalysis']),
      documentId: file['documentId']?.toString() ?? '',
    );
  }

  static HealthPrediction _parseGeminiAnalysis(dynamic geminiAnalysis) {
    if (geminiAnalysis == null) {
      return HealthPrediction(id: null, documentId: null, analysis: null);
    }

    if (geminiAnalysis is Map<String, dynamic>) {
      return HealthPrediction.fromJson(geminiAnalysis);
    }

    if (geminiAnalysis is String) {
      try {
        // Clean the string by removing the markdown code block markers
        final cleanAnalysisString =
            geminiAnalysis.replaceAll('```json\n', '').replaceAll('\n```', '');
        final Map<String, dynamic> jsonMap = jsonDecode(cleanAnalysisString);

        // Convert the risk level string to enum
        if (jsonMap['analysis'] != null &&
            jsonMap['analysis']['risk_level'] != null) {
          jsonMap['analysis']['risk_level'] =
              jsonMap['analysis']['risk_level'].toString().toLowerCase();
        }

        return HealthPrediction.fromJson(jsonMap);
      } catch (e) {
        return HealthPrediction(id: null, documentId: null, analysis: null);
      }
    }

    return HealthPrediction(id: null, documentId: null, analysis: null);
  }
}
