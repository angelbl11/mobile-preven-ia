import 'package:flutter/material.dart';
import 'package:mobile_preven_ia_app/cmd/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text.dart';

class PviButton extends StatelessWidget {
  const PviButton({super.key, required this.child, required this.onPressed});

  final PviText child;

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        disabledBackgroundColor: AppColors.disabled,
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: child,
    );
  }
}
