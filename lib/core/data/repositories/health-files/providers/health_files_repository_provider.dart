import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/core/data/repositories/health-files/health_files_repository.dart';
import 'package:mobile_preven_ia_app/core/providers/network/custom_dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'health_files_repository_provider.g.dart';

@riverpod

/// [HealthFilesRepository] provider
HealthFilesRepository healthFilesRepository(
  Ref ref,
) {
  final dioController = ref.watch(customDioControllerProvider);

  return HealthFilesRepository(
    dio: dioController,
  );
}
