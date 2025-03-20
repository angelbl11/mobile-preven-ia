import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_preven_ia_app/firebase/storage/mappers/analysis_data.dart';
import 'package:mobile_preven_ia_app/gemini/controllers/process_info_controller.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/screens/analysis-details/analysis_details_screen.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_error.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';

class ProcessingFileScreen extends ConsumerStatefulWidget {
  const ProcessingFileScreen({super.key});

  @override
  ProcessingFileScreenState createState() => ProcessingFileScreenState();
}

class ProcessingFileScreenState extends ConsumerState<ProcessingFileScreen> {
  bool _hasNavigated = false;
  late Future<AnalysisData?> _processInfoFuture;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
              {};
      final extractedText = args['extractedText'] as String? ?? '';
      final isUsingModel = args['isUsingModel'] as bool? ?? false;
      final rawParameterValues = args['parameterValues'];

      // Debug prints

      // Ensure parameterValues is a Map and handle null values
      Map<String, dynamic> parameterValues = {};
      if (rawParameterValues is Map) {
        parameterValues = Map<String, dynamic>.from(rawParameterValues);
      }

      // Ensure all parameter values are strings and not null
      final sanitizedParameterValues = <String, String>{};
      parameterValues.forEach((key, value) {
        if (value != null) {
          sanitizedParameterValues[key.toString()] = value.toString();
        }
      });

      _processInfoFuture = isUsingModel
          ? ref
              .read(processInfoControllerProvider.notifier)
              .analyzeTextWithModel(extractedText, sanitizedParameterValues)
          : ref
              .read(processInfoControllerProvider.notifier)
              .analyzeTextWithoutModel(extractedText);
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _processInfoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(
            child: Scaffold(
              body: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
                  child: Column(
                    spacing: 22,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lotties/processing-file.json',
                        width: 180,
                        height: 180,
                      ),
                      PviText(
                        text: 'Analizando parámetros clínicos',
                        style: AppFonts.headline2,
                      ),
                      PviText(
                        text: 'Esto puede tomar unos minutos',
                        style: AppFonts.caption,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return PviError(
            customMessage:
                'Error al analizar los parámetros: ${snapshot.error}',
          );
        }

        final analysisData = snapshot.data;
        if (analysisData == null) {
          return const PviError(
            customMessage: 'No se pudo obtener el análisis de los parámetros',
          );
        }

        if (!_hasNavigated) {
          _hasNavigated = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Ensure all data is properly formatted before passing
            final analysisMap = analysisData.toMap();

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const AnalysisDetailsScreen(),
                settings: RouteSettings(
                  arguments: {
                    'analysis': analysisMap,
                  },
                ),
              ),
              (route) => route.settings.name == '/',
            );
          });
          return const SizedBox.shrink();
        }

        return const SizedBox.shrink();
      },
    );
  }
}
