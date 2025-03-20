import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_preven_ia_app/firebase/auth/providers/fire_auth_controller.dart';
import 'package:mobile_preven_ia_app/firebase/classes/user_step.dart';
import 'package:mobile_preven_ia_app/functions/status_handler_function.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/screens/health-info/health_info_screen.dart';
import 'package:mobile_preven_ia_app/screens/navigation-handler/navigation_handler_screen.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_form_button.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_password_input.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_redirect_links.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text_button.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text_input.dart';

class SignInForm extends ConsumerStatefulWidget {
  const SignInForm({super.key});

  @override
  ConsumerState<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends ConsumerState<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
    if (_formKey.currentState?.validate() ?? false) {
      UserStep? step;
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
          if (mounted) {
            if (step?.step == UserStepEnum.healthInfo) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HealthInfoScreen(),
                ),
                (route) => false,
              );
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => NavigationHandlerScreen(),
                ),
                (route) => false,
              );
            }
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        spacing: 22,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value.trim())) {
                return 'Ingresa un correo válido';
              }
              return null;
            },
          ),
          PviPasswordInput(
            onFieldSubmitted: (_) => _submit(),
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
              onPressed: () =>
                  Navigator.of(context).pushNamed('/forgot-password'),
              text: '¿Olvidaste tu contraseña?',
            ),
          ),
          PviFormButton(
              onSubmit: _isFormValid ? () async => await _submit() : null,
              buttonText: 'Iniciar sesión'),
          const PviRedirectLinks(isFromSignIn: true),
        ],
      ),
    );
  }
}
