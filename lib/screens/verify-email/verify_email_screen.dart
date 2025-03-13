import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_preven_ia_app/firebase/auth/providers/fire_auth_controller.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/screens/change-password/change_password_screen.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_button.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text_input.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => VerifyEmailScreenState();
}

class VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _verifyEmail(String authEmail) {
    if (_formKey.currentState!.validate()) {
      final inputEmail = _emailController.text.trim();
      if (inputEmail == authEmail) {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: const ChangePasswordScreen(),
          withNavBar: false,
          pageTransitionAnimation: PageTransitionAnimation.fade,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(fireAuthControllerProvider);

    return authAsync.when(
      data: (authInfo) {
        final authEmail = authInfo?.user.email;
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.background,
            ),
            extendBody: true,
            resizeToAvoidBottomInset: true,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 22,
                    children: [
                      Lottie.asset(
                        'assets/lotties/verify-identity.json',
                        width: 200,
                        height: 200,
                      ),
                      PviText(
                        textAlign: TextAlign.center,
                        text: 'Verifica tu identidad',
                        style: AppFonts.headline2,
                      ),
                      PviText(
                        textAlign: TextAlign.center,
                        text:
                            'Ingresa tu correo electrónico para verificar tu identidad',
                        style: AppFonts.subtitle2,
                      ),
                      PviTextInput(
                        onFieldSubmitted: (_) => _verifyEmail(authEmail!),
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        label: 'Ingresa tu correo electrónico',
                        prefixIcon: const Icon(
                          LucideIcons.mail,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ingresa un correo electrónico';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$')
                              .hasMatch(value.trim())) {
                            return 'Ingresa un correo válido';
                          }
                          if (value.trim() != authEmail) {
                            return 'El correo ingresado no coincide con el correo actual';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: PviButton(
                          child: PviText(
                            text: 'Verificar correo',
                            style: AppFonts.button1
                                .copyWith(color: AppColors.background),
                          ),
                          onPressed: () => _verifyEmail(authEmail!),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
