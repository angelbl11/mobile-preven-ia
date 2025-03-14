import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/firebase/storage/providers/fire_storage_analysis_controller.dart';
import 'package:mobile_preven_ia_app/firebase/storage/providers/fire_storage_user_controller.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/screens/home/widgets/clinical_results.dart';
import 'package:mobile_preven_ia_app/screens/profile/profile_screen.dart';
import 'package:mobile_preven_ia_app/utils/get_user_initials.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_error.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_loader.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<Map<String, dynamic>> _getUserData(WidgetRef ref) async {
    final userProfile =
        await ref.watch(fireStorageUserControllerProvider.future);
    final analyses = await ref
        .watch(fireStorageAnalysisControllerProvider.notifier)
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
              body: Padding(
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
                          InkWell(
                            onTap: () =>
                                PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: const ProfileScreen(),
                              withNavBar: false,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.fade,
                            ),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: AppColors.secondary,
                              backgroundImage: userProfile.photoUrl != '' &&
                                      userProfile.photoUrl != null
                                  ? NetworkImage(userProfile.photoUrl ?? '')
                                  : null,
                              child: userProfile.photoUrl == null ||
                                      userProfile.photoUrl == ''
                                  ? Center(
                                      child: Text(
                                        getUserInitials(userProfile),
                                        style: AppFonts.headline3
                                            .copyWith(color: Colors.white),
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                          PviText(
                            text: '¡Hola, ${userProfile.name}!',
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
                        ...filteredAnalyses.map(
                            (analysis) => ClinicalResults(analysis: analysis)),
                      if (filteredAnalyses.isEmpty)
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
