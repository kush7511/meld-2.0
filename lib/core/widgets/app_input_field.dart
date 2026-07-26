import 'package:flutter/material.dart';

class AppInputField extends StatelessWidget {
  const AppInputField({
    required this.label,
    this.hint,
    this.keyboardType,
    this.prefixIcon,
    this.obscureText = false,
    super.key,
  });

  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
