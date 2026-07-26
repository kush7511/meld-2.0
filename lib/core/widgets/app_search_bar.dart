import 'package:flutter/material.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    required this.hint,
    this.onChanged,
    super.key,
  });

  final String hint;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      hintText: hint,
      onChanged: onChanged,
      elevation: const WidgetStatePropertyAll(0),
      backgroundColor: const WidgetStatePropertyAll(Colors.white),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      leading: const Icon(Icons.search_rounded),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
