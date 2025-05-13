import 'package:flutter/material.dart';
import 'package:mobile_preven_ia_app/core/resources/app_design_system.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text.dart';

class PviButton extends StatelessWidget {
  const PviButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
  });

  final PviText child;
  final void Function()? onPressed;
  final ButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case ButtonVariant.primary:
        return ElevatedButton(
          onPressed: onPressed,
          style: AppDesignSystem.primaryButtonStyle,
          child: child,
        );
      case ButtonVariant.secondary:
        return OutlinedButton(
          onPressed: onPressed,
          style: AppDesignSystem.secondaryButtonStyle,
          child: child,
        );
      case ButtonVariant.outline:
        return OutlinedButton(
          onPressed: onPressed,
          style: AppDesignSystem.secondaryButtonStyle,
          child: child,
        );
      case ButtonVariant.text:
        return TextButton(
          onPressed: onPressed,
          child: child,
        );
    }
  }
}

enum ButtonVariant {
  primary,
  secondary,
  outline,
  text,
}
