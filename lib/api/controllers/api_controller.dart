import 'package:mobile_preven_ia_app/api/enums/diabetes_prediction.dart';
import 'package:mobile_preven_ia_app/api/enums/hypertension_prediction.dart';
import 'package:mobile_preven_ia_app/api/enums/obesity_prediction.dart';
import 'package:mobile_preven_ia_app/api/providers/api_repository_provider.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_controller.g.dart';

@riverpod
class ApiController extends _$ApiController {
  @override
  Future<void> build() async {
    return;
  }

  Future<ObesityPrediction> getObesityPrediction(
      num imc,
      num ldl,
      num triglycerides,
      String gender,
      num age,
      bool haveObesityGenetic) async {
    try {
      final apiRepository = ref.read(apiRepositoryProvider);
      return await apiRepository.getObesityPrediction(
        imc,
        ldl,
        triglycerides,
        gender,
        age,
        haveObesityGenetic,
      );
    } catch (e) {
      print('Error al obtener la predicción de obesidad: $e');
      rethrow;
    }
  }

  Future<DiabetesPrediction> getDiabetesPrediction(
      num fastingGlucose,
      num hba1c,
      bool haveDiabetesGenetic,
      String gender,
      num age,
      num imc) async {
    try {
      final apiRepository = ref.read(apiRepositoryProvider);
      return await apiRepository.getDiabetesPrediction(
        fastingGlucose,
        hba1c,
        haveDiabetesGenetic,
        gender,
        age,
        imc,
      );
    } catch (e) {
      print('Error al obtener la predicción de diabetes: $e');
      rethrow;
    }
  }

  Future<HypertensionPrediction> getHypertensionPrediction(
      num systolicPressure,
      num diastolicPressure,
      num creatinine,
      num ldl,
      bool haveHypertensionGenetic,
      String gender,
      num age,
      num imc) async {
    try {
      final apiRepository = ref.read(apiRepositoryProvider);
      return await apiRepository.getHypertensionPrediction(
        systolicPressure,
        diastolicPressure,
        creatinine,
        ldl,
        haveHypertensionGenetic,
        gender,
        age,
        imc,
      );
    } catch (e) {
      print('Error al obtener la predicción de hipertensión: $e');
      rethrow;
    }
  }
}
