import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/firebase/storage/clinical-analysis/clinical_analysis_controller.dart';
import 'package:mobile_preven_ia_app/firebase/storage/user/user_controller.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/screens/home/widgets/clinical_results.dart';
import 'package:mobile_preven_ia_app/screens/profile/profile_screen.dart';
import 'package:mobile_preven_ia_app/utils/get_user_initials.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_error.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_loader.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_scaffold.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Future<void> _refreshData() async {
    ref.invalidate(userControllerProvider);
    ref.invalidate(clinicalAnalysisControllerProvider);
  }

  @override
  Widget build(BuildContext context) {
    final userProfileAsync = ref.watch(userControllerProvider);
    final analysesAsync = ref.watch(clinicalAnalysisControllerProvider);

    return userProfileAsync.when(
      loading: () => const PviLoader(),
      error: (error, stack) => PviError(
        customMessage: 'Error al cargar datos: $error',
      ),
      data: (userProfile) {
        return analysesAsync.when(
          loading: () => const PviLoader(),
          error: (error, stack) => PviError(
            customMessage: 'Error al cargar análisis: $error',
          ),
          data: (analyses) {
            final filteredAnalyses =
                analyses.length > 3 ? analyses.sublist(0, 3) : analyses;

            return PviScaffold(
              screenContent: Column(
                spacing: 22,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 16,
                    children: [
                      InkWell(
                        onTap: () => PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: const ProfileScreen(),
                          withNavBar: false,
                          pageTransitionAnimation: PageTransitionAnimation.fade,
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.secondary,
                          backgroundImage: userProfile?.photoUrl != '' &&
                                  userProfile?.photoUrl != null
                              ? NetworkImage(userProfile?.photoUrl ?? '')
                              : null,
                          child: userProfile?.photoUrl == null ||
                                  userProfile?.photoUrl == ''
                              ? Center(
                                  child: Text(
                                    getUserInitials(userProfile!),
                                    style: AppFonts.headline3
                                        .copyWith(color: Colors.white),
                                  ),
                                )
                              : null,
                        ),
                      ),
                      PviText(
                        text: '¡Hola, ${userProfile?.name}!',
                        style: AppFonts.headline2,
                      ),
                    ],
                  ),
                  Visibility(
                    visible: filteredAnalyses.isNotEmpty,
                    child: PviText(
                      text: 'Estos son tus últimos resultados',
                      style: AppFonts.headline3,
                    ),
                  ),
                  if (filteredAnalyses.isNotEmpty)
                    ...filteredAnalyses
                        .map((analysis) => ClinicalResults(analysis: analysis)),
                  if (filteredAnalyses.isEmpty)
                    PviText(
                      textAlign: TextAlign.center,
                      text:
                          'No tienes análisis clínicos por el momento, sube tus estudios para obtener resultados',
                      style: AppFonts.body3,
                    ),
                ],
              ),
              onRefresh: _refreshData,
            );
          },
        );
      },
    );
  }
}
