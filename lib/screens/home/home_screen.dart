import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/core/domain/controllers/health-files/health_files_controller.dart';
import 'package:mobile_preven_ia_app/core/domain/controllers/health-form/health_form_controller.dart';
import 'package:mobile_preven_ia_app/core/extensions/get_name_initials_extension.dart';
import 'package:mobile_preven_ia_app/core/providers/auth/auth0_controller.dart';
import 'package:mobile_preven_ia_app/core/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_error.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_form_button.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_loader.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_scaffold.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text.dart';
import 'package:mobile_preven_ia_app/screens/home/widgets/clinical_results.dart';
import 'package:mobile_preven_ia_app/screens/profile/profile_screen.dart';
import 'package:mobile_preven_ia_app/screens/upload-file/upload_file_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Future<void> _refreshData() async {
    ref.invalidate(healthFormControllerProvider);
    ref.invalidate(healthFilesControllerProvider);
  }

  @override
  Widget build(BuildContext context) {
    final healthFormAsync = ref.watch(healthFormControllerProvider);
    final healthFilesAsync = ref.watch(healthFilesControllerProvider);
    final userInfoAsync = ref.watch(
        auth0ControllerProvider.select((value) => value.credentials?.user));

    return healthFormAsync.when(
      loading: () => const PviLoader(),
      error: (error, stack) => PviError(
        customMessage: 'Error al cargar datos: $error',
      ),
      data: (healthInfo) {
        return healthFilesAsync.when(
          loading: () => const PviLoader(),
          error: (error, stack) => PviError(
            customMessage: 'Error al cargar análisis: $error',
          ),
          data: (healthFiles) {
            final filteredHealthFiles = healthFiles.length > 3
                ? healthFiles.sublist(0, 3)
                : healthFiles;

            return PviScaffold(
              screenContent: Column(
                spacing: 22,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Row(
                    spacing: 16,
                    children: [
                      GestureDetector(
                        onTap: () {
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: const ProfileScreen(),
                            withNavBar: false,
                            pageTransitionAnimation:
                                PageTransitionAnimation.fade,
                          );
                        },
                        child: CircleAvatar(
                          radius: 28,
                          backgroundImage: userInfoAsync?.pictureUrl != null
                              ? NetworkImage(
                                  userInfoAsync!.pictureUrl.toString())
                              : null,
                          backgroundColor: AppColors.primary,
                          child: userInfoAsync?.pictureUrl == null
                              ? PviText(
                                  text: healthInfo.name?.getInitials() ?? '',
                                  variant: TextVariant.headline2,
                                  color: AppColors.background,
                                )
                              : null,
                        ),
                      ),
                      PviText(
                        text: '¡Hola, ${healthInfo.name ?? ''}!',
                        variant: TextVariant.headline2,
                      ),
                    ],
                  ),
                  Visibility(
                    visible: filteredHealthFiles.isNotEmpty,
                    child: Column(
                      spacing: 24,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const PviText(
                          text: 'Estos son tus últimos resultados',
                          variant: TextVariant.headline3,
                        ),
                        ...filteredHealthFiles.map((healthFile) =>
                            ClinicalResults(prediction: healthFile)),
                      ],
                    ),
                  ),
                  if (filteredHealthFiles.isEmpty)
                    Column(
                      spacing: 24,
                      children: [
                        const PviText(
                          textAlign: TextAlign.center,
                          text:
                              'No tienes análisis clínicos por el momento, sube tus estudios para obtener resultados',
                          variant: TextVariant.body3,
                        ),
                        PviFormButton(
                          onSubmit: () {
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: const UploadFileScreen(),
                              withNavBar: true,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.fade,
                            );
                          },
                          buttonText: 'Subir ahora',
                        )
                      ],
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
