import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/firebase/auth/providers/fire_auth_controller.dart';
import 'package:mobile_preven_ia_app/firebase/storage/clinical-analysis/clinical_analysis_controller.dart';
import 'package:mobile_preven_ia_app/firebase/storage/mappers/monitoring_data.dart';
import 'package:mobile_preven_ia_app/firebase/storage/mappers/weight_history.dart';
import 'package:mobile_preven_ia_app/firebase/storage/user/user_controller.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/screens/home/widgets/clinical_results.dart';
import 'package:mobile_preven_ia_app/screens/monitoring-history/widgets/glucose_chart.dart';
import 'package:mobile_preven_ia_app/screens/monitoring-history/widgets/ldl_chart.dart';
import 'package:mobile_preven_ia_app/screens/monitoring-history/widgets/weight_chart.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_error.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_loader.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';

class MonitoringHistoryScreen extends ConsumerStatefulWidget {
  const MonitoringHistoryScreen({super.key});

  @override
  ConsumerState<MonitoringHistoryScreen> createState() =>
      _MonitoringHistoryScreenState();
}

class _MonitoringHistoryScreenState
    extends ConsumerState<MonitoringHistoryScreen> {
  int _currentPage = 0;
  late Future<List<WeightHistory>> _weightHistoryFuture;

  @override
  void initState() {
    super.initState();
    _weightHistoryFuture = ref
        .read(clinicalAnalysisControllerProvider.notifier)
        .getWeightHistory();
    _loadData();
  }

  Future<void> _loadData() async {
    ref.invalidate(userControllerProvider);
    ref.invalidate(clinicalAnalysisControllerProvider);
    setState(() {
      _weightHistoryFuture = ref
          .read(clinicalAnalysisControllerProvider.notifier)
          .getWeightHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userInfoAsync = ref.watch(fireAuthControllerProvider);
    final analysisDataAsync = ref.watch(clinicalAnalysisControllerProvider);

    return userInfoAsync.when(
      loading: () => const PviLoader(),
      error: (error, stack) => PviError(
        customMessage: 'Error al cargar datos del usuario: $error',
      ),
      data: (userInfo) {
        return analysisDataAsync.when(
          loading: () => const PviLoader(),
          error: (error, stack) => PviError(
            customMessage: 'Error al cargar análisis: $error',
          ),
          data: (analyses) {
            return FutureBuilder<List<WeightHistory>>(
              future: _weightHistoryFuture,
              builder: (context, weightSnapshot) {
                if (weightSnapshot.connectionState == ConnectionState.waiting) {
                  return const PviLoader();
                }
                if (weightSnapshot.hasError) {
                  return PviError(
                    customMessage:
                        'Error al cargar historial de peso: ${weightSnapshot.error}',
                  );
                }

                final weightHistory = weightSnapshot.data ?? [];

                final monitoredValues = analyses.map((analysis) {
                  final glucoseValue = analysis.exams['Glucosa']?['value'] ??
                      analysis.exams['Glucemia']?['value'] ??
                      analysis.exams['Glucosa en ayunas']?['value'];
                  final ldlValue = analysis.exams['LDL']?['value'] ??
                      analysis.exams['Colesterol LDL directo']?['value'] ??
                      analysis.exams['Colesterol LDL Directo']?['value'] ??
                      analysis.exams['Colesterol LDL']?['value'];

                  final glucose = glucoseValue != null
                      ? double.tryParse(glucoseValue
                              .toString()
                              .replaceAll(RegExp(r'[^\d\.]'), '')) ??
                          0.0
                      : 0.0;
                  final ldl = ldlValue != null
                      ? double.tryParse(ldlValue
                              .toString()
                              .replaceAll(RegExp(r'[^\d\.]'), '')) ??
                          0.0
                      : 0.0;

                  return {
                    'date': analysis.createdAt,
                    'glucose': glucose,
                    'ldl': ldl,
                  };
                }).toList();

                final hasGlucoseData =
                    userInfo?.monitoringPreferences?.glucose == true &&
                        monitoredValues
                                .where((value) =>
                                    ((value['glucose'] as num?) ?? 0) > 0)
                                .length >=
                            2;
                final hasLDLData = userInfo?.monitoringPreferences?.ldl ==
                        true &&
                    monitoredValues
                            .where((value) => ((value['ldl'] as num?) ?? 0) > 0)
                            .length >=
                        2;
                final hasWeightData =
                    userInfo?.monitoringPreferences?.weight == true &&
                        weightHistory.length >= 2;

                final hasAnyMonitoringData =
                    hasGlucoseData || hasLDLData || hasWeightData;

                // Debug prints

                return SafeArea(
                  child: Scaffold(
                    extendBody: true,
                    resizeToAvoidBottomInset: true,
                    body: RefreshIndicator(
                      color: AppColors.primary,
                      backgroundColor: AppColors.background,
                      onRefresh: _loadData,
                      child: ListView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 32),
                        children: [
                          PviText(
                            text: 'Historial de monitoreo',
                            style: AppFonts.headline2,
                          ),
                          const SizedBox(height: 16),
                          if (hasAnyMonitoringData)
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: Container(
                                color: AppColors.gray4,
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                    viewportFraction: 1.0,
                                    scrollDirection: Axis.horizontal,
                                    enableInfiniteScroll: false,
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    enlargeCenterPage: true,
                                    autoPlay: false,
                                    aspectRatio: 2.0,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        _currentPage = index;
                                      });
                                    },
                                    enlargeStrategy:
                                        CenterPageEnlargeStrategy.height,
                                    padEnds: false,
                                  ),
                                  items: [
                                    if (hasWeightData)
                                      WeightChart(
                                        data: weightHistory,
                                      ),
                                    if (hasGlucoseData)
                                      GlucoseChart(
                                        data: monitoredValues
                                            .where((value) =>
                                                ((value['glucose'] as num?) ??
                                                    0) >
                                                0)
                                            .map((value) => MonitoringData(
                                                  date:
                                                      value['date'] as DateTime,
                                                  glucose: value['glucose']
                                                      as double,
                                                  ldl: 0.0,
                                                ))
                                            .toList(),
                                      ),
                                    if (hasLDLData)
                                      LDLChart(
                                        data: monitoredValues
                                            .where((value) =>
                                                ((value['ldl'] as num?) ?? 0) >
                                                0)
                                            .map((value) => MonitoringData(
                                                  date:
                                                      value['date'] as DateTime,
                                                  glucose: 0.0,
                                                  ldl: value['ldl'] as double,
                                                ))
                                            .toList(),
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
                            )
                          else
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: PviText(
                                textAlign: TextAlign.center,
                                text:
                                    'Necesitas al menos dos registros para visualizar tu avance en el tiempo',
                                style: AppFonts.body3,
                              ),
                            ),
                          if (hasAnyMonitoringData)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                [
                                  if (hasGlucoseData) true,
                                  if (hasLDLData) true,
                                  if (hasWeightData) true,
                                ].where((element) => element == true).length,
                                (index) => Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 15),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentPage == index
                                        ? Theme.of(context).primaryColor
                                        : AppColors.gray3,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 16),
                          if (analyses.isNotEmpty)
                            PviText(
                              text:
                                  'Estos son los resultados de tus monitoreos',
                              style: AppFonts.headline3,
                            ),
                          const SizedBox(height: 16),
                          if (analyses.isNotEmpty)
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: analyses.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClinicalResults(analysis: analyses[index]),
                                    if (index != analyses.length - 1)
                                      const SizedBox(height: 16),
                                  ],
                                );
                              },
                            ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1),
                          if (analyses.isEmpty)
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
                );
              },
            );
          },
        );
      },
    );
  }
}
