import 'package:mobile_preven_ia_app/core/data/repositories/weight/providers/weight_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'weight_controller.g.dart';

@riverpod

/// [WeightController] provider
class WeightController extends _$WeightController {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> updateWeight(double weight) async {
    final weightRepository = ref.read(weightRepositoryProvider);
    return weightRepository.updateWeight(weight);
  }
}
