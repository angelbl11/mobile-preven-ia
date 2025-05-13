import 'package:mobile_preven_ia_app/core/data/mappers/health_form_mapper.dart';
import 'package:mobile_preven_ia_app/core/domain/models/health_form_info.dart';
import 'package:mobile_preven_ia_app/core/providers/network/custom_dio.dart';

/// HealthFormRepository
class HealthFormRepository {
  /// Constructor
  HealthFormRepository({
    required this.dio,
  });

  /// Dio client
  final CustomDio dio;

  Future<HealthFormInfo> getHealthForm() async {
    try {
      final response = await dio.dio.get(
        '/v1/health-form/get-form-info',
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load health form: ${response.statusCode}');
      }

      final json = response.data;
      if (json == null) {
        return HealthFormInfo.empty();
      }

      return HealthFormMapper.fromResponse(json);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateHealthForm(HealthFormInfo healthFormInfo) async {
    try {
      final response = await dio.dio.put(
        '/v1/health-form/fill-form',
        data: HealthFormMapper.toRequest(healthFormInfo),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update health form: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
