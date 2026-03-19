// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/logic/locale_bloc.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/app_media.dart';

class ChooseLanguageScreen extends StatefulWidget {
  const ChooseLanguageScreen({super.key});

  @override
  State<ChooseLanguageScreen> createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen> {
  late String _selectedLanguageCode;

  @override
  void initState() {
    super.initState();
    final locale = context.read<LocaleBloc>().state.locale;
    _selectedLanguageCode = locale?.languageCode ?? 'en';
  }

  void _continue() {
    context.read<LocaleBloc>().add(SetLocalePreference(_selectedLanguageCode));
    context.go('/permissions-info');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final options = const [
      _LanguageOption(
        code: 'en',
        title: 'English',
        subtitle: 'Clean and familiar interface copy',
        label: 'EN',
      ),
      _LanguageOption(
        code: 'ar',
        title: '\u0627\u0644\u0639\u0631\u0628\u064a\u0629',
        subtitle: 'Full Arabic interface with comfortable reading flow',
        label: 'AR',
      ),
    ];

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              scheme.primary.withOpacity(0.08),
              theme.scaffoldBackgroundColor,
              scheme.secondary.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(color: scheme.outlineVariant),
                      boxShadow: AppShadows.soft(Colors.black),
                    ),
                    child: const AppMedia(height: 82, width: 82),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    gradient: LinearGradient(
                      colors: [
                        scheme.primary,
                        Color.alphaBlend(
                          scheme.secondary.withOpacity(0.28),
                          scheme.primary,
                        ),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: AppShadows.soft(scheme.primary, opacity: 0.22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.14),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Text(
                          'Welcome to Animal Connect',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Choose the language that feels most natural before we personalise your experience.',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You can change this later from settings whenever you want.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.82),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Select language',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Built-in support is ready for both English and Arabic.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 18),
                ...options.map(
                  (option) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _LanguageCard(
                      option: option,
                      isSelected: option.code == _selectedLanguageCode,
                      onTap: () {
                        setState(() => _selectedLanguageCode = option.code);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _continue,
                    child: const Text('Continue'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final _LanguageOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: AnimatedContainer(
          duration: AppMotion.medium,
          curve: AppMotion.emphasized,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: isSelected ? scheme.primary : scheme.outlineVariant,
              width: isSelected ? 1.4 : 1,
            ),
            boxShadow: isSelected
                ? AppShadows.soft(scheme.primary, opacity: 0.14)
                : AppShadows.soft(Colors.black, opacity: 0.04),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: AppMotion.medium,
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: isSelected
                      ? scheme.primary.withOpacity(0.12)
                      : scheme.surfaceContainerHighest.withOpacity(0.75),
                ),
                child: Center(
                  child: Text(
                    option.label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isSelected
                          ? scheme.primary
                          : scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      option.subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              AnimatedContainer(
                duration: AppMotion.medium,
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? scheme.primary
                      : scheme.surfaceContainerHighest,
                ),
                child: Icon(
                  isSelected ? Icons.check_rounded : Icons.circle_outlined,
                  size: 16,
                  color: isSelected ? Colors.white : scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOption {
  const _LanguageOption({
    required this.code,
    required this.title,
    required this.subtitle,
    required this.label,
  });

  final String code;
  final String title;
  final String subtitle;
  final String label;
}
