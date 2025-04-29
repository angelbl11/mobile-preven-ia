import 'package:mobile_preven_ia_app/core/providers/network/custom_dio.dart';

/// WeightRepository
class WeightRepository {
  /// Constructor
  WeightRepository({
    required this.dio,
  });

  /// Dio client
  final CustomDio dio;

  Future<void> updateWeight(double weight) async {
    try {
      final response = await dio.dio.put('/v1/weight/update', data: {
        'weight': weight,
      });

      if (response.statusCode != 200) {
        throw Exception('Failed to update weight: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
