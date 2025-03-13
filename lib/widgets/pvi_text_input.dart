import 'package:flutter/material.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';

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
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final InputBorder? errorBorder;
  const PviTextInput({
    super.key,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.errorText,
    this.label,
    this.fillColor = AppColors.gray4,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.onTap,
    this.readOnly = false,
    this.onFieldSubmitted,
    this.border,
    this.focusedBorder,
    this.enabledBorder,
    this.errorBorder,
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
      decoration: InputDecoration(
        counterText: '',
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: fillColor,
        label: label != null
            ? PviText(
                text: label!,
                style: AppFonts.caption
                    .copyWith(fontSize: 14, color: AppColors.gray3),
              )
            : null,
        border: border ??
            OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(12),
            ),
        focusedBorder: focusedBorder ??
            OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(12),
            ),
        enabledBorder: enabledBorder ??
            OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(12),
            ),
        errorBorder: errorBorder ??
            const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.error),
            ),
        errorText: errorText,
        errorStyle: AppFonts.caption.copyWith(
          color: AppColors.error,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
