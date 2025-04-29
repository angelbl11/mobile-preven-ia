// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_preven_ia_app/core/domain/models/analysis_status.dart';
import 'package:mobile_preven_ia_app/core/domain/models/exam_range.dart';
import 'package:mobile_preven_ia_app/core/domain/models/health_prediction.dart';
import 'package:mobile_preven_ia_app/core/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_button.dart';
import 'package:mobile_preven_ia_app/screens/navigation-handler/navigation_handler_screen.dart';
import 'package:page_transition/page_transition.dart';

class BloodTestResultsScreen extends ConsumerStatefulWidget {
  final HealthPrediction healthPrediction;

  const BloodTestResultsScreen({
    super.key,
    required this.healthPrediction,
  });

  @override
  ConsumerState<BloodTestResultsScreen> createState() =>
      _BloodTestResultsScreenState();
}

class _BloodTestResultsScreenState extends ConsumerState<BloodTestResultsScreen>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final analysis = widget.healthPrediction.analysis;
    print('Analysis: $analysis');
    if (analysis == null) {
      return const Scaffold(
        body: Center(
          child: Text('Error: No se encontraron datos de análisis'),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        body: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeInOut,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
            child: ListView(
              children: [
                const PviText(
                  text: 'Estos son tus resultados',
                  variant: TextVariant.headline1,
                ),
                const SizedBox(height: 16),
                if (analysis.models.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PviText(
                        text: 'Evaluaciones de riesgo',
                        variant: TextVariant.headline2,
                      ),
                      const SizedBox(height: 16),
                      ...analysis.models.entries.map((entry) {
                        final modelName = entry.key;
                        final model = entry.value;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.gray4,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  PviText(
                                    text: modelName,
                                    variant: TextVariant.headline3,
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 0, 0, 0)
                                          .withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: PviText(
                                      text: model.riskLevel,
                                      variant: TextVariant.body1,
                                      color: model.riskLevel.toLowerCase() ==
                                              'bajo'
                                          ? AppColors.success
                                          : model.riskLevel.toLowerCase() ==
                                                  'medio'
                                              ? AppColors.warning
                                              : AppColors.error,
                                    ),
                                  ),
                                ],
                              ),
                              FAProgressBar(
                                size: 18,
                                progressColor: model.riskLevel.toLowerCase() ==
                                        'bajo'
                                    ? AppColors.success
                                    : model.riskLevel.toLowerCase() == 'medio'
                                        ? AppColors.warning
                                        : AppColors.error,
                                currentValue: model.probability * 100,
                                displayText: '%',
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.gray4,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PviText(
                        text: 'Predicción y recomendaciones',
                        variant: TextVariant.subtitle2,
                      ),
                      Row(
                        children: [
                          const PviText(
                            text: 'Estado general:',
                            variant: TextVariant.body2,
                          ),
                          PviText(
                            text: analysis.diagnosis.globalStatus.name,
                            variant: TextVariant.body2,
                            color: analysis.diagnosis.globalStatus ==
                                    AnalysisStatus.acceptable
                                ? AppColors.success
                                : analysis.diagnosis.globalStatus ==
                                        AnalysisStatus.observation
                                    ? AppColors.warning
                                    : AppColors.error,
                          ),
                        ],
                      ),
                      PviText(
                        text: analysis.diagnosis.observations,
                        variant: TextVariant.body3,
                      ),
                    ],
                  ),
                ),
                ...analysis.exams.entries.map((entry) {
                  final examName = entry.key;
                  final exam = entry.value;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.gray4,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Tooltip(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          showDuration: const Duration(seconds: 7),
                          triggerMode: TooltipTriggerMode.tap,
                          message: exam.explanation,
                          child: const Icon(
                            LucideIcons.info,
                            color: AppColors.primary,
                            size: 16,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: PviText(
                            text: examName,
                            variant: TextVariant.body2,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              PviText(
                                text: exam.value,
                                variant: TextVariant.body2,
                                textAlign: TextAlign.center,
                              ),
                              PviText(
                                text: exam.healthyRange,
                                variant: TextVariant.body3,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: exam.range == ExamRange.onRange
                                ? AppColors.success
                                : exam.range == ExamRange.high
                                    ? AppColors.error
                                    : AppColors.warning,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.gray4,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        LucideIcons.info,
                        color: AppColors.primary,
                      ),
                      Expanded(
                        child: PviText(
                          text:
                              'Estos resultados son una predicción y no un diagnóstico. Si tienes alguna duda, consulta con tu médico de confianza o con un especialista para obtener una interpretación más precisa.',
                          variant: TextVariant.body1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: PviButton(
                      child: const PviText(
                        text: 'Entendido',
                        variant: TextVariant.body2,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          PageTransition(
                            type: PageTransitionType.fade,
                            duration: const Duration(milliseconds: 300),
                            child: NavigationHandlerScreen(),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
