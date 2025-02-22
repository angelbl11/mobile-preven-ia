import 'package:flutter/material.dart';
import 'package:mobile_preven_ia_app/cmd/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text.dart';

class PviTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;

  const PviTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.textStyle,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: padding ?? const EdgeInsets.all(8.0),
      ),
      onPressed: onPressed,
      child: PviText(text: text, style: textStyle ?? AppFonts.button1),
    );
  }
}
