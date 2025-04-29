import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_preven_ia_app/core/domain/controllers/health-files/health_files_controller.dart';
import 'package:mobile_preven_ia_app/core/domain/models/health_prediction.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_error.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text.dart';
import 'package:mobile_preven_ia_app/screens/blood-test-results/blood_test_results_screen.dart';

class ProcessingFileScreen extends ConsumerStatefulWidget {
  const ProcessingFileScreen({super.key});

  @override
  ProcessingFileScreenState createState() => ProcessingFileScreenState();
}

class ProcessingFileScreenState extends ConsumerState<ProcessingFileScreen> {
  late Future<HealthPrediction> _processInfoFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};
    final documentId = args['documentId'] as String? ?? '';
    final systolic = args['systolic'] as String? ?? '';
    final diastolic = args['diastolic'] as String? ?? '';

    _processInfoFuture = ref
        .read(healthFilesControllerProvider.notifier)
        .processHealthFile(
            documentId, double.parse(systolic), double.parse(diastolic));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _processInfoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        if (snapshot.hasError) {
          if (snapshot.error is DioException) {
            final response = snapshot.error as DioException;
            final message = response.response?.data['message'];
            return PviError(
              customMessage:
                  'Error al analizar los parámetros: ${message ?? snapshot.error}',
            );
          }
          return PviError(
            customMessage:
                'Error al analizar los parámetros: ${snapshot.error}',
          );
        }

        if (snapshot.hasData) {
          final healthPrediction = snapshot.data;
          return BloodTestResultsScreen(healthPrediction: healthPrediction!);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingState() {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lotties/processing-file.json',
                width: 180,
                height: 180,
              ),
              const PviText(
                text: 'Analizando parámetros clínicos',
                variant: TextVariant.headline2,
              ),
              const PviText(
                text: 'Esto puede tomar unos minutos',
                variant: TextVariant.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
