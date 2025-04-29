import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/core/data/repositories/health-form/health_form_repository.dart';
import 'package:mobile_preven_ia_app/core/providers/network/custom_dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'health_form_repository_provider.g.dart';

@riverpod

/// [HealthFormRepository] provider
HealthFormRepository healthFormRepository(Ref ref) {
  final dioController = ref.watch(customDioControllerProvider);

  return HealthFormRepository(
    dio: dioController,
  );
}
