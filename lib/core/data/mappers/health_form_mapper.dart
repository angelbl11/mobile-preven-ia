import 'package:mobile_preven_ia_app/core/domain/models/health_form_info.dart';

class HealthFormMapper {
  /// Converts a JSON response to a HealthFormInfo model
  static HealthFormInfo fromResponse(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final result = HealthFormInfo.fromJson(data);
    return result;
  }

  /// Converts a HealthFormInfo model to a request JSON
  static Map<String, dynamic> toRequest(HealthFormInfo healthFormInfo) {
    return healthFormInfo.toJson();
  }
}
