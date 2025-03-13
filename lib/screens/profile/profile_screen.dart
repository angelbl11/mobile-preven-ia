import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_preven_ia_app/firebase/auth/providers/fire_auth_controller.dart';
import 'package:mobile_preven_ia_app/firebase/classes/session_info.dart';
import 'package:mobile_preven_ia_app/firebase/storage/classes/user_profile.dart';
import 'package:mobile_preven_ia_app/firebase/storage/providers/fire_storage_user_controller.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_error.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_loader.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});
  Future<Map<String, dynamic>> _getUserData(WidgetRef ref) async {
    final userProfile =
        await ref.read(fireStorageUserControllerProvider.future);
    final authInfo = await ref.read(fireAuthControllerProvider.future);
    return {
      'profile': userProfile,
      'auth': authInfo,
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
              customMessage: 'Error al cargar datos: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final userProfile = snapshot.data!['profile'] as UserProfile;
          final authInfo = snapshot.data!['auth'] as SessionInfo;
          return SafeArea(
            child: Scaffold(
              extendBody: true,
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                backgroundColor: AppColors.background,
                title: PviText(text: 'Perfil', style: AppFonts.headline2),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
                  child: Column(
                    spacing: 18,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Stack(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                              child: CircleAvatar(
                                radius: 50,
                                foregroundColor: AppColors.primary,
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      NetworkImage('https://i.pravatar.cc/300'),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: CircleAvatar(
                                      backgroundColor: AppColors.primary,
                                      radius: 15.0,
                                      child: Icon(
                                        LucideIcons.camera,
                                        size: 15.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            PviText(
                              text:
                                  '${userProfile.name} ${userProfile.lastName}',
                              style: AppFonts.headline3,
                            ),
                            PviText(
                              text: '${authInfo.user.email}',
                              style: AppFonts.subtitle2.copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      PviText(
                        text: 'Información personal',
                        style: AppFonts.headline2.copyWith(fontSize: 14),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.gray4,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          spacing: 8,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PviText(
                              text: 'Nombre completo',
                              style: AppFonts.body1.copyWith(
                                  fontSize: 12, color: AppColors.gray5),
                            ),
                            PviText(
                              text:
                                  '${userProfile.name} ${userProfile.lastName} ${userProfile.maternalLastName}',
                              style: AppFonts.body1.copyWith(fontSize: 12),
                            ),
                            PviText(
                              text: 'Fecha de nacimiento',
                              style: AppFonts.body1.copyWith(
                                  fontSize: 12, color: AppColors.gray5),
                            ),
                            PviText(
                              text: userProfile.birthDate,
                              style: AppFonts.body1.copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      PviText(
                        text: 'Información de salud',
                        style: AppFonts.headline2.copyWith(fontSize: 14),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.gray4,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          spacing: 8,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PviText(
                              text: 'Peso (kg)',
                              style: AppFonts.body1.copyWith(
                                  fontSize: 12, color: AppColors.gray5),
                            ),
                            PviText(
                              text: '${userProfile.weight.toString()} kg',
                              style: AppFonts.body1.copyWith(fontSize: 12),
                            ),
                            PviText(
                              text: 'Altura (m)',
                              style: AppFonts.body1.copyWith(
                                  fontSize: 12, color: AppColors.gray5),
                            ),
                            PviText(
                              text: '${userProfile.height.toString()} m',
                              style: AppFonts.body1.copyWith(fontSize: 12),
                            ),
                            PviText(
                              text: 'Condiciones genéticas',
                              style: AppFonts.body1.copyWith(
                                  fontSize: 12, color: AppColors.gray5),
                            ),
                            PviText(
                              text: userProfile.isGeneticRiskDiabetes == true
                                  ? 'Diabetes'
                                  : 'Ninguna',
                              style: AppFonts.body1.copyWith(fontSize: 12),
                            ),
                            PviText(
                              text:
                                  userProfile.isGeneticRiskHypertension == true
                                      ? 'Hipertensión'
                                      : 'Ninguna',
                              style: AppFonts.body1.copyWith(fontSize: 12),
                            ),
                            PviText(
                              text: userProfile.isGeneticRiskObesity == true
                                  ? 'Obesidad'
                                  : 'Ninguna',
                              style: AppFonts.body1.copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      PviText(
                        text: 'Información personal',
                        style: AppFonts.headline2.copyWith(fontSize: 14),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.gray4,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          spacing: 8,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PviText(
                              text: 'Nombre completo',
                              style: AppFonts.body1.copyWith(
                                  fontSize: 12, color: AppColors.gray5),
                            ),
                            PviText(
                              text:
                                  '${userProfile.name} ${userProfile.lastName} ${userProfile.maternalLastName}',
                              style: AppFonts.body1.copyWith(fontSize: 12),
                            ),
                            PviText(
                              text: 'Fecha de nacimiento',
                              style: AppFonts.body1.copyWith(
                                  fontSize: 12, color: AppColors.gray5),
                            ),
                            PviText(
                              text: userProfile.birthDate,
                              style: AppFonts.body1.copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      PviText(
                        text: 'Configuración de cuenta',
                        style: AppFonts.headline2.copyWith(fontSize: 14),
                      ),
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.gray4,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            spacing: 8,
                            children: [
                              const Icon(
                                CommunityMaterialIcons.lock_reset,
                                color: AppColors.primary,
                                size: 25,
                              ),
                              PviText(
                                  text: 'Cambiar contraseña',
                                  style: AppFonts.body2.copyWith(fontSize: 12)),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.gray4,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: const Icon(
                                  LucideIcons.chevronRight,
                                  color: AppColors.gray5,
                                  size: 20,
                                ),
                              ),
                            ],
                          )),
                      InkWell(
                        onTap: () => {
                          ref
                              .read(fireAuthControllerProvider.notifier)
                              .signOut(),
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login', (route) => false)
                        },
                        child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.gray4,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              spacing: 8,
                              children: [
                                const Icon(
                                  LucideIcons.logOut,
                                  color: AppColors.error,
                                  size: 20,
                                ),
                                PviText(
                                    text: 'Cerrar sesión',
                                    style: AppFonts.body2.copyWith(
                                        fontSize: 12, color: AppColors.error)),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.gray4,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Icon(
                                    LucideIcons.chevronRight,
                                    color: AppColors.gray5,
                                    size: 20,
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
