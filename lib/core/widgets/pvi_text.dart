import 'package:flutter/material.dart';

class PviText extends StatelessWidget {
  const PviText(
      {super.key, required this.text, required this.style, this.textAlign});

  final String text;
  final TextStyle style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: style, textAlign: textAlign);
  }
}
