// ignore_for_file: deprecated_member_use

import 'dart:ui';

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
  static const List<_LanguageOption> _options = [
    _LanguageOption(
      code: 'en',
      title: 'English',
      subtitle: 'Clean and familiar interface copy',
      label: 'EN',
    ),
    _LanguageOption(
      code: 'ar',
      title: 'العربية',
      subtitle: 'Full Arabic interface with comfortable reading flow',
      label: 'AR',
    ),
  ];

  late String _selectedLanguageCode;

  @override
  void initState() {
    super.initState();
    final locale = context.read<LocaleBloc>().state.locale;
    _selectedLanguageCode = locale?.languageCode ?? 'en';
  }

  void _onContinue() {
    context.read<LocaleBloc>().add(SetLocalePreference(_selectedLanguageCode));
    context.go('/permissions-info');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  scheme.primary.withOpacity(0.22),
                  theme.scaffoldBackgroundColor,
                  scheme.secondary.withOpacity(0.16),
                ],
              ),
            ),
          ),

          Positioned(
            top: -60,
            left: -40,
            child: _BlurCircle(
              size: 180,
              color: scheme.primary.withOpacity(0.16),
            ),
          ),

          Positioned(
            bottom: -70,
            right: -30,
            child: _BlurCircle(
              size: 200,
              color: scheme.secondary.withOpacity(0.14),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: AppSpacing.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),

                    Center(
                      child: _GlassContainer(
                        padding: const EdgeInsets.all(24),
                        borderRadius: AppRadius.sm,
                        child: const AppMedia(height: 84, width: 84),
                      ),
                    ),

                    const SizedBox(height: 28),

                    Text(
                      'Select language',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Choose your preferred language to continue with a smooth and comfortable experience.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                        height: 1.45,
                      ),
                    ),

                    const SizedBox(height: 24),

                    ..._options.map(
                      (option) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _LanguageCard(
                          option: option,
                          isSelected: option.code == _selectedLanguageCode,
                          onTap: () {
                            if (_selectedLanguageCode == option.code) return;
                            setState(() => _selectedLanguageCode = option.code);
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _onContinue,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                          elevation: 0,
                        ),
                        child: const Text('Continue'),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
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
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: AnimatedContainer(
          duration: AppMotion.medium,
          curve: AppMotion.emphasized,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  color: theme.cardColor.withOpacity(isSelected ? 0.22 : 0.12),
                  border: Border.all(
                    color: isSelected
                        ? scheme.primary.withOpacity(0.75)
                        : Colors.white.withOpacity(0.16),
                    width: isSelected ? 1.4 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? scheme.primary.withOpacity(0.16)
                          : Colors.black.withOpacity(0.05),
                      blurRadius: isSelected ? 22 : 12,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: AppMotion.medium,
                      curve: AppMotion.emphasized,
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isSelected
                              ? [
                                  scheme.primary.withOpacity(0.22),
                                  scheme.secondary.withOpacity(0.16),
                                ]
                              : [
                                  Colors.white.withOpacity(0.10),
                                  Colors.white.withOpacity(0.04),
                                ],
                        ),
                        border: Border.all(
                          color: isSelected
                              ? scheme.primary.withOpacity(0.35)
                              : Colors.white.withOpacity(0.10),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          option.label,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: isSelected
                                ? scheme.primary
                                : scheme.onSurfaceVariant,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
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
                          const SizedBox(height: 5),
                          Text(
                            option.subtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    AnimatedContainer(
                      duration: AppMotion.medium,
                      curve: AppMotion.emphasized,
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? scheme.primary
                            : Colors.white.withOpacity(0.10),
                        border: Border.all(
                          color: isSelected
                              ? scheme.primary
                              : scheme.outlineVariant.withOpacity(0.5),
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: scheme.primary.withOpacity(0.24),
                                  blurRadius: 14,
                                  offset: const Offset(0, 6),
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        isSelected
                            ? Icons.check_rounded
                            : Icons.circle_outlined,
                        size: 16,
                        color: isSelected
                            ? Colors.white
                            : scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassContainer extends StatelessWidget {
  const _GlassContainer({
    required this.child,
    required this.padding,
    required this.borderRadius,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: theme.cardColor.withOpacity(0.14),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.white.withOpacity(0.14)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _BlurCircle extends StatelessWidget {
  const _BlurCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
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
