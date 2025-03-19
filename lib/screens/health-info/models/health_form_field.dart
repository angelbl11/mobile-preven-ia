import 'package:flutter/material.dart';

class HealthFormField {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final bool readOnly;
  final Function()? onTap;
  final String? Function(String?)? validator;
  final bool isRequired;

  HealthFormField({
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.readOnly = false,
    this.onTap,
    this.validator,
    this.isRequired = true,
  });
}
