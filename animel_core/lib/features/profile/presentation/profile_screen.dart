// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/logic/locale_bloc.dart';
import '../../../core/models/user_journey.dart';
import '../../../core/models/user_model.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/logic/theme_bloc.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../auth/logic/auth_bloc.dart';
import '../../home/logic/animal_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated) {
        context.read<AnimalBloc>().add(FetchMyAnimals());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.go('/welcome-auth');
        }
      },
      child: Scaffold(
        bottomNavigationBar: const AppBottomNavBar(currentIndex: 4),
        body: SafeArea(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              if (authState is AuthLoading || authState is AuthInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (authState is! Authenticated) {
                return const SizedBox.shrink();
              }

              final user = authState.user;
              final journey = authState.journey;
              final localeCode =
                  context.watch<LocaleBloc>().state.locale?.languageCode ?? 'en';
              final isDark =
                  context.watch<ThemeBloc>().state.themeMode == ThemeMode.dark;

              return BlocBuilder<AnimalBloc, AnimalState>(
                builder: (context, animalState) {
                  final myPets = animalState.myAnimals;
                  final adoptionCount =
                      myPets.where((animal) => animal.isForAdoption).length;
                  final saleCount =
                      myPets.where((animal) => !animal.isForAdoption).length;

                  return CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: AppSpacing.screenPadding,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _ProfileHeroCard(
                                user: user,
                                journey: journey,
                                localeCode: localeCode,
                              ),
                              const SizedBox(height: 18),
                              Row(
                                children: [
                                  Expanded(
                                    child: _ProfileStatCard(
                                      value: '${myPets.length}',
                                      label: 'Pets',
                                      accent: AppPalette.plum,
                                      icon: Icons.pets_rounded,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _ProfileStatCard(
                                      value: '$adoptionCount',
                                      label: 'Adoption',
                                      accent: AppPalette.magenta,
                                      icon: Icons.favorite_border_rounded,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _ProfileStatCard(
                                      value: '$saleCount',
                                      label: 'Listings',
                                      accent: AppPalette.sunset,
                                      icon: Icons.sell_outlined,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              _QuickActions(
                                onEditProfile: () =>
                                    context.push('/profile/account/edit'),
                                onMyPets: () => context.push('/profile/pets'),
                                onMessages: () => context.push('/chat'),
                              ),
                              const SizedBox(height: 18),
                              _SettingsSection(
                                title: 'Profile details',
                                children: [
                                  _SettingsTile(
                                    icon: Icons.badge_outlined,
                                    title: user.name,
                                    subtitle: user.bio?.trim().isNotEmpty == true
                                        ? user.bio!.trim()
                                        : journey?.profileSummary ??
                                            'Your public profile summary will appear here.',
                                    onTap: () =>
                                        context.push('/profile/account'),
                                  ),
                                  _SettingsTile(
                                    icon: Icons.mail_outline_rounded,
                                    title: user.email,
                                    subtitle: 'Primary email address',
                                    onTap: () =>
                                        context.push('/profile/account/edit'),
                                  ),
                                  _SettingsTile(
                                    icon: Icons.call_outlined,
                                    title: user.phoneNumber.isEmpty
                                        ? 'Add phone number'
                                        : user.phoneNumber,
                                    subtitle: 'Contact number for your account',
                                    onTap: () =>
                                        context.push('/profile/account/edit'),
                                  ),
                                  _SettingsTile(
                                    icon: Icons.place_outlined,
                                    title: user.location ?? 'Set your location',
                                    subtitle: 'Used for nearby pets and map results',
                                    onTap: () =>
                                        context.push('/profile/account/edit'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _SettingsSection(
                                title: 'Preferences',
                                children: [
                                  _ToggleTile(
                                    icon: Icons.dark_mode_outlined,
                                    title: 'Dark mode',
                                    subtitle:
                                        'Switch between light and dark appearance',
                                    value: isDark,
                                    onChanged: (_) {
                                      context.read<ThemeBloc>().add(ToggleTheme());
                                    },
                                  ),
                                  _SettingsTile(
                                    icon: Icons.language_rounded,
                                    title: 'Language',
                                    subtitle:
                                        localeCode == 'ar' ? 'Arabic' : 'English',
                                    onTap: () =>
                                        context.push('/profile/language'),
                                  ),
                                  _SettingsTile(
                                    icon: journey?.icon ??
                                        Icons.explore_outlined,
                                    title: 'Your journey',
                                    subtitle: journey?.profileSummary ??
                                        'Choose whether you own, buy, or adopt pets',
                                    onTap: () => context.push('/profile/journey'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _SettingsSection(
                                title: 'Support',
                                children: [
                                  _SettingsTile(
                                    icon: Icons.chat_bubble_outline_rounded,
                                    title: 'Messages',
                                    subtitle:
                                        'Open your conversations and active threads',
                                    onTap: () => context.push('/chat'),
                                  ),
                                  _SettingsTile(
                                    icon: Icons.mail_outline_rounded,
                                    title: 'Contact us',
                                    subtitle:
                                        'Reach the Animal Connect team quickly',
                                    onTap: () => context.push('/profile/contact'),
                                  ),
                                  _SettingsTile(
                                    icon: Icons.logout_rounded,
                                    title: 'Logout',
                                    subtitle: 'Sign out from this device',
                                    onTap: () {
                                      context.read<AuthBloc>().add(
                                        LogoutRequested(),
                                      );
                                    },
                                    isDestructive: true,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ProfileHeroCard extends StatelessWidget {
  const _ProfileHeroCard({
    required this.user,
    required this.journey,
    required this.localeCode,
  });

  final UserProfile user;
  final UserJourney? journey;
  final String localeCode;

  bool get _hasNetworkAvatar =>
      user.profileImageUrl != null &&
      user.profileImageUrl!.isNotEmpty &&
      user.profileImageUrl!.startsWith('http');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final summary = user.bio?.trim().isNotEmpty == true
        ? user.bio!.trim()
        : journey?.profileSummary ??
            'Manage your details, your pets, and the nearby community from one place.';

    return Container(
      padding: const EdgeInsets.all(22),
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
        boxShadow: AppShadows.soft(scheme.primary, opacity: 0.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.14),
                  shape: BoxShape.circle,
                  image: _hasNetworkAvatar
                      ? DecorationImage(
                          image: NetworkImage(user.profileImageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _hasNetworkAvatar
                    ? null
                    : Center(
                        child: Text(
                          user.name.isEmpty
                              ? 'A'
                              : user.name.characters.first.toUpperCase(),
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: 16),
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
                        color: Colors.white.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        'User profile',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.82),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            summary,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _HeroPill(
                icon: Icons.place_outlined,
                label: user.location ?? 'Location not set',
              ),
              _HeroPill(
                icon: Icons.language_rounded,
                label: localeCode == 'ar' ? 'Arabic' : 'English',
              ),
              if (journey != null)
                _HeroPill(icon: journey!.icon, label: journey!.title),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileStatCard extends StatelessWidget {
  const _ProfileStatCard({
    required this.value,
    required this.label,
    required this.accent,
    required this.icon,
  });

  final String value;
  final String label;
  final Color accent;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accent),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.onEditProfile,
    required this.onMyPets,
    required this.onMessages,
  });

  final VoidCallback onEditProfile;
  final VoidCallback onMyPets;
  final VoidCallback onMessages;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionTile(
            icon: Icons.edit_outlined,
            label: 'Edit',
            accent: AppPalette.plum,
            onTap: onEditProfile,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionTile(
            icon: Icons.pets_rounded,
            label: 'My pets',
            accent: AppPalette.magenta,
            onTap: onMyPets,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionTile(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Messages',
            accent: AppPalette.indigo,
            onTap: onMessages,
          ),
        ),
      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.accent,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color accent;
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
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Column(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: accent),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 4, 6, 10),
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final iconColor = isDestructive ? scheme.error : scheme.primary;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 6),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w800,
          color: isDestructive ? scheme.error : null,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: scheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 6),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: scheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: scheme.primary),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w800,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }
}
