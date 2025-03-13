import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_preven_ia_app/classes/message_status.dart';
import 'package:mobile_preven_ia_app/firebase/auth/providers/fire_auth_controller.dart';
import 'package:mobile_preven_ia_app/functions/show_toast.dart';
import 'package:mobile_preven_ia_app/functions/status_handler_function.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_button.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text_input.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submitEmail() async {
    if (_formKey.currentState!.validate()) {
      StatusHandlerFunction.handleStatus(
          context: context,
          action: ref
              .read(fireAuthControllerProvider.notifier)
              .resetPassword(_emailController.text),
          onSuccessCallBack: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/login', (route) => false);
            showToast(
                status: MessageStatus.info,
                context: context,
                message:
                    'Se ha enviado un correo para restablecer tu contraseña');
          });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    text: 'Restablecer contraseña',
                    style: AppFonts.headline2,
                  ),
                  PviText(
                    textAlign: TextAlign.center,
                    text:
                        'Ingresa tu correo electrónico para restablecer tu contraseña',
                    style: AppFonts.subtitle2,
                  ),
                  PviTextInput(
                    onFieldSubmitted: (_) => _submitEmail(),
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

                      return null;
                    },
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: PviButton(
                      child: PviText(
                        text: 'Enviar correo',
                        style: AppFonts.button1
                            .copyWith(color: AppColors.background),
                      ),
                      onPressed: () => _submitEmail(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
