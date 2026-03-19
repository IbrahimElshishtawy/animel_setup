import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/logic/locale_bloc.dart';
import '../../../core/theme/app_tokens.dart';

class ProfileLanguageScreen extends StatelessWidget {
  const ProfileLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return BlocBuilder<LocaleBloc, LocaleState>(
      builder: (context, state) {
        final selectedCode = state.locale?.languageCode ?? 'en';
        final options = const [
          _LanguagePreference(
            code: 'en',
            title: 'English',
            subtitle: 'Default product copy and labels',
          ),
          _LanguagePreference(
            code: 'ar',
            title: 'العربية',
            subtitle: 'Arabic interface with right-to-left support',
          ),
        ];

        return Scaffold(
          appBar: AppBar(title: const Text('Language')),
          body: ListView(
            padding: AppSpacing.screenPadding,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: scheme.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose how Animal Connect speaks to you.',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your preference is saved on this device and applied across the app.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              ...options.map(
                (option) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: RadioListTile<String>(
                    value: option.code,
                    groupValue: selectedCode,
                    onChanged: (value) {
                      context.read<LocaleBloc>().add(
                        SetLocalePreference(value),
                      );
                    },
                    title: Text(
                      option.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      option.subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    tileColor: theme.cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      side: BorderSide(color: scheme.outlineVariant),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LanguagePreference {
  const _LanguagePreference({
    required this.code,
    required this.title,
    required this.subtitle,
  });

  final String code;
  final String title;
  final String subtitle;
}
