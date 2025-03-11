import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_preven_ia_app/gemini/controllers/process_info_controller.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/screens/analysis-details/analysis_details_screen.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_error.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class ProcessingFileScreen extends ConsumerStatefulWidget {
  const ProcessingFileScreen({super.key});

  @override
  ProcessingFileScreenState createState() => ProcessingFileScreenState();
}

class ProcessingFileScreenState extends ConsumerState<ProcessingFileScreen> {
  bool _hasNavigated = false;
  late Future<Map<String, dynamic>?> _processInfoFuture;
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
      final parameterValues =
          args['parameterValues'] as Map<String, String>? ?? {};

      _processInfoFuture = isUsingModel
          ? ref
              .read(processInfoControllerProvider.notifier)
              .analyzeTextWithModel(extractedText, parameterValues)
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
        if (snapshot.hasData && !_hasNavigated) {
          _hasNavigated = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
              context,
              screen: const AnalysisDetailsScreen(),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.fade,
              settings: RouteSettings(arguments: {
                'analysis': snapshot.data,
              }),
            );
          });
          return const SizedBox.shrink();
        }
        if (snapshot.hasError) {
          return PviError(
            customMessage:
                'Error al analizar los parámetros: ${snapshot.error}',
          );
        }
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
      },
    );
  }
}
