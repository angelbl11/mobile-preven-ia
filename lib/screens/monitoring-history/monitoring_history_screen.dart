import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/firebase/storage/providers/fire_storage_analysis_controller.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/screens/home/widgets/clinical_results.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_error.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_loader.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';

class MonitoringHistoryScreen extends ConsumerWidget {
  const MonitoringHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref
          .read(fireStorageAnalysisControllerProvider.notifier)
          .getUserAnalyses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const PviLoader();
        } else if (snapshot.hasError) {
          return PviError(
            customMessage: 'Error al cargar datos: ${snapshot.error}',
          );
        } else if (snapshot.hasData) {
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
                      Visibility(
                        visible: snapshot.data!.isNotEmpty,
                        child: PviText(
                          text: 'Estos son tus resultados de tus monitoreos',
                          style: AppFonts.headline3,
                        ),
                      ),
                      if (snapshot.data!.isNotEmpty)
                        ...snapshot.data!.map(
                            (analysis) => ClinicalResults(analysis: analysis)),
                      if (snapshot.data!.isEmpty)
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
