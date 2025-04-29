import 'package:flutter/material.dart';
import 'package:mobile_preven_ia_app/core/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_button.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text.dart';

class PviFormButton extends StatelessWidget {
  const PviFormButton({
    super.key,
    required this.onSubmit,
    required this.buttonText,
    this.buttonVariant,
    this.isFullWidth = true,
    this.buttonColor,
  });

  final void Function()? onSubmit;
  final String buttonText;
  final ButtonVariant? buttonVariant;
  final bool isFullWidth;
  final Color? buttonColor;
  @override
  Widget build(BuildContext context) {
    final button = PviButton(
      variant: buttonVariant ?? ButtonVariant.primary,
      onPressed: onSubmit,
      child: PviText(
        text: buttonText,
        variant: TextVariant.button1,
        color: buttonColor ??
            (buttonVariant == ButtonVariant.secondary
                ? AppColors.primary
                : AppColors.background),
      ),
    );

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: button,
      );
    }

    return SizedBox(
      height: 56,
      child: button,
    );
  }
}
