// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';

const _backgroundTop = Color(0xFFFFF5F0);
const _backgroundBottom = Color(0xFFF5E9F3);
const _surfaceColor = Color(0xFFFDF8FB);
const _primaryColor = Color(0xFF4B1A45);
const _accentColor = Color(0xFFE27D60);

class OnboardingFrame extends StatelessWidget {
  const OnboardingFrame({
    super.key,
    required this.stepLabel,
    required this.title,
    required this.subtitle,
    required this.hero,
    required this.body,
    required this.footer,
  });

  final String stepLabel;
  final String title;
  final String subtitle;
  final Widget hero;
  final Widget body;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_backgroundTop, Colors.white, _backgroundBottom],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            const _BackgroundGlow(
              alignment: Alignment.topRight,
              color: Color(0x33E27D60),
              size: 220,
            ),
            const _BackgroundGlow(
              alignment: Alignment.bottomLeft,
              color: Color(0x334B1A45),
              size: 260,
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 460),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                          decoration: BoxDecoration(
                            color: _surfaceColor.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.7),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x1A4B1A45),
                                blurRadius: 30,
                                offset: Offset(0, 14),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _StepBadge(label: stepLabel),
                              const SizedBox(height: 24),
                              Center(child: hero),
                              const SizedBox(height: 28),
                              Text(
                                title,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: _primaryColor,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                subtitle,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: const Color(0xFF6D5968),
                                  height: 1.55,
                                ),
                              ),
                              const SizedBox(height: 24),
                              body,
                              const SizedBox(height: 24),
                              footer,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingHeroCard extends StatelessWidget {
  const OnboardingHeroCard({super.key, required this.child, this.height = 172});

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFFF9EAE4), Color(0xFFF2E4F1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12E27D60),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 6,
            right: 12,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 8,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.35),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class OnboardingPrimaryButton extends StatelessWidget {
  const OnboardingPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class OnboardingAccentPill extends StatelessWidget {
  const OnboardingAccentPill({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFCEEE8),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Wrap(
        spacing: 6,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Icon(Icons.auto_awesome_rounded, size: 16, color: _accentColor),
          Text(
            label,
            style: const TextStyle(
              color: _accentColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepBadge extends StatelessWidget {
  const _StepBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFEBD9E8)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: _accentColor,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: _primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundGlow extends StatelessWidget {
  const _BackgroundGlow({
    required this.alignment,
    required this.color,
    required this.size,
  });

  final Alignment alignment;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, Colors.transparent]),
        ),
      ),
    );
  }
}
