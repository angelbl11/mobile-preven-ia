import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_preven_ia_app/core/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text_input.dart';

class PviPasswordInput extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final int? maxLength;
  final String? errorText;
  final String? label;
  final Color fillColor;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;

  const PviPasswordInput({
    super.key,
    this.onChanged,
    this.maxLength,
    this.errorText,
    this.label,
    this.fillColor = const Color(0xFFF5F5F5),
    this.prefixIcon,
    this.controller,
    this.validator,
    this.onFieldSubmitted,
  });

  @override
  PviPasswordInputState createState() => PviPasswordInputState();
}

class PviPasswordInputState extends State<PviPasswordInput> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() => _obscureText = !_obscureText);
  }

  @override
  Widget build(BuildContext context) {
    return PviTextInput(
      onFieldSubmitted: widget.onFieldSubmitted,
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: TextInputType.visiblePassword,
      onChanged: widget.onChanged,
      maxLength: widget.maxLength,
      errorText: widget.errorText,
      label: widget.label,
      fillColor: widget.fillColor,
      obscureText: _obscureText,
      prefixIcon: widget.prefixIcon,
      suffixIcon: IconButton(
        icon: Icon(
          size: 15,
          _obscureText ? LucideIcons.eyeClosed : LucideIcons.eye,
          color: AppColors.gray2,
        ),
        onPressed: _toggleVisibility,
      ),
    );
  }
}
