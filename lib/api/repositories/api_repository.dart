import 'package:dio/dio.dart';
import 'package:mobile_preven_ia_app/api/enums/diabetes_prediction.dart';
import 'package:mobile_preven_ia_app/api/enums/hypertension_prediction.dart';
import 'package:mobile_preven_ia_app/api/enums/obesity_prediction.dart';

class ApiRepository {
  ApiRepository({required this.dio});

  final Dio dio;

  Future<ObesityPrediction> getObesityPrediction(
      num imc,
      num ldl,
      num triglycerides,
      String gender,
      num age,
      bool haveObesityGenetic) async {
    final response = await dio.post(
      '/predict/obesity',
      data: {
        'imc': imc,
        'ldl': ldl,
        'trigliceridos': triglycerides,
        'condicion_genetica': haveObesityGenetic,
        'genero': gender,
        'edad': age,
      },
    );

    return ObesityPrediction.fromJson(response.data);
  }

  Future<DiabetesPrediction> getDiabetesPrediction(
      num fastingGlucose,
      num hba1c,
      bool haveDiabetesGenetic,
      String gender,
      num age,
      num imc) async {
    final response = await dio.post(
      '/predict/diabetes',
      data: {
        'glucosa_ayunas': fastingGlucose,
        'hba1c': hba1c,
        'condicion_genetica': haveDiabetesGenetic,
        'genero': gender,
        'edad': age,
        'imc': imc,
      },
    );

    return DiabetesPrediction.fromJson(response.data);
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
    final response = await dio.post(
      '/predict/hypertension',
      data: {
        'presion_arterial_sistolica': systolicPressure,
        'presion_arterial_diastolica': diastolicPressure,
        'creatinina': creatinine,
        'ldl': ldl,
        'condicion_genetica': haveHypertensionGenetic,
        'genero': gender,
        'edad': age,
        'imc': imc,
      },
    );

    return HypertensionPrediction.fromJson(response.data);
  }
}
