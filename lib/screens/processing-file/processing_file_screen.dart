import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_preven_ia_app/gemini/controllers/process_info_controller.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/screens/analysis-details/analysis_details_screen.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class ProcessingFileScreen extends ConsumerWidget {
  const ProcessingFileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};
    final extractedText = args['extractedText'] as String? ?? '';
    final isUsingModel = args['isUsingModel'] as bool? ?? false;
    final parameterValues =
        args['parameterValues'] as Map<String, String>? ?? {};

    final processInfoFuture = ref
        .watch(processInfoControllerProvider.notifier)
        .analyzeTextWithoutModel(extractedText);

    return FutureBuilder(
      future: processInfoFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
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
          return const Center(child: Text('Error al analizar los parámetros.'));
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
                    Lottie.asset('assets/lotties/processing-file.json',
                        width: 180, height: 180),
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
