import 'package:mobile_preven_ia_app/core/data/mappers/health_files_mapper.dart';
import 'package:mobile_preven_ia_app/core/data/mappers/health_analysis_mapper.dart';
import 'package:mobile_preven_ia_app/core/domain/models/health_file.dart';
import 'package:mobile_preven_ia_app/core/domain/models/health_prediction.dart';
import 'package:mobile_preven_ia_app/core/providers/network/custom_dio.dart';
import 'package:dio/dio.dart';
import 'dart:io';

/// HealthFilesRepository
class HealthFilesRepository {
  /// Constructor
  HealthFilesRepository({
    required this.dio,
  });

  /// Dio client
  final CustomDio dio;

  Future<List<HealthFile>> getHealthFiles() async {
    try {
      final response = await dio.dio.get('/v1/pdf/get-files');

      if (response.statusCode != 200) {
        throw Exception('Failed to load health files: ${response.statusCode}');
      }

      return HealthFilesMapper.fromResponseHealthFiles(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<HealthFile> uploadHealthFile(File file) async {
    try {
      final formData = FormData.fromMap({
        'pdf': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      final response = await dio.dio.post(
        '/v1/pdf/upload-file',
        data: formData,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to upload health file: ${response.statusCode}');
      }

      return HealthFilesMapper.fromResponseHealthFile(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<HealthPrediction> processHealthFile(
    String documentId,
    num? systolic,
    num? diastolic,
  ) async {
    try {
      final response = await dio.dio.post('/v1/pdf/process-analysis', data: {
        'documentId': documentId,
        'systolic_bp': systolic,
        'diastolic_bp': diastolic,
      });

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to process health file: ${response.statusCode}');
      }

      return HealthAnalysisMapper.fromResponse(response.data);
    } catch (e) {
      print('Error processing response: $e');
      rethrow;
    }
  }
}
