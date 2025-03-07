import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/firebase/storage/providers/fire_storage_analysis_controller.dart';
import 'package:mobile_preven_ia_app/firebase/storage/providers/fire_storage_user_controller.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/screens/home/widgets/clinical_results.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_error.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_loader.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<Map<String, dynamic>> _getUserData(WidgetRef ref) async {
    final userProfile =
        await ref.watch(fireStorageUserControllerProvider.future);
    final analyses = await ref
        .read(fireStorageAnalysisControllerProvider.notifier)
        .getUserAnalyses();
    return {
      'profile': userProfile,
      'analyses': analyses,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getUserData(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const PviLoader();
        } else if (snapshot.hasError) {
          return PviError(
            customMessage: 'Error al cargar datos: ${snapshot.error}',
          );
        } else if (snapshot.hasData) {
          final userProfile = snapshot.data!['profile'];
          final List<Map<String, dynamic>> analyses =
              snapshot.data!['analyses'] as List<Map<String, dynamic>>;

          final filteredAnalyses =
              analyses.length > 3 ? analyses.sublist(0, 3) : analyses;

          return SafeArea(
            child: Scaffold(
              extendBody: true,
              resizeToAvoidBottomInset: true,
              body: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 22,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          spacing: 16,
                          children: [
                            const CircleAvatar(
                              radius: 28,
                              backgroundImage:
                                  NetworkImage('https://i.pravatar.cc/300'),
                            ),
                            const SizedBox(width: 16),
                            PviText(
                              text: '¡Hola, ${userProfile.name}!',
                              style: AppFonts.headline2,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        PviText(
                          text: 'Estos son tus últimos resultados',
                          style: AppFonts.headline3,
                        ),
                        const SizedBox(height: 16),
                        ...filteredAnalyses
                            .map((analysis) =>
                                ClinicalResults(analysis: analysis))
                            .toList(),
                        const SizedBox(height: 100),
                      ],
                    ),
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
