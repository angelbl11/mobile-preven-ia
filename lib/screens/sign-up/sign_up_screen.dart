import 'package:flutter/gestures.dart';
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
import 'package:mobile_preven_ia_app/widgets/pvi_text_button.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text_input.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _submitted = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateFormValidity);
    _passwordController.addListener(_updateFormValidity);
    _confirmPasswordController.addListener(_updateFormValidity);
  }

  void _updateFormValidity() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    final emailValid = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);
    final passwordsMatch = password.isNotEmpty && (password == confirmPassword);

    final valid = emailValid && passwordsMatch;
    if (valid != _isFormValid) {
      setState(() {
        _isFormValid = valid;
      });
    }
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateFormValidity);
    _passwordController.removeListener(_updateFormValidity);
    _confirmPasswordController.removeListener(_updateFormValidity);
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _submitted = true;
    });
    if (_formKey.currentState?.validate() ?? false) {
      await StatusHandlerFunction.handleStatus(
        context: context,
        action: ref
            .read(fireAuthControllerProvider.notifier)
            .registerWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
        onSuccessCallBack: () {
          showToast(
            status: MessageStatus.success,
            context: context,
            message: 'Cuenta creada correctamente',
          );
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/health-info', (route) => false);
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
                autovalidateMode: _submitted
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                child: Column(
                  spacing: 22,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 150,
                        height: 150,
                      ),
                    ),
                    PviText(text: 'Crea tu cuenta', style: AppFonts.headline1),
                    PviText(
                        text: 'Ingresa tus datos para registrarte',
                        style: AppFonts.subtitle2),
                    PviTextInput(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      label: 'Correo electrónico',
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
                    PviPasswordInput(
                      controller: _passwordController,
                      prefixIcon: const Icon(
                        LucideIcons.lock,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      label: 'Contraseña',
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
                      controller: _confirmPasswordController,
                      prefixIcon: const Icon(
                        LucideIcons.lock,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      label: 'Confirmar contraseña',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirma tu contraseña';
                        }
                        if (value != _passwordController.text) {
                          return 'Las contraseñas no coinciden';
                        }
                        return null;
                      },
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: AppFonts.body1,
                        children: [
                          const TextSpan(
                            text: 'Al registrarte aceptas nuestros ',
                          ),
                          TextSpan(
                            text: 'Términos y condiciones',
                            style: AppFonts.button1.copyWith(
                                fontSize: 14, color: AppColors.primary),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                          const TextSpan(
                            text: ' y nuestra ',
                          ),
                          TextSpan(
                            text: 'Política de privacidad',
                            style: AppFonts.button1.copyWith(
                                fontSize: 14, color: AppColors.primary),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Acción a ejecutar al pulsar "Política de privacidad"
                              },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: PviButton(
                        onPressed:
                            _isFormValid ? () async => await _submit() : null,
                        child: PviText(
                          text: 'Crear cuenta',
                          style: AppFonts.button1.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PviText(
                            text: '¿Ya tienes una cuenta?',
                            style: AppFonts.body1),
                        PviTextButton(
                            onPressed: () =>
                                Navigator.pushReplacementNamed(context, '/'),
                            text: 'Inicia sesión',
                            textStyle: AppFonts.button1.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600)),
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
