import 'package:mobile_preven_ia_app/core/data/providers/pvi_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pvi_controller.g.dart';

@riverpod

/// [PviController] provider
class PviController extends _$PviController {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> login({
    required String phoneNumber,
    required String password,
  }) async {
    await ref.read(pviRepositoryProvider).login(
          phoneNumber: phoneNumber,
          password: password,
        );
  }
}
