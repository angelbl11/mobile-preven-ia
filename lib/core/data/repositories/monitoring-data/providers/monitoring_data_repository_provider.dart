import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/core/data/repositories/monitoring-data/monitoring_data_repository.dart';
import 'package:mobile_preven_ia_app/core/providers/network/custom_dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'monitoring_data_repository_provider.g.dart';

@riverpod

/// [MonitoringDataRepository] provider
MonitoringDataRepository monitoringDataRepository(
  Ref ref,
) {
  final dioController = ref.watch(customDioControllerProvider);

  return MonitoringDataRepository(
    dio: dioController,
  );
}
