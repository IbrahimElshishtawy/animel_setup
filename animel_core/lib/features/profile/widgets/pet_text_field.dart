import 'package:flutter/material.dart';

class PetTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType keyboardType;
  final IconData? suffixIcon;
  final bool readOnly;
  final VoidCallback? onTap;
  final Localizations? localizations;

  const PetTextField({
    super.key,
    required this.label,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
    this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      readOnly: readOnly,
      keyboardType: keyboardType,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xFF7A6D6F),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: suffixIcon == null ? null : Icon(suffixIcon, size: 18),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE8E0D7), width: 1.1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE8E0D7), width: 1.1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF7E452A), width: 1.4),
        ),
      ),
    );
  }
}
