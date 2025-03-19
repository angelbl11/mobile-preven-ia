// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_preven_ia_app/extensions/date_formatter_extension.dart';
import 'package:mobile_preven_ia_app/firebase/storage/clinical-analysis/clinical_analysis_controller.dart';
import 'package:mobile_preven_ia_app/firebase/storage/mappers/analysis_data.dart';
import 'package:mobile_preven_ia_app/functions/status_handler_function.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/screens/analysis-details/analysis_details_screen.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class ClinicalResults extends ConsumerWidget {
  const ClinicalResults({
    super.key,
    required this.analysis,
  });

  final AnalysisData analysis;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateGeneral = analysis.diagnosis['estado_global'] as String? ?? '';
    final date = analysis.createdAt.toIso8601String().toFormattedDateTime();
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
            spacing: 8,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  PviText(text: 'Prueba de sangre', style: AppFonts.body2),
                  PviText(
                      text: date, style: AppFonts.body1.copyWith(fontSize: 12)),
                ],
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: PviText(
                    text: stateGeneral == 'CRITICAL'
                        ? 'Crítico'
                        : stateGeneral == 'OBSERVATION'
                            ? 'Revisión'
                            : 'Normal',
                    style: AppFonts.body1.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: stateGeneral == 'ACCEPTABLE'
                            ? AppColors.success
                            : stateGeneral == 'OBSERVATION'
                                ? AppColors.warning
                                : AppColors.error)),
              ),
              const Spacer(),
              InkWell(
                onTap: () async {
                  StatusHandlerFunction.handleStatus(
                    context: context,
                    action: ref
                        .read(clinicalAnalysisControllerProvider.notifier)
                        .getUserAnalysisById(analysis.id),
                    onSuccessCallBack: () {
                      PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                        context,
                        screen: const AnalysisDetailsScreen(),
                        withNavBar: false,
                        pageTransitionAnimation: PageTransitionAnimation.fade,
                        settings: RouteSettings(
                          arguments: {
                            'analysis': analysis,
                          },
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.gray4,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Icon(
                    LucideIcons.chevronRight,
                    color: AppColors.gray5,
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
