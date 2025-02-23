import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/cmd/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/cmd/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/core/domain/providers/pvi_controller.dart';
import 'package:mobile_preven_ia_app/core/functions/status_handler_function.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_button.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_password_input.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text_button.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text_input.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final loginFuture = ref.read(pviControllerProvider.notifier).login(
            phoneNumber: '+52${_phoneController.text}',
            password: _passwordController.text,
          );

      StatusHandlerFunction.handleStatus(
        action: loginFuture,
        context: context,
        onSuccessCallBack: () {
          print('Success');
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PviText(
                      text: 'Bienvenido de nuevo',
                      style: AppFonts.headline1,
                    ),
                    const SizedBox(height: 22),
                    PviText(
                      text: 'Inicia sesión para continuar',
                      style: AppFonts.subtitle2,
                    ),
                    const SizedBox(height: 22),
                    PviTextInput(
                      maxLength: 10,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      label: 'Número de télefono',
                      prefixIcon: const Icon(
                        Icons.phone,
                        color: AppColors.primary,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese su número de teléfono';
                        }
                        if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                          return 'El número debe ser de 10 dígitos';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 22),
                    PviPasswordInput(
                      controller: _passwordController,
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: AppColors.primary,
                      ),
                      label: 'Contraseña',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese su contraseña';
                        }
                        return null;
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: PviTextButton(
                        onPressed: () {
                          // Optionally navigate to forgot password screen
                        },
                        text: '¿Olvidaste tu contraseña?',
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: PviButton(
                        onPressed: _submit,
                        child: PviText(
                          text: 'Continuar',
                          style: AppFonts.button1.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PviText(
                          text: '¿No tienes una cuenta?',
                          style: AppFonts.body1,
                        ),
                        PviTextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/sign-up'),
                          text: 'Regístrate aquí',
                          textStyle: AppFonts.button1.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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
