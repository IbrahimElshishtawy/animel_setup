import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/onboarding_frame.dart';

class ChooseLanguageScreen extends StatefulWidget {
  const ChooseLanguageScreen({super.key});

  @override
  State<ChooseLanguageScreen> createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen> {
  String _lang = 'en';

  void _continue() {
    context.go('/permissions-info');
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingFrame(
      stepLabel: 'Step 1 of 2',
      title: 'Choose the language that feels natural to you.',
      subtitle:
          'Start with the experience that fits you best. You can always update your preference later from settings.',
      hero: OnboardingHeroCard(
        height: 176,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 260;
            final logoSize = compact ? 58.0 : 70.0;
            final titleSize = compact ? 22.0 : 26.0;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: logoSize,
                  width: logoSize,
                  child: const Image(
                    image: AssetImage('assets/image/image.png'),
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: compact ? 8 : 10),
                FittedBox(
                  child: Text(
                    'HopePaw',
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF4B1A45),
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const OnboardingAccentPill(
            label: 'Smooth onboarding, tailored for you',
          ),
          const SizedBox(height: 18),
          ..._languageOptions.map(
            (option) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _LanguageCard(
                title: option.title,
                subtitle: option.subtitle,
                value: option.value,
                isSelected: _lang == option.value,
                onTap: () => setState(() => _lang = option.value),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Your selection only affects the interface language and can be changed anytime.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFF7D6A78),
              height: 1.5,
            ),
          ),
        ],
      ),
      footer: Column(
        children: [
          OnboardingPrimaryButton(label: 'Continue', onPressed: _continue),
          const SizedBox(height: 12),
          Text(
            'Quick setup takes less than a minute.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF7D6A78),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: isSelected ? const Color(0xFFF9EEF4) : Colors.white,
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF4B1A45)
                  : const Color(0xFFE8DBE5),
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: Color(0x124B1A45),
                      blurRadius: 22,
                      offset: Offset(0, 12),
                    ),
                  ]
                : const [],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF4B1A45)
                      : const Color(0xFFF7F1F6),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  value.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: isSelected ? Colors.white : const Color(0xFF4B1A45),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF31112D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.45,
                        color: Color(0xFF7D6A78),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? const Color(0xFF4B1A45)
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF4B1A45)
                        : const Color(0xFFCDB8C8),
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: Colors.white,
                      )
                    : null,
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
    required this.value,
    required this.title,
    required this.subtitle,
  });

  final String value;
  final String title;
  final String subtitle;
}

const _languageOptions = [
  _LanguageOption(
    value: 'en',
    title: 'English',
    subtitle: 'Clean and clear for the default app experience.',
  ),
  _LanguageOption(
    value: 'ar',
    title: 'العربية',
    subtitle: 'واجهة مريحة ومناسبة للقراءة باللغة العربية.',
  ),
];
