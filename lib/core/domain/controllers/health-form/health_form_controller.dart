import 'package:mobile_preven_ia_app/core/data/repositories/health-form/providers/health_form_repository_provider.dart';
import 'package:mobile_preven_ia_app/core/domain/models/health_form_info.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'health_form_controller.g.dart';

@riverpod

/// [HealthFormController] provider
class HealthFormController extends _$HealthFormController {
  @override
  Future<HealthFormInfo> build() async {
    return getHealthForm();
  }

  Future<HealthFormInfo> getHealthForm() async {
    try {
      final healthFormRepository = ref.read(healthFormRepositoryProvider);
      final response = await healthFormRepository.getHealthForm();

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateHealthForm(HealthFormInfo healthFormInfo) async {
    try {
      final healthFormRepository = ref.read(healthFormRepositoryProvider);
      return healthFormRepository.updateHealthForm(healthFormInfo);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateStep(num step) async {
    try {
      final currentState = state.value;
      if (currentState == null) return;

      final updatedForm = HealthFormInfo(
        name: currentState.name,
        dateOfBirth: currentState.dateOfBirth,
        personalInfo: currentState.personalInfo,
        lifestyle: currentState.lifestyle,
        familyHistory: currentState.familyHistory,
        monitoring: currentState.monitoring,
        step: step,
        completed: currentState.completed,
      );

      await updateHealthForm(updatedForm);
      state = AsyncValue.data(updatedForm);
    } catch (e) {
      rethrow;
    }
  }
}
