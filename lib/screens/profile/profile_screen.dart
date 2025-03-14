import 'dart:io';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_preven_ia_app/classes/message_status.dart';
import 'package:mobile_preven_ia_app/firebase/auth/providers/fire_auth_controller.dart';
import 'package:mobile_preven_ia_app/firebase/classes/session_info.dart';
import 'package:mobile_preven_ia_app/firebase/storage/classes/user_profile.dart';
import 'package:mobile_preven_ia_app/firebase/storage/providers/fire_storage_user_controller.dart';
import 'package:mobile_preven_ia_app/functions/show_toast.dart';
import 'package:mobile_preven_ia_app/functions/status_handler_function.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/screens/verify-email/verify_email_screen.dart';
import 'package:mobile_preven_ia_app/utils/get_user_initials.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_error.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_loader.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text_button.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text_input.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});
  Future<Map<String, dynamic>> _getUserData(WidgetRef ref) async {
    final userProfile =
        await ref.watch(fireStorageUserControllerProvider.future);
    final authInfo = await ref.watch(fireAuthControllerProvider.future);
    return {
      'profile': userProfile,
      'auth': authInfo,
    };
  }

  Future<void> _pickAndUploadImage(WidgetRef ref, BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return;
    }
    final file = File(pickedFile.path);
    if (!context.mounted) return;
    StatusHandlerFunction.handleStatus(
        context: context,
        action: ref
            .read(fireStorageUserControllerProvider.notifier)
            .updateProfilePicture(file),
        onSuccessCallBack: () {
          ref.invalidate(fireStorageUserControllerProvider);
          showToast(
              status: MessageStatus.success,
              context: context,
              message: 'Imagen de perfil actualizada correctamente');
        });
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

          // Imagen por defecto
          return SafeArea(
            child: Scaffold(
              extendBody: true,
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                surfaceTintColor: AppColors.background,
                backgroundColor: AppColors.background,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
                  child: Column(
                    spacing: 18,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
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
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () => _pickAndUploadImage(ref, context),
                                child: const CircleAvatar(
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
                          ],
                        ),
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
                        style: AppFonts.headline3,
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
                                  fontSize: 14,
                                  color: AppColors.gray5,
                                  fontWeight: FontWeight.w600),
                            ),
                            PviText(
                              text:
                                  '${userProfile.name} ${userProfile.lastName} ${userProfile.maternalLastName}',
                              style: AppFonts.body1,
                            ),
                            PviText(
                              text: 'Fecha de nacimiento',
                              style: AppFonts.body1.copyWith(
                                  fontSize: 14,
                                  color: AppColors.gray5,
                                  fontWeight: FontWeight.w600),
                            ),
                            PviText(
                              text: userProfile.birthDate,
                              style: AppFonts.body1,
                            ),
                          ],
                        ),
                      ),
                      PviText(
                        text: 'Información de salud',
                        style: AppFonts.headline3,
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
                                  fontSize: 14,
                                  color: AppColors.gray5,
                                  fontWeight: FontWeight.w600),
                            ),
                            Row(
                              children: [
                                PviText(
                                    text: '${userProfile.weight.toString()} kg',
                                    style: AppFonts.body1),
                                IconButton(
                                  icon: const Icon(
                                    size: 20,
                                    LucideIcons.pen,
                                    color: AppColors.primary,
                                  ),
                                  onPressed: () {
                                    final weightController =
                                        TextEditingController(
                                      text: userProfile.weight.toString(),
                                    );
                                    final formKey = GlobalKey<FormState>();
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: AppColors.background,
                                          title: PviText(
                                            text: 'Editar peso',
                                            style: AppFonts.headline2,
                                          ),
                                          content: SizedBox(
                                            width: 300,
                                            child: Form(
                                              key: formKey,
                                              child: PviTextInput(
                                                controller: weightController,
                                                keyboardType:
                                                    TextInputType.number,
                                                label: 'Peso (kg)',
                                                prefixIcon: const Icon(
                                                  CommunityMaterialIcons
                                                      .weight_kilogram,
                                                  color: AppColors.primary,
                                                  size: 18,
                                                ),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.trim().isEmpty) {
                                                    return 'Ingresa un peso válido';
                                                  }
                                                  final weight =
                                                      double.tryParse(
                                                          value.replaceAll(
                                                              ',', '.'));
                                                  if (weight == null) {
                                                    return 'Ingresa un número válido';
                                                  }
                                                  if (weight < 30 ||
                                                      weight > 200) {
                                                    return 'El peso debe estar entre 30 y 200 kg';
                                                  }
                                                  if (weight ==
                                                      userProfile.weight) {
                                                    return 'El peso debe ser diferente al actual';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                          actions: [
                                            PviTextButton(
                                              onPressed: () {
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  final newWeight =
                                                      double.tryParse(
                                                          weightController
                                                              .text
                                                              .replaceAll(
                                                                  ',', '.'));
                                                  if (newWeight != null) {
                                                    StatusHandlerFunction
                                                        .handleStatus(
                                                            context: context,
                                                            action: ref
                                                                .read(fireStorageUserControllerProvider
                                                                    .notifier)
                                                                .updateUserWeight(
                                                                    newWeight),
                                                            onSuccessCallBack:
                                                                () {
                                                              ref.invalidate(
                                                                  fireStorageUserControllerProvider);
                                                              showToast(
                                                                  status:
                                                                      MessageStatus
                                                                          .success,
                                                                  context:
                                                                      context,
                                                                  message:
                                                                      'Peso actualizado correctamente');
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            });
                                                  }
                                                }
                                              },
                                              text: 'Aceptar',
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                            PviText(
                              text: 'Altura (m)',
                              style: AppFonts.body1,
                            ),
                            PviText(
                              text: '${userProfile.height.toString()} m',
                              style: AppFonts.body1,
                            ),
                            PviText(
                              text: 'Condiciones genéticas',
                              style: AppFonts.body1.copyWith(
                                  fontSize: 14,
                                  color: AppColors.gray5,
                                  fontWeight: FontWeight.w600),
                            ),
                            Visibility(
                              visible:
                                  userProfile.isGeneticRiskDiabetes == true,
                              child: PviText(
                                text: '- Diabetes',
                                style: AppFonts.body1,
                              ),
                            ),
                            Visibility(
                              visible:
                                  userProfile.isGeneticRiskHypertension == true,
                              child: PviText(
                                text: '- Hipertensión',
                                style: AppFonts.body1,
                              ),
                            ),
                            Visibility(
                              visible: userProfile.isGeneticRiskObesity == true,
                              child: PviText(
                                text: '- Obesidad',
                                style: AppFonts.body1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PviText(
                        text: 'Configuración de cuenta',
                        style: AppFonts.headline3,
                      ),
                      InkWell(
                        onTap: () => PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: const VerifyEmailScreen(),
                          withNavBar: false,
                          pageTransitionAnimation: PageTransitionAnimation.fade,
                        ),
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
                                  CommunityMaterialIcons.lock_reset,
                                  color: AppColors.primary,
                                  size: 25,
                                ),
                                PviText(
                                    text: 'Cambiar contraseña',
                                    style: AppFonts.body2),
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
                                    style: AppFonts.body2
                                        .copyWith(color: AppColors.error)),
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
