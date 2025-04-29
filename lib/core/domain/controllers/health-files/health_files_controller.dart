import 'dart:io';

import 'package:mobile_preven_ia_app/core/data/repositories/health-files/providers/health_files_repository_provider.dart';
import 'package:mobile_preven_ia_app/core/domain/models/health_file.dart';
import 'package:mobile_preven_ia_app/core/domain/models/health_prediction.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'health_files_controller.g.dart';

@riverpod

/// [HealthFilesController] provider
class HealthFilesController extends _$HealthFilesController {
  @override
  Future<List<HealthFile>> build() async {
    return getHealthFiles();
  }

  Future<List<HealthFile>> getHealthFiles() async {
    final healthFilesRepository = ref.read(healthFilesRepositoryProvider);
    return healthFilesRepository.getHealthFiles();
  }

  Future<HealthFile> uploadHealthFile(File file) async {
    final healthFilesRepository = ref.read(healthFilesRepositoryProvider);
    return healthFilesRepository.uploadHealthFile(file);
  }

  Future<HealthPrediction> processHealthFile(
    String documentId,
    num? systolic,
    num? diastolic,
  ) async {
    final healthFilesRepository = ref.read(healthFilesRepositoryProvider);
    return healthFilesRepository.processHealthFile(
        documentId, systolic, diastolic);
  }
}
