import 'package:flutter/material.dart';
import 'package:mobile_preven_ia_app/core/resources/app_design_system.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text.dart';

class PviTextInput extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final TextInputType keyboardType;
  final int? maxLength;
  final String? errorText;
  final String? label;
  final Color fillColor;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final bool readOnly;
  final void Function(String)? onFieldSubmitted;

  const PviTextInput({
    super.key,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.errorText,
    this.label,
    this.fillColor = AppDesignSystem.background,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.onTap,
    this.readOnly = false,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: onFieldSubmitted,
      readOnly: readOnly,
      onTap: onTap,
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      keyboardType: keyboardType,
      maxLength: maxLength,
      obscureText: obscureText,
      decoration: AppDesignSystem.textInputDecoration.copyWith(
        counterText: '',
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        label: label != null
            ? PviText(
                text: label!,
                variant: TextVariant.body3,
              )
            : null,
        errorText: errorText,
      ),
    );
  }
}
