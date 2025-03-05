import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';

class AnalysisDetailsScreen extends ConsumerWidget {
  const AnalysisDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtener el análisis pasado en los argumentos de la ruta.
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};
    final analysisData = args['analysis'] as Map<String, dynamic>?;

    return SafeArea(
      child: Scaffold(
        body: analysisData == null
            ? Center(
                child: PviText(
                    text: 'No se encontró análisis', style: AppFonts.body1))
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
                child: ListView(
                  children: [
                    PviText(
                        text: 'Estos son tus resultados',
                        style: AppFonts.headline1),
                    PviText(
                        text: 'ID: ${analysisData['id']}',
                        style: AppFonts.body1),
                    PviText(
                        text:
                            'Creado: ${analysisData['created_at'] ?? 'Desconocido'}',
                        style: AppFonts.body1),
                    PviText(
                        text:
                            'Diagnóstico: ${analysisData['diagnostico'] ?? 'Sin datos'}',
                        style: AppFonts.body1),
                  ],
                ),
              ),
      ),
    );
  }
}
