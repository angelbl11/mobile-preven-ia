import 'package:mobile_preven_ia_app/core/domain/models/monitoring_data.dart';

class MonitoringDataMapper {
  static MonitoringData fromJson(Map<String, dynamic> json) {
    return MonitoringData.fromJson(json);
  }

  static Map<String, dynamic> toJson(MonitoringData model) {
    return model.toJson();
  }
}
