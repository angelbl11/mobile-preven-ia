import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/core/data/repositories/weight/weight_repository.dart';
import 'package:mobile_preven_ia_app/core/providers/network/custom_dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'weight_repository_provider.g.dart';

@riverpod

/// [WeightRepository] provider
WeightRepository weightRepository(
  Ref ref,
) {
  final dioController = ref.watch(customDioControllerProvider);

  return WeightRepository(
    dio: dioController,
  );
}
