import 'package:mobile_preven_ia_app/core/providers/network/custom_dio.dart';
import 'package:mobile_preven_ia_app/core/domain/models/monitoring_data.dart';
import 'package:mobile_preven_ia_app/core/data/mappers/monitoring_data_mapper.dart';

/// MonitoringDataRepository
class MonitoringDataRepository {
  /// Constructor
  MonitoringDataRepository({
    required this.dio,
  });

  /// Dio client
  final CustomDio dio;

  Future<MonitoringData> getMonitoringData() async {
    try {
      final response = await dio.dio.get('/v1/monitoring/data');
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to load monitoring data: ${response.statusCode}');
      }

      final json = response.data;
      if (json == null) {
        return MonitoringData(
          userId: '',
          data: MonitoringParameters(),
        );
      }

      return MonitoringDataMapper.fromJson(json);
    } catch (e) {
      rethrow;
    }
  }
}
