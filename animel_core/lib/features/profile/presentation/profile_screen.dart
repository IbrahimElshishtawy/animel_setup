import 'package:animel_core/features/profile/widgets/profile_header_card.dart';
import 'package:animel_core/features/profile/widgets/profile_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/logic/theme_bloc.dart';

import '../../../../core/widgets/bottom_nav_bar.dart';
import '../widgets/delete_account_bottom_sheet.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 4),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 20,
          ),
          children: [
            const SizedBox(height: 8),
            Text(
              'My profile',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            ProfileHeaderCard(
              name: 'User',
              email: 'name@example.com',
              onTap: () => context.go('/profile/account'),
            ),
            const SizedBox(height: 24),
            ProfileMenuItem(
              icon: Icons.pets_outlined,
              label: 'My pets',
              onTap: () => context.go('/profile/pets'),
            ),
            ProfileMenuItem(
              icon: Icons.notifications_none,
              label: 'Notifications',
              onTap: () {},
            ),
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                return ProfileMenuItem(
                  icon: state.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
                  label: 'Dark Mode',
                  trailing: Switch(
                    value: state.themeMode == ThemeMode.dark,
                    onChanged: (val) {
                      context.read<ThemeBloc>().add(ToggleTheme());
                    },
                  ),
                  onTap: () {
                     context.read<ThemeBloc>().add(ToggleTheme());
                  },
                );
              },
            ),
            ProfileMenuItem(
              icon: Icons.language_outlined,
              label: 'Language',
              onTap: () => context.go('/profile/language'),
            ),
            ProfileMenuItem(
              icon: Icons.lock_outline,
              label: 'Privacy policy',
              onTap: () {},
            ),
            ProfileMenuItem(
              icon: Icons.info_outline,
              label: 'Contact',
              onTap: () => context.go('/profile/contact'),
            ),
            ProfileMenuItem(
              icon: Icons.delete_outline,
              label: 'Delete account',
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: false,
                  backgroundColor: theme.scaffoldBackgroundColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  builder: (_) => const DeleteAccountBottomSheet(),
                );
              },
            ),
            const SizedBox(height: 12),
            ProfileMenuItem(
              icon: Icons.logout,
              label: 'Logout',
              isDestructive: true,
              onTap: () {
                // logout
              },
            ),
          ],
        ),
      ),
    );
  }
}
