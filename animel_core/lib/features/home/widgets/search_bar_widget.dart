// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
    required this.onTap,
    required this.onFilterTap,
  });

  final VoidCallback onTap;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          height: 62,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: scheme.outlineVariant.withOpacity(isDark ? 0.5 : 0.85),
            ),
            boxShadow: AppShadows.soft(
              Colors.black,
              opacity: isDark ? 0.16 : 0.06,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.search_rounded, color: scheme.onSurfaceVariant),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Search animals, food, supplies...',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: scheme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconButton(
                  onPressed: onFilterTap,
                  icon: Icon(
                    Icons.tune_rounded,
                    color: scheme.primary,
                    size: 20,
                  ),
                  splashRadius: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
