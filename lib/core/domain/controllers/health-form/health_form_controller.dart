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
      final currentState = state.value;
      if (currentState == null) {
        final healthFormRepository = ref.read(healthFormRepositoryProvider);
        return healthFormRepository.updateHealthForm(healthFormInfo);
      }

      final updatedForm = HealthFormInfo(
        name: healthFormInfo.name ?? currentState.name,
        dateOfBirth: healthFormInfo.dateOfBirth ?? currentState.dateOfBirth,
        personalInfo: healthFormInfo.personalInfo ?? currentState.personalInfo,
        lifestyle: healthFormInfo.lifestyle ?? currentState.lifestyle,
        familyHistory:
            healthFormInfo.familyHistory ?? currentState.familyHistory,
        monitoring: healthFormInfo.monitoring ?? currentState.monitoring,
        step: healthFormInfo.step,
        completed: healthFormInfo.completed,
      );

      final healthFormRepository = ref.read(healthFormRepositoryProvider);
      await healthFormRepository.updateHealthForm(updatedForm);
      state = AsyncValue.data(updatedForm);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateStep(num step) async {
    try {
      final currentState = state.value;
      if (currentState == null) return;

      final updatedForm = HealthFormInfo(
        name: currentState.name ?? '',
        dateOfBirth: currentState.dateOfBirth ?? DateTime.now(),
        personalInfo: currentState.personalInfo ??
            PersonalInfo(
              age: 0,
              gender: '',
              height: 0,
              weight: 0,
              bmi: 0,
            ),
        lifestyle: currentState.lifestyle ??
            Lifestyle(
              physicalActivity: 'none',
              smoker: 0,
              alcoholConsumption: 'none',
            ),
        familyHistory: currentState.familyHistory ??
            FamilyHistory(
              diabetes: 0,
              hypertension: 0,
              obesity: 0,
            ),
        monitoring: currentState.monitoring ??
            Monitoring(
              diabetes: false,
              hypertension: false,
              obesity: false,
            ),
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
