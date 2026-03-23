// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:flutter/src/services/text_formatter.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscure = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.validator,
    this.textInputAction,
    this.autofillHints,
    this.onSubmitted,
    this.inputFormatters,
    this.readOnly = false,
    this.enabled = true,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscure;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            color: scheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          enabled: enabled,
          readOnly: readOnly,
          keyboardType: keyboardType,
          obscureText: obscure,
          maxLines: obscure ? 1 : maxLines,
          validator: validator,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          onFieldSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
