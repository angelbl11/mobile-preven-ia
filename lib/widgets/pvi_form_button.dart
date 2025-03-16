import 'package:flutter/material.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_button.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';

class PviFormButton extends StatelessWidget {
  const PviFormButton(
      {super.key, required this.onSubmit, required this.buttonText});

  final void Function()? onSubmit;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: PviButton(
        onPressed: onSubmit,
        child: PviText(
          text: buttonText,
          style: AppFonts.button1.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
