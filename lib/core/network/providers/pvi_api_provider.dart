import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/core/network/providers/custom_dio_provider.dart';
import 'package:pvi_api/pvi_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pvi_api_provider.g.dart';

@Riverpod(keepAlive: true)

/// Provider for [SkApi]
PviApi pviApi(
  Ref ref,
) {
  final customDio = ref.read(customDioControllerProvider);
  final pviApi = PviApi(
    dio: customDio.dio,
  );

  return pviApi;
}
