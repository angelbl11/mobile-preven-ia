import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_preven_ia_app/classes/message_status.dart';
import 'package:mobile_preven_ia_app/firebase/auth/providers/fire_auth_controller.dart';
import 'package:mobile_preven_ia_app/functions/show_toast.dart';
import 'package:mobile_preven_ia_app/functions/status_handler_function.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/screens/health-info/health_info_screen.dart';
import 'package:mobile_preven_ia_app/screens/sign-up/widgets/legal_links.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_form_button.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_password_input.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_redirect_links.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text_input.dart';

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
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

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HealthInfoScreen(),
            ),
            (route) => false,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode:
          _submitted ? AutovalidateMode.always : AutovalidateMode.disabled,
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
          const LegalLinks(),
          PviFormButton(
              onSubmit: _isFormValid ? () async => await _submit() : null,
              buttonText: 'Crear cuenta'),
          const PviRedirectLinks(isFromSignIn: false),
        ],
      ),
    );
  }
}
