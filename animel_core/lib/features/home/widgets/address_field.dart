import 'package:flutter/material.dart';

class AddressField extends StatelessWidget {
  const AddressField({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.search_rounded,
          size: 20,
          color: scheme.primary,
        ),
        suffixIcon: Container(
          margin: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: scheme.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            Icons.tune_rounded,
            size: 18,
            color: scheme.primary,
          ),
        ),
        hintText: 'Search by city, breed, or pet type',
      ),
    );
  }
}
