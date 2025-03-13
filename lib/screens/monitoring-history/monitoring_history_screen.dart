import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/firebase/auth/providers/fire_auth_controller.dart';
import 'package:mobile_preven_ia_app/firebase/classes/session_info.dart';
import 'package:mobile_preven_ia_app/firebase/storage/mappers/monitoring_data.dart';
import 'package:mobile_preven_ia_app/firebase/storage/mappers/weight_history.dart';
import 'package:mobile_preven_ia_app/firebase/storage/providers/fire_storage_analysis_controller.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/screens/home/widgets/clinical_results.dart';
import 'package:mobile_preven_ia_app/screens/monitoring-history/widgets/glucose_chart.dart';
import 'package:mobile_preven_ia_app/screens/monitoring-history/widgets/ldl_chart.dart';
import 'package:mobile_preven_ia_app/screens/monitoring-history/widgets/weight_chart.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_error.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_loader.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';

class MonitoringHistoryScreen extends ConsumerWidget {
  const MonitoringHistoryScreen({super.key});

  Future<Map<String, dynamic>> _getHistoricData(WidgetRef ref) async {
    final analyses =
        await ref.watch(fireStorageAnalysisControllerProvider.future);
    final monitoredValues = await ref
        .watch(fireStorageAnalysisControllerProvider.notifier)
        .getGlucoseAndLDLValuesByDate();
    final weightHistory = await ref
        .watch(fireStorageAnalysisControllerProvider.notifier)
        .getWeightHistory();
    final userInfo = await ref.read(fireAuthControllerProvider.future);
    return {
      'analyses': analyses,
      'monitoredValues': monitoredValues,
      'weightHistory': weightHistory,
      'user': userInfo,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: _getHistoricData(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const PviLoader();
        } else if (snapshot.hasError) {
          return PviError(
            customMessage: 'Error al cargar datos: ${snapshot.error}',
          );
        } else if (snapshot.hasData) {
          final data = snapshot.data!;
          final List<MonitoringData> monitoredValues =
              data['monitoredValues'] as List<MonitoringData>;
          final analyses = data['analyses'] as List<Map<String, dynamic>>?;
          final weightHistory = data['weightHistory'] as List<WeightHistory>;
          final userInfo = data['user'] as SessionInfo;
          return SafeArea(
            child: Scaffold(
              extendBody: true,
              resizeToAvoidBottomInset: true,
              body: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
                children: [
                  PviText(
                    text: 'Historial de monitoreo',
                    style: AppFonts.headline2,
                  ),
                  const SizedBox(height: 16),
                  if (userInfo.monitoringPreferences['glucose'] == true ||
                      userInfo.monitoringPreferences['ldl'] == true ||
                      userInfo.monitoringPreferences['weight'] == true)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: CarouselView(
                        itemExtent: double.infinity,
                        backgroundColor: AppColors.gray4,
                        scrollDirection: Axis.horizontal,
                        children: [
                          if (userInfo.monitoringPreferences['glucose'] == true)
                            GlucoseChart(data: monitoredValues),
                          if (userInfo.monitoringPreferences['ldl'] == true)
                            LDLChart(data: monitoredValues),
                          if (userInfo.monitoringPreferences['weight'] == true)
                            WeightChart(data: weightHistory),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  if (analyses != null && analyses.isNotEmpty)
                    PviText(
                      text: 'Estos son los resultados de tus monitoreos',
                      style: AppFonts.headline3,
                    ),
                  const SizedBox(height: 16),
                  if (analyses != null && analyses.isNotEmpty)
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: analyses.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            const SizedBox(height: 16),
                            ClinicalResults(analysis: analyses[index]),
                          ],
                        );
                      },
                    ),
                  const SizedBox(height: 16),
                  if (analyses != null && analyses.isEmpty)
                    PviText(
                      textAlign: TextAlign.center,
                      text:
                          'No tienes análisis clínicos por el momento, sube tus estudios para obtener resultados',
                      style: AppFonts.body3,
                    ),
                ],
              ),
            ),
          );
        } else {
          return const PviLoader();
        }
      },
    );
  }
}
