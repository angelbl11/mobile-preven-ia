import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/core/functions/status_handler_function.dart';
import 'package:mobile_preven_ia_app/core/providers/auth/auth0_controller.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_form_button.dart';
import 'package:mobile_preven_ia_app/core/domain/controllers/health-form/health_form_controller.dart';
import 'package:mobile_preven_ia_app/screens/health-info/health_info_screen.dart';
import 'package:mobile_preven_ia_app/screens/navigation-handler/navigation_handler_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:async';

class SignInForm extends ConsumerWidget {
  const SignInForm({super.key});

  Future<void> _handleAuthSuccess(BuildContext context, WidgetRef ref) async {
    await Future.delayed(const Duration(milliseconds: 250));
    if (!context.mounted) return;
    var completed = false;
    var step = 0;
    StatusHandlerFunction.handleStatus(
        action: () async {
          try {
            final response =
                await ref.read(healthFormControllerProvider.future);
            completed = response.completed;
            step = response.step.toInt();
            return response;
          } catch (e) {
            rethrow;
          }
        }(),
        context: context,
        onSuccessCallBack: () async {
          if (completed || step == 3) {
            Navigator.of(context).push(
              PageTransition(
                type: PageTransitionType.fade,
                duration: const Duration(milliseconds: 300),
                child: NavigationHandlerScreen(),
              ),
            );
          } else {
            Navigator.of(context).push(
              PageTransition(
                type: PageTransitionType.rightToLeft,
                duration: const Duration(milliseconds: 300),
                child: const HealthInfoScreen(),
              ),
            );
          }
        },
        onFailCallBack: (error) async {
          if (!context.mounted) return;

          if (error
              .toString()
              .contains('No se encontró el formulario de salud')) {
            Navigator.of(context).push(
              PageTransition(
                type: PageTransitionType.fade,
                duration: const Duration(milliseconds: 300),
                child: const HealthInfoScreen(),
              ),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      spacing: 18,
      children: [
        PviFormButton(
            onSubmit: () {
              StatusHandlerFunction.handleStatus(
                action: ref.read(auth0ControllerProvider.notifier).login(),
                context: context,
                onSuccessCallBack: () async {
                  await _handleAuthSuccess(context, ref);
                },
                onFailCallBack: (error) {
                  print('Error en login: $error');
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Error de inicio de sesión'),
                        content: Text(error.toString()),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Aceptar'),
                          ),
                        ],
                      ),
                    );
                  }
                },
              );
            },
            buttonText: 'Iniciar sesión'),
        PviFormButton(
            onSubmit: () {
              StatusHandlerFunction.handleStatus(
                action: ref.read(auth0ControllerProvider.notifier).register(),
                context: context,
                onSuccessCallBack: () async {
                  await _handleAuthSuccess(context, ref);
                },
                onFailCallBack: (error) {
                  print('Error en register: $error');
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Error de registro'),
                        content: Text(error.toString()),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Aceptar'),
                          ),
                        ],
                      ),
                    );
                  }
                },
              );
            },
            buttonText: 'Registrarse')
      ],
    );
  }
}
