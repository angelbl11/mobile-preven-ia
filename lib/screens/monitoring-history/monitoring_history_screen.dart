import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/core/domain/controllers/monitoring-data/monitoring_data_controller.dart';
import 'package:mobile_preven_ia_app/core/domain/controllers/health-files/health_files_controller.dart';
import 'package:mobile_preven_ia_app/core/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_error.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_loader.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text.dart';
import 'package:mobile_preven_ia_app/screens/monitoring-history/widgets/diabetes_chart.dart';
import 'package:mobile_preven_ia_app/screens/monitoring-history/widgets/hypertension_chart.dart';
import 'package:mobile_preven_ia_app/screens/monitoring-history/widgets/obesity_chart.dart';
import 'package:mobile_preven_ia_app/screens/home/widgets/clinical_results.dart';

class MonitoringHistoryScreen extends ConsumerStatefulWidget {
  const MonitoringHistoryScreen({super.key});

  @override
  ConsumerState<MonitoringHistoryScreen> createState() =>
      _MonitoringHistoryScreenState();
}

class _MonitoringHistoryScreenState
    extends ConsumerState<MonitoringHistoryScreen> {
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    ref.invalidate(monitoringDataControllerProvider);
    ref.invalidate(healthFilesControllerProvider);
  }

  @override
  Widget build(BuildContext context) {
    final monitoringDataAsync = ref.watch(monitoringDataControllerProvider);
    final healthFilesAsync = ref.watch(healthFilesControllerProvider);

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      body: SizedBox.expand(
        child: RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.background,
          onRefresh: _loadData,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
            children: [
              const SizedBox(height: 32),
              const PviText(
                text: 'Historial de monitoreo',
                variant: TextVariant.headline2,
              ),
              const PviText(
                text:
                    'Aquí puedes ver los resultados de tus monitoreos y análisis clínicos de forma gráfica',
                variant: TextVariant.body1,
              ),
              const SizedBox(height: 16),
              monitoringDataAsync.when(
                loading: () => const PviLoader(),
                error: (error, stack) => PviError(
                  customMessage: 'Error al cargar datos de monitoreo: $error',
                ),
                data: (monitoringData) {
                  final hasObesityData =
                      monitoringData.data.obesity?.weight.isNotEmpty ?? false;
                  final hasDiabetesData =
                      monitoringData.data.diabetes?.glucose.isNotEmpty ?? false;
                  final hasHypertensionData = monitoringData
                          .data.hypertension?.bloodPressure.isNotEmpty ??
                      false;

                  final hasAnyMonitoringData =
                      hasObesityData || hasDiabetesData || hasHypertensionData;

                  if (!hasAnyMonitoringData) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: PviText(
                        textAlign: TextAlign.center,
                        text:
                            'Necesitas al menos dos registros para visualizar tu avance en el tiempo',
                        variant: TextVariant.body3,
                      ),
                    );
                  }

                  return Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Container(
                          color: AppColors.gray4,
                          child: CarouselSlider(
                            options: CarouselOptions(
                              viewportFraction: 1.0,
                              scrollDirection: Axis.horizontal,
                              enableInfiniteScroll: false,
                              height: MediaQuery.of(context).size.height * 0.4,
                              enlargeCenterPage: true,
                              autoPlay: false,
                              aspectRatio: 2.0,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentPage = index;
                                });
                              },
                              enlargeStrategy: CenterPageEnlargeStrategy.height,
                              padEnds: false,
                            ),
                            items: [
                              if (hasObesityData)
                                ObesityChart(
                                  data: monitoringData.data.obesity!.weight,
                                ),
                              if (hasDiabetesData)
                                DiabetesChart(
                                  data: monitoringData.data.diabetes!.glucose,
                                ),
                              if (hasHypertensionData)
                                HypertensionChart(
                                  data: monitoringData
                                      .data.hypertension!.bloodPressure,
                                ),
                            ].map((widget) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return widget;
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          [
                            if (hasDiabetesData) true,
                            if (hasHypertensionData) true,
                            if (hasObesityData) true,
                          ].where((element) => element == true).length,
                          (index) => Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 15),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentPage == index
                                  ? AppColors.primary
                                  : AppColors.gray3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              healthFilesAsync.when(
                loading: () => const PviLoader(),
                error: (error, stack) => PviError(
                  customMessage: 'Error al cargar archivos de salud: $error',
                ),
                data: (healthFiles) {
                  if (healthFiles.isEmpty) {
                    return const PviText(
                      textAlign: TextAlign.center,
                      text:
                          'No tienes análisis clínicos por el momento, sube tus estudios para obtener resultados',
                      variant: TextVariant.body3,
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          const PviText(
                            text: 'Estos son los resultados de tus monitoreos',
                            variant: TextVariant.headline3,
                          ),
                          const SizedBox(height: 16),
                          ...healthFiles.map((healthFile) => Column(
                                children: [
                                  ClinicalResults(prediction: healthFile),
                                  if (healthFile != healthFiles.last)
                                    const SizedBox(height: 16),
                                ],
                              )),
                        ],
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            ],
          ),
        ),
      ),
    );
  }
}
