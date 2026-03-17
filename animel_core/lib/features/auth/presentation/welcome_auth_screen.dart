// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'auth_shell.dart';

class WelcomeAuthScreen extends StatelessWidget {
  const WelcomeAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthPageShell(
      eyebrow: 'Animal care, rescue, and adoption',
      title: 'Because every paw deserves to find its way home.',
      subtitle:
          'A calm, thoughtful place to support rescues, reconnect lost pets, and stay close to the community around you.',
      hero: AuthHeroPanel(
        height: 188,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 290;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: compact ? 64 : 78,
                  width: compact ? 64 : 78,
                  child: const Image(
                    image: AssetImage('assets/image/image.png'),
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'HopePaw',
                  style: TextStyle(
                    color: authPrimary,
                    fontSize: compact ? 24 : 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    _HeroChip(label: 'Rescue alerts'),
                    _HeroChip(label: 'Lost & found'),
                    _HeroChip(label: 'Adoption care'),
                  ],
                ),
              ],
            );
          },
        ),
      ),
      footer: Column(
        children: [
          AuthPrimaryButton(
            label: 'Login',
            onPressed: () => context.go('/login'),
          ),
          const SizedBox(height: 12),
          AuthGhostButton(
            label: 'Create account',
            onPressed: () => context.go('/register'),
          ),
          const SizedBox(height: 12),
          AuthSocialButton(label: 'Continue with Google', onTap: () {}),
        ],
      ),
      child: const Column(
        children: [
          _FeatureTile(
            icon: Icons.favorite_border_rounded,
            title: 'Support the right mission',
            subtitle:
                'Track care, rescue activity, and local community updates in one polished experience.',
          ),
          SizedBox(height: 12),
          _FeatureTile(
            icon: Icons.location_searching_rounded,
            title: 'Stay close to nearby cases',
            subtitle:
                'Location-aware updates help people respond faster when pets go missing or need help.',
          ),
          SizedBox(height: 12),
          _FeatureTile(
            icon: Icons.pets_outlined,
            title: 'Designed for trust and care',
            subtitle:
                'A softer, cleaner flow that keeps the focus on helping animals and their people.',
          ),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8DBE5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F1F6),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: authPrimary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: authInk,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: authMuted,
                    height: 1.5,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.72),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: authPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
