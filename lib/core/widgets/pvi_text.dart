import 'package:flutter/material.dart';
import 'package:mobile_preven_ia_app/core/resources/app_design_system.dart';

class PviText extends StatelessWidget {
  const PviText({
    super.key,
    required this.text,
    this.variant = TextVariant.body1,
    this.textAlign,
    this.color,
  });

  final String text;
  final TextVariant variant;
  final TextAlign? textAlign;
  final Color? color;

  TextStyle _getStyle() {
    final baseStyle = switch (variant) {
      TextVariant.headline1 => AppDesignSystem.headline1,
      TextVariant.headline2 => AppDesignSystem.headline2,
      TextVariant.headline3 => AppDesignSystem.headline3,
      TextVariant.headline4 => AppDesignSystem.headline4,
      TextVariant.subtitle1 => AppDesignSystem.subtitle1,
      TextVariant.subtitle2 => AppDesignSystem.subtitle2,
      TextVariant.body1 => AppDesignSystem.body1,
      TextVariant.body2 => AppDesignSystem.body2,
      TextVariant.body3 => AppDesignSystem.body3,
      TextVariant.button1 => AppDesignSystem.button1,
      TextVariant.button2 => AppDesignSystem.button2,
      TextVariant.caption => AppDesignSystem.caption,
      TextVariant.link1 => AppDesignSystem.link1,
      TextVariant.link2 => AppDesignSystem.link2,
    };

    return color != null ? baseStyle.copyWith(color: color) : baseStyle;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: _getStyle(),
      textAlign: textAlign,
      textScaler: TextScaler.noScaling,
    );
  }
}

enum TextVariant {
  headline1,
  headline2,
  headline3,
  headline4,
  subtitle1,
  subtitle2,
  body1,
  body2,
  body3,
  button1,
  button2,
  caption,
  link1,
  link2,
}
