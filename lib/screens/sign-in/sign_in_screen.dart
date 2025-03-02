import 'package:community_material_icon/community_material_icon.dart';
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

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Track basic validity (for enabling the button) using our own logic.
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateFormValidity);
    _passwordController.addListener(_updateFormValidity);
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateFormValidity);
    _passwordController.removeListener(_updateFormValidity);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _updateFormValidity() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    // Use simple criteria to enable the button.
    final emailValid =
        email.isNotEmpty && RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);
    final valid = emailValid && password.isNotEmpty;
    if (valid != _isFormValid) {
      setState(() {
        _isFormValid = valid;
      });
    }
  }

  Future<void> _submit() async {
    // Validate the form: this will display error messages if invalid.
    if (_formKey.currentState?.validate() ?? false) {
      String? step;
      await StatusHandlerFunction.handleStatus(
        context: context,
        action: () async {
          final res = await ref
              .read(fireAuthControllerProvider.notifier)
              .signInWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text,
              );
          step = res?.nextStep;
        }(),
        onSuccessCallBack: () {
          if (step == 'health-info') {
            Navigator.pushNamed(context, '/health-info');
          } else {
            showToast(
                status: MessageStatus.success,
                context: context,
                message: 'Inicio de sesión exitoso');
          }
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
                // Do not autovalidate; errors only show on submit.
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 350,
                        height: 80,
                      ),
                    ),
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
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      label: 'Correo electrónico',
                      prefixIcon: const Icon(
                        LucideIcons.mail,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      // No onChanged validation trigger for errors (we use our own logic for the button).
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
                    const SizedBox(height: 22),
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
                          return 'Ingrese su contraseña';
                        }
                        return null;
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: PviTextButton(
                        onPressed: () {
                          // Optionally navigate to forgot password screen.
                        },
                        text: '¿Olvidaste tu contraseña?',
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: PviButton(
                        // Enable the button only when the form is ready based on our simple validity.
                        onPressed:
                            _isFormValid ? () async => await _submit() : null,
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
