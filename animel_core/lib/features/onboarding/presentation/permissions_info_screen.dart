// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/app_media.dart';

class PermissionsInfoScreen extends StatelessWidget {
  const PermissionsInfoScreen({super.key});

  static const List<_PermissionItem> _permissions = [
    _PermissionItem(
      icon: Icons.location_on_outlined,
      title: 'Location access',
      subtitle:
          'Helps surface nearby pets, adopters, and trusted helpers around your area.',
    ),
    _PermissionItem(
      icon: Icons.notifications_none_rounded,
      title: 'Notifications',
      subtitle:
          'Keeps you informed about adoption requests, messages, and urgent rescue updates.',
    ),
    _PermissionItem(
      icon: Icons.chat_bubble_outline_rounded,
      title: 'Messaging',
      subtitle:
          'Makes seller, adopter, and helper conversations feel fast and reliable from day one.',
    ),
  ];

  void _onContinue(BuildContext context) {
    context.go('/welcome-auth');
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
                  scheme.tertiary.withOpacity(0.16),
                ],
              ),
            ),
          ),

          Positioned(
            top: -8,
            left: -38,
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
              color: scheme.tertiary.withOpacity(0.14),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  _GlassContainer(
                    padding: const EdgeInsets.all(12),
                    borderRadius: AppRadius.sm,
                    child: const AppMedia(height: 40, width: 40),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'A few quick permissions unlock the best experience.',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Animal Connect is designed to feel lightweight, but still be responsive when nearby help or updates matter most.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 26),

                  ..._permissions.map(
                    (permission) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _PermissionCard(permission: permission),
                    ),
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _onContinue(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('Continue to account setup'),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  const _PermissionCard({required this.permission});

  final _PermissionItem permission;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            color: theme.cardColor.withOpacity(0.12),
            border: Border.all(color: Colors.white.withOpacity(0.16), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      scheme.primary.withOpacity(0.22),
                      scheme.tertiary.withOpacity(0.14),
                    ],
                  ),
                  border: Border.all(color: scheme.primary.withOpacity(0.24)),
                ),
                child: Icon(permission.icon, color: scheme.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      permission.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      permission.subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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

class _PermissionItem {
  const _PermissionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;
}
