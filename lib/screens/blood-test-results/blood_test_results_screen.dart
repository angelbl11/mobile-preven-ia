// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_preven_ia_app/core/domain/controllers/health-files/health_files_controller.dart';
import 'package:mobile_preven_ia_app/core/domain/models/analysis_status.dart';
import 'package:mobile_preven_ia_app/core/domain/models/exam_range.dart';
import 'package:mobile_preven_ia_app/core/domain/models/health_prediction.dart';
import 'package:mobile_preven_ia_app/core/domain/models/risk_level.dart';
import 'package:mobile_preven_ia_app/core/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_button.dart';
import 'package:mobile_preven_ia_app/screens/navigation-handler/navigation_handler_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final analysis = widget.healthPrediction.analysis;
    if (analysis == null) {
      return const Scaffold(
        body: Center(
          child: Text('Error: No se encontraron datos de análisis'),
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: ListView(
          children: [
            const PviText(
              text: 'Estos son tus resultados',
              variant: TextVariant.headline1,
            ).animate().fadeIn(duration: 600.ms).slideY(
                  begin: 0.2,
                  end: 0,
                  duration: 600.ms,
                  curve: Curves.easeOut,
                ),
            const SizedBox(height: 16),
            if (analysis.models.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PviText(
                    text: 'Evaluaciones de riesgo',
                    variant: TextVariant.headline2,
                  ).animate().fadeIn(duration: 600.ms, delay: 100.ms).slideY(
                        begin: 0.2,
                        end: 0,
                        duration: 600.ms,
                        curve: Curves.easeOut,
                      ),
                  const SizedBox(height: 16),
                  ...analysis.models.entries.map((entry) {
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
                                text: model.prediction,
                                variant: TextVariant.headline3,
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: (model.riskLevel == RiskLevel.bajo
                                          ? AppColors.success
                                          : model.riskLevel ==
                                                  RiskLevel.moderado
                                              ? AppColors.warning
                                              : AppColors.error)
                                      .withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: PviText(
                                  text: model.riskLevel.displayName,
                                  variant: TextVariant.body1,
                                  color: AppColors.background,
                                ),
                              ),
                            ],
                          ),
                          FAProgressBar(
                            size: 18,
                            progressColor: model.riskLevel == RiskLevel.bajo
                                ? AppColors.success
                                : model.riskLevel == RiskLevel.moderado
                                    ? AppColors.warning
                                    : AppColors.error,
                            currentValue: model.probability,
                            displayText: '%',
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(
                          begin: 0.2,
                          end: 0,
                          duration: 600.ms,
                          curve: Curves.easeOut,
                        );
                  }).toList(),
                ],
              ),
            const PviText(
              text: 'Recomendaciones',
              variant: TextVariant.headline2,
            ).animate().fadeIn(duration: 600.ms, delay: 300.ms).slideY(
                  begin: 0.2,
                  end: 0,
                  duration: 600.ms,
                  curve: Curves.easeOut,
                ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.gray4,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PviText(
                    text: 'Predicción y recomendaciones',
                    variant: TextVariant.subtitle2,
                  ),
                  Row(
                    children: [
                      const PviText(
                        text: 'Estado general: ',
                        variant: TextVariant.body2,
                      ),
                      PviText(
                        text: analysis.diagnosis.globalStatus.displayName,
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
            ).animate().fadeIn(duration: 600.ms, delay: 400.ms).slideY(
                  begin: 0.2,
                  end: 0,
                  duration: 600.ms,
                  curve: Curves.easeOut,
                ),
            const PviText(
              text: 'Interpretación de  resultados',
              variant: TextVariant.headline2,
            ).animate().fadeIn(duration: 600.ms, delay: 500.ms).slideY(
                  begin: 0.2,
                  end: 0,
                  duration: 600.ms,
                  curve: Curves.easeOut,
                ),
            const SizedBox(height: 16),
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
                  spacing: 8,
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
              ).animate().fadeIn(duration: 600.ms, delay: 600.ms).slideY(
                    begin: 0.2,
                    end: 0,
                    duration: 600.ms,
                    curve: Curves.easeOut,
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
                spacing: 8,
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
            ).animate().fadeIn(duration: 600.ms, delay: 700.ms).slideY(
                  begin: 0.2,
                  end: 0,
                  duration: 600.ms,
                  curve: Curves.easeOut,
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
                        ref.invalidate(healthFilesControllerProvider);
                        Navigator.of(context).push(
                          PageTransition(
                            type: PageTransitionType.fade,
                            duration: const Duration(milliseconds: 300),
                            child: NavigationHandlerScreen(),
                          ),
                        );
                      })
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 800.ms)
                  .slideY(
                    begin: 0.2,
                    end: 0,
                    duration: 600.ms,
                    curve: Curves.easeOut,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
