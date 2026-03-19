// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/user_journey.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/app_button.dart';
import '../../auth/logic/auth_bloc.dart';

class JourneySetupScreen extends StatefulWidget {
  const JourneySetupScreen({super.key});

  @override
  State<JourneySetupScreen> createState() => _JourneySetupScreenState();
}

class _JourneySetupScreenState extends State<JourneySetupScreen> {
  UserJourney? _selectedJourney;
  String? _pendingRoute;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.read<AuthBloc>().state;
    if (_selectedJourney == null && state is Authenticated) {
      _selectedJourney = state.journey;
    }
  }

  void _saveAndContinue(UserJourney journey) {
    setState(() => _pendingRoute = journey.destinationRoute);
    context.read<AuthBloc>().add(JourneyUpdated(journey));
  }

  void _saveAndGoHome(UserJourney journey) {
    setState(() => _pendingRoute = '/home');
    context.read<AuthBloc>().add(JourneyUpdated(journey));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          final messenger = ScaffoldMessenger.of(context);
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message)));
          if (_pendingRoute != null && mounted) {
            setState(() => _pendingRoute = null);
          }
          return;
        }

        if (state is! Authenticated) return;
        final route = _pendingRoute;
        if (route == null) return;
        if (!state.hasCompletedJourney) return;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          setState(() => _pendingRoute = null);
          context.go(route);
        });
      },
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is! Authenticated) {
          return const Scaffold(body: SizedBox.shrink());
        }

        final selectedJourney = _selectedJourney;
        final isSaving = _pendingRoute != null;

        return Scaffold(
          backgroundColor: const Color(0xFFF4F4EF),
          body: SafeArea(
            child: ListView(
              padding: AppSpacing.screenPadding,
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    gradient: LinearGradient(
                      colors: [
                        scheme.primary,
                        Color.alphaBlend(
                          scheme.secondary.withOpacity(0.26),
                          scheme.primary,
                        ),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: AppShadows.soft(scheme.primary, opacity: 0.16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.14),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Text(
                          'Personalized start',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Welcome, ${state.user.name.split(' ').first}',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tell us how you want to use Animal Connect so we can shape a cleaner, more helpful experience from your first screen.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.86),
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'Choose your journey',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You can change this later from your profile. If you already have a pet, we will take you directly to create its profile.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 18),
                for (final journey in UserJourney.values) ...[
                  _JourneyCard(
                    journey: journey,
                    isSelected: selectedJourney == journey,
                    onTap: () => setState(() => _selectedJourney = journey),
                  ),
                  const SizedBox(height: 14),
                ],
                const SizedBox(height: 6),
                AppButton(
                  title:
                      selectedJourney?.primaryActionLabel ?? 'Choose one option',
                  onPressed: selectedJourney == null
                      ? () {}
                      : () => _saveAndContinue(selectedJourney),
                  isLoading: isSaving,
                  color: selectedJourney?.accent ?? scheme.outline,
                  borderRadius: 18,
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: isSaving || selectedJourney == null
                      ? null
                      : () => _saveAndGoHome(selectedJourney),
                  child: Text(
                    selectedJourney?.secondaryActionLabel ??
                        'Select a journey first',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _JourneyCard extends StatelessWidget {
  const _JourneyCard({
    required this.journey,
    required this.isSelected,
    required this.onTap,
  });

  final UserJourney journey;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: AnimatedContainer(
        duration: AppMotion.medium,
        curve: AppMotion.emphasized,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected
              ? journey.accent.withOpacity(0.1)
              : theme.cardColor.withOpacity(0.96),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isSelected ? journey.accent : scheme.outlineVariant,
            width: isSelected ? 1.4 : 1,
          ),
          boxShadow: isSelected
              ? AppShadows.soft(journey.accent, opacity: 0.12)
              : [],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: journey.accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(journey.icon, color: journey.accent, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    journey.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    journey.subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            AnimatedContainer(
              duration: AppMotion.medium,
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: isSelected ? journey.accent : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? journey.accent : scheme.outline,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
