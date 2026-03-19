import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/logic/locale_bloc.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/logic/theme_bloc.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../auth/logic/auth_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
              final theme = Theme.of(context);
              final scheme = theme.colorScheme;
              final isDark =
                  context.watch<ThemeBloc>().state.themeMode == ThemeMode.dark;
              final localeCode =
                  context.watch<LocaleBloc>().state.locale?.languageCode ??
                  'en';

              return ListView(
                padding: AppSpacing.screenPadding,
                children: [
                  Text(
                    'Settings',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      gradient: LinearGradient(
                        colors: [
                          scheme.primary,
                          Color.alphaBlend(
                            scheme.secondary.withOpacity(0.24),
                            scheme.primary,
                          ),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: AppShadows.soft(scheme.primary, opacity: 0.18),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Center(
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
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white.withOpacity(0.82),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.14),
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.pill,
                                  ),
                                ),
                                child: Text(
                                  user.location ?? 'Location not set',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _SettingsSection(
                    title: 'Account',
                    children: [
                      _SettingsTile(
                        icon: Icons.person_outline_rounded,
                        title: 'Edit profile',
                        subtitle: 'Update your personal details and bio',
                        onTap: () => context.push('/profile/account/edit'),
                      ),
                      _SettingsTile(
                        icon: Icons.pets_outlined,
                        title: 'My pets',
                        subtitle: 'Manage your own listings and companions',
                        onTap: () => context.push('/profile/pets'),
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
                        subtitle: 'Switch between light and dark appearance',
                        value: isDark,
                        onChanged: (_) {
                          context.read<ThemeBloc>().add(ToggleTheme());
                        },
                      ),
                      _SettingsTile(
                        icon: Icons.language_rounded,
                        title: 'Language',
                        subtitle: localeCode == 'ar' ? 'Arabic' : 'English',
                        onTap: () => context.push('/profile/language'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _SettingsSection(
                    title: 'Support',
                    children: [
                      _SettingsTile(
                        icon: Icons.mail_outline_rounded,
                        title: 'Contact us',
                        subtitle: 'Reach the Animal Connect team',
                        onTap: () => context.push('/profile/contact'),
                      ),
                      _SettingsTile(
                        icon: Icons.logout_rounded,
                        title: 'Logout',
                        subtitle: 'Sign out from this device',
                        onTap: () {
                          context.read<AuthBloc>().add(LogoutRequested());
                        },
                        isDestructive: true,
                      ),
                    ],
                  ),
                ],
              );
            },
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
