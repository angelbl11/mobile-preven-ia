import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/core/data/repositories/pvi_repository.dart';
import 'package:mobile_preven_ia_app/core/network/providers/pvi_api_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pvi_repository_provider.g.dart';

@riverpod

/// [PviRepository] provider
PviRepository pviRepository(
  Ref ref,
) {
  final pviApi = ref.read(pviApiProvider);

  return PviRepository(
    pviApi: pviApi,
  );
}
