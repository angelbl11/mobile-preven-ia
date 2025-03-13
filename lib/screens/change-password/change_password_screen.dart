import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_preven_ia_app/classes/message_status.dart';
import 'package:mobile_preven_ia_app/firebase/auth/providers/fire_auth_controller.dart';
import 'package:mobile_preven_ia_app/functions/show_toast.dart';
import 'package:mobile_preven_ia_app/functions/status_handler_function.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_button.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_password_input.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _passwordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      await StatusHandlerFunction.handleStatus(
        context: context,
        action: ref
            .read(
              fireAuthControllerProvider.notifier,
            )
            .changePassword(
              _passwordController.text,
              _newPasswordController.text,
            ),
        onSuccessCallBack: () {
          showToast(
              status: MessageStatus.success,
              context: context,
              message: 'Contraseña cambiada con éxito');
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/login', (route) => false);
        },
      );
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
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 22,
                  children: [
                    PviText(
                      textAlign: TextAlign.center,
                      text: 'Crea tu nueva contraseña',
                      style: AppFonts.headline2,
                    ),
                    PviText(
                        textAlign: TextAlign.center,
                        text: 'Elige una contraseña segura para tu cuenta',
                        style: AppFonts.subtitle2),
                    PviPasswordInput(
                      controller: _passwordController,
                      prefixIcon: const Icon(
                        LucideIcons.lock,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      label: 'Contraseña actual',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa una contraseña';
                        } else if (value.length < 6) {
                          return 'La contraseña debe tener al menos 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    PviPasswordInput(
                      onFieldSubmitted: (_) => _submit(),
                      controller: _newPasswordController,
                      prefixIcon: const Icon(
                        LucideIcons.lock,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      label: 'Nueva contraseña',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirma tu contraseña';
                        } else if (value.length < 6) {
                          return 'La contraseña debe tener al menos 6 caracteres';
                        }

                        return null;
                      },
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: PviButton(
                        child: PviText(
                          text: 'Cambiar contraseña',
                          style: AppFonts.button1
                              .copyWith(color: AppColors.background),
                        ),
                        onPressed: () => _submit(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
