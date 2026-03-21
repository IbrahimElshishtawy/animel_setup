// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/app_media.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.userName,
    required this.subtitle,
    required this.onProfileTap,
    required this.onNotificationTap,
    this.profileImageUrl,
  });

  final String userName;
  final String subtitle;
  final String? profileImageUrl;
  final VoidCallback onProfileTap;
  final VoidCallback onNotificationTap;

  String get _greetingName {
    final trimmed = userName.trim();
    if (trimmed.isEmpty) {
      return 'User';
    }

    return trimmed.split(' ').first;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: scheme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  'Animal Connect',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Hello, $_greetingName',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        _HeaderActionButton(
          icon: Icons.notifications_none_rounded,
          onTap: onNotificationTap,
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: onProfileTap,
          child: Container(
            width: 54,
            height: 54,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  scheme.primary.withOpacity(0.95),
                  scheme.secondary.withOpacity(0.95),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: AppShadows.soft(scheme.primary, opacity: 0.16),
            ),
            child: ClipOval(
              child: DecoratedBox(
                decoration: BoxDecoration(color: theme.cardColor),
                child: profileImageUrl == null || profileImageUrl!.isEmpty
                    ? Icon(
                        Icons.person_rounded,
                        color: scheme.primary,
                        size: 26,
                      )
                    : AppMedia(imageUrl: profileImageUrl),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeaderActionButton extends StatelessWidget {
  const _HeaderActionButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: scheme.outlineVariant.withOpacity(0.8)),
            boxShadow: AppShadows.soft(Colors.black, opacity: 0.05),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(icon, color: scheme.onSurface, size: 24),
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: scheme.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
