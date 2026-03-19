import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/app_media.dart';

class PermissionsInfoScreen extends StatelessWidget {
  const PermissionsInfoScreen({super.key});

  void _continue(BuildContext context) {
    context.go('/welcome-auth');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final permissions = const [
      (
        Icons.location_on_outlined,
        'Location access',
        'Helps surface nearby pets, adopters, and trusted helpers around your area.',
      ),
      (
        Icons.notifications_none_rounded,
        'Notifications',
        'Keeps you informed about adoption requests, messages, and urgent rescue updates.',
      ),
      (
        Icons.chat_bubble_outline_rounded,
        'Messaging',
        'Makes seller, adopter, and helper conversations feel fast and reliable from day one.',
      ),
    ];

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              scheme.primary.withOpacity(0.08),
              theme.scaffoldBackgroundColor,
              scheme.tertiary.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: AppSpacing.screenPadding,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: scheme.outlineVariant),
                    ),
                    child: const AppMedia(height: 40, width: 40),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'A few quick permissions unlock the best experience.',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Animal Connect is designed to feel lightweight, but still be responsive when nearby help or updates matter most.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              ...permissions.map(
                (permission) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: scheme.outlineVariant),
                      boxShadow: AppShadows.soft(Colors.black, opacity: 0.04),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: scheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(permission.$1, color: scheme.primary),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                permission.$2,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                permission.$3,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _continue(context),
                  child: const Text('Continue to account setup'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
