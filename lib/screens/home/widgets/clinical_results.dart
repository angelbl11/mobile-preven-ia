// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_preven_ia_app/core/domain/models/analysis_status.dart';
import 'package:mobile_preven_ia_app/core/domain/models/health_file.dart';
import 'package:mobile_preven_ia_app/core/extensions/date_formatter_extension.dart';
import 'package:mobile_preven_ia_app/core/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text.dart';
import 'package:mobile_preven_ia_app/screens/blood-test-results/blood_test_results_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class ClinicalResults extends ConsumerWidget {
  const ClinicalResults({
    super.key,
    required this.prediction,
  });

  final HealthFile prediction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateGeneral =
        prediction.geminiAnalysis.analysis?.diagnosis.globalStatus;
    final date = prediction.uploadDate.toIso8601String().toFormattedDateTime();

    // Si el estado no es válido, no mostramos el widget
    if (stateGeneral != AnalysisStatus.critical &&
        stateGeneral != AnalysisStatus.observation &&
        stateGeneral != AnalysisStatus.acceptable) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.gray4,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        spacing: 16,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      const Color.fromARGB(255, 74, 144, 226).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Icon(
                  LucideIcons.testTube,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  const PviText(
                      text: 'Prueba de sangre', variant: TextVariant.body2),
                  PviText(text: date, variant: TextVariant.body1),
                ],
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: stateGeneral == AnalysisStatus.critical
                      ? AppColors.error
                      : stateGeneral == AnalysisStatus.observation
                          ? AppColors.warning
                          : AppColors.success,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: PviText(
                  text: stateGeneral?.displayName ?? '',
                  variant: TextVariant.body2,
                  color: AppColors.background,
                ),
              ),
              const Spacer(),
              if (prediction.geminiAnalysis.analysis != null)
                InkWell(
                  onTap: () async {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: BloodTestResultsScreen(
                        healthPrediction: prediction.geminiAnalysis,
                      ),
                      withNavBar: false,
                      pageTransitionAnimation: PageTransitionAnimation.fade,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.gray4,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Icon(
                      LucideIcons.chevronRight,
                      color: AppColors.gray5,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
