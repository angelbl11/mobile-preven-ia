import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_button.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';

class AnalysisDetailsScreen extends ConsumerStatefulWidget {
  const AnalysisDetailsScreen({super.key});

  @override
  ConsumerState<AnalysisDetailsScreen> createState() =>
      _AnalysisDetailsScreenState();
}

class _AnalysisDetailsScreenState extends ConsumerState<AnalysisDetailsScreen>
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
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};
    final analysisData = args['analysis'] as Map<String, dynamic>?;
    final stateGeneral =
        analysisData?['diagnostico']['estado_global'] as String? ?? '';
    final recommendations =
        analysisData?['diagnostico']['observaciones'] as String? ?? '';

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
                PviText(
                    text: 'Estos son tus resultados',
                    style: AppFonts.headline1),
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
                      PviText(
                        text: 'Predicción y recomendaciones',
                        style: AppFonts.subtitle2,
                      ),
                      Row(
                        spacing: 8,
                        children: [
                          PviText(
                              text: 'Estado general:', style: AppFonts.body2),
                          PviText(
                              text: stateGeneral == 'ACCEPTABLE'
                                  ? 'Buen estado'
                                  : stateGeneral == 'OBSERVATION'
                                      ? 'Se requiere atención'
                                      : 'Crítico',
                              style: AppFonts.body2.copyWith(
                                  color: stateGeneral == 'ACCEPTABLE'
                                      ? AppColors.success
                                      : stateGeneral == 'OBSERVATION'
                                          ? AppColors.warning
                                          : AppColors.error)),
                        ],
                      ),
                      PviText(text: recommendations, style: AppFonts.body3),
                    ],
                  ),
                ),
                if (analysisData?['exams'] != null)
                  ...((analysisData?['exams'] as Map<String, dynamic>)
                      .entries
                      .map((entry) {
                    final examName = entry.key;
                    final examData = entry.value as Map<String, dynamic>;
                    final value = examData['value'] as String? ?? '';
                    final range = examData['range'] as String? ?? '';
                    final explanation =
                        examData['explanation'] as String? ?? '';

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
                            showDuration: const Duration(seconds: 7),
                            triggerMode: TooltipTriggerMode.tap,
                            message: explanation,
                            child: const Icon(
                              LucideIcons.info,
                              color: AppColors.primary,
                              size: 16,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                Expanded(
                                  child: PviText(
                                    text: examName,
                                    style: AppFonts.body2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: PviText(
                              text: value,
                              style: AppFonts.body2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: range == 'ON_RANGE'
                                  ? AppColors.success
                                  : range == 'HIGH'
                                      ? AppColors.error
                                      : AppColors.warning,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ],
                      ),
                    );
                  }))
                else
                  PviText(
                      text: 'No se encontraron exámenes',
                      style: AppFonts.body1),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.gray4,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    spacing: 8,
                    children: [
                      const Icon(
                        LucideIcons.info,
                        color: AppColors.primary,
                      ),
                      Expanded(
                        child: PviText(
                          text:
                              'Estos resultados son una predicción y no un diagnóstico. Si tienes alguna duda, consulta con tu médico de confianza o con un especialista para obtener una interpretación más precisa.',
                          style: AppFonts.body1,
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
                    child: PviText(
                        text: 'Entendido',
                        style: AppFonts.body2.copyWith(color: Colors.white)),
                    onPressed: () =>
                        Navigator.restorablePushReplacementNamed(context, '/'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
