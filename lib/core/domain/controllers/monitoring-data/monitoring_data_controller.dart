import 'package:mobile_preven_ia_app/core/data/repositories/monitoring-data/providers/monitoring_data_repository_provider.dart';
import 'package:mobile_preven_ia_app/core/domain/models/monitoring_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'monitoring_data_controller.g.dart';

@riverpod

/// [MonitoringDataController] provider
class MonitoringDataController extends _$MonitoringDataController {
  @override
  Future<MonitoringData> build() async {
    return getMonitoringData();
  }

  Future<MonitoringData> getMonitoringData() async {
    try {
      final monitoringDataRepository =
          ref.read(monitoringDataRepositoryProvider);
      final response = await monitoringDataRepository.getMonitoringData();

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
