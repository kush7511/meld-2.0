import 'package:flutter/material.dart';

class AppInputField extends StatelessWidget {
  const AppInputField({
    required this.label,
    this.hint,
    this.keyboardType,
    this.prefixIcon,
    this.obscureText = false,
    this.controller,
    this.onChanged,
    super.key,
  });

  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
      ),
    );
  }
}
