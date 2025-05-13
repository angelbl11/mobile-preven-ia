import 'package:mobile_preven_ia_app/core/providers/network/custom_dio.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'custom_dio_provider.g.dart';

@Riverpod(keepAlive: true)

/// The controller for the custom dio.
class CustomDioController extends _$CustomDioController {
  @override
  CustomDio build() {
    return CustomDio();
  }

  /// Update token
  void updateToken(String token) {
    state.updateToken(token);
  }
}
