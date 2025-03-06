import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/api/providers/custom_dio_provider.dart';
import 'package:mobile_preven_ia_app/api/repositories/api_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_repository_provider.g.dart';

@riverpod

/// [ApiRepository] provider
ApiRepository apiRepository(
  Ref ref,
) {
  final dio = ref.read(customDioControllerProvider);

  return ApiRepository(
    dio: dio.dio,
  );
}
