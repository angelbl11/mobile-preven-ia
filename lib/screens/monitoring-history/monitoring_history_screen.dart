import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/firebase/storage/mappers/monitoring_data.dart';
import 'package:mobile_preven_ia_app/firebase/storage/providers/fire_storage_analysis_controller.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/screens/home/widgets/clinical_results.dart';
import 'package:mobile_preven_ia_app/screens/monitoring-history/widgets/glucose_chart.dart';
import 'package:mobile_preven_ia_app/screens/monitoring-history/widgets/ldl_chart.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_error.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_loader.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';

class MonitoringHistoryScreen extends ConsumerWidget {
  const MonitoringHistoryScreen({super.key});

  Future<Map<String, dynamic>> _getHistoricData(WidgetRef ref) async {
    final analyses =
        await ref.read(fireStorageAnalysisControllerProvider.future);
    final monitoredValues = await ref
        .read(fireStorageAnalysisControllerProvider.notifier)
        .getGlucoseAndLDLValuesByDate();
    return {
      'analyses': analyses,
      'monitoredValues': monitoredValues,
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

          return SafeArea(
            child: Scaffold(
              extendBody: true,
              resizeToAvoidBottomInset: true,
              body: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 22,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PviText(
                        text: 'Historial de monitoreo',
                        style: AppFonts.headline2,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: CarouselView(
                          backgroundColor: AppColors.gray4,
                          scrollDirection: Axis.horizontal,
                          itemExtent: double.infinity,
                          children: [
                            GlucoseChart(data: monitoredValues),
                            LDLChart(data: monitoredValues),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: snapshot.data!.isNotEmpty,
                        child: PviText(
                          text: 'Estos son tus resultados de tus monitoreos',
                          style: AppFonts.headline3,
                        ),
                      ),
                      if (analyses != null && analyses.isNotEmpty)
                        ...analyses.map(
                            (analysis) => ClinicalResults(analysis: analysis)),
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
