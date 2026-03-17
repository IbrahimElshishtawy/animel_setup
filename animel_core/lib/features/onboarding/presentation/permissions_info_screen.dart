import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/onboarding_frame.dart';

class PermissionsInfoScreen extends StatelessWidget {
  const PermissionsInfoScreen({super.key});

  void _continue(BuildContext context) {
    context.go('/welcome-auth');
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingFrame(
      stepLabel: 'Step 2 of 2',
      title: 'A few permissions help the community respond faster.',
      subtitle:
          'We only ask for what supports rescue updates, nearby alerts, and a smoother experience when time matters.',
      hero: OnboardingHeroCard(
        height: 176,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 290;

            if (compact) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Row(
                    children: [
                      Expanded(
                        child: _HeroInfoBubble(
                          icon: Icons.location_on_rounded,
                          label: 'Location',
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _HeroInfoBubble(
                          icon: Icons.notifications_active_rounded,
                          label: 'Alerts',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 48,
                    width: 48,
                    child: Image(
                      image: AssetImage('assets/image/image.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              );
            }

            return const Row(
              children: [
                Expanded(
                  child: _HeroInfoBubble(
                    icon: Icons.location_on_rounded,
                    label: 'Location',
                  ),
                ),
                SizedBox(width: 12),
                SizedBox(
                  height: 68,
                  width: 68,
                  child: Image(
                    image: AssetImage('assets/image/image.png'),
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _HeroInfoBubble(
                    icon: Icons.notifications_active_rounded,
                    label: 'Alerts',
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          OnboardingAccentPill(label: 'Private by design, useful by default'),
          SizedBox(height: 18),
          _PermissionCard(
            icon: Icons.location_searching_rounded,
            title: 'Location access',
            description:
                'Nearby matching helps lost pets reach the right people faster. Allowing location improves local rescue visibility and search accuracy.',
          ),
          SizedBox(height: 14),
          _PermissionCard(
            icon: Icons.notifications_none_rounded,
            title: 'Smart notifications',
            description:
                'Timely alerts keep you informed about missing pets, urgent rescue updates, and important community activity without needing to open the app.',
          ),
          SizedBox(height: 14),
          _PermissionCard(
            icon: Icons.security_rounded,
            title: 'You stay in control',
            description:
                'Permissions are requested transparently and can be adjusted anytime later from your device settings.',
          ),
        ],
      ),
      footer: Column(
        children: [
          OnboardingPrimaryButton(
            label: 'Continue to account',
            onPressed: () => _continue(context),
          ),
          const SizedBox(height: 12),
          Text(
            'Permissions will only be requested when they are needed.',
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

class _HeroInfoBubble extends StatelessWidget {
  const _HeroInfoBubble({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF4B1A45), size: 26),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4B1A45),
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  const _PermissionCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8DBE5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F4B1A45),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F1F6),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: const Color(0xFF4B1A45), size: 24),
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
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: Color(0xFF7D6A78),
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
