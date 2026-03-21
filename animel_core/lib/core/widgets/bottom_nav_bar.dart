// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_tokens.dart';
import 'glass_panel.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key, required this.currentIndex});

  final int currentIndex;

  static const _items = <_NavItem>[
    _NavItem(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      route: '/home',
    ),
    _NavItem(
      label: 'Explore',
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore_rounded,
      route: '/search',
    ),
    _NavItem(
      label: 'Add',
      icon: Icons.add_rounded,
      activeIcon: Icons.add_rounded,
      route: '/profile/pets/add-step1',
      isCenterAction: true,
    ),
    _NavItem(
      label: 'Messages',
      icon: Icons.chat_bubble_outline_rounded,
      activeIcon: Icons.chat_bubble_rounded,
      route: '/chat',
    ),
    _NavItem(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      route: '/profile',
    ),
  ];

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;
    context.go(_items[index].route);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: GlassPanel(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        borderRadius: BorderRadius.circular(30),
        blurSigma: 24,
        shadowColor: scheme.primary,
        shadowOpacity: isDark ? 0.22 : 0.1,
        gradientColors: [
          Colors.white.withOpacity(isDark ? 0.12 : 0.86),
          Colors.white.withOpacity(isDark ? 0.06 : 0.56),
        ],
        child: Row(
          children: List.generate(_items.length, (index) {
            final item = _items[index];
            final isSelected = index == currentIndex;

            if (item.isCenterAction) {
              return Expanded(
                child: Center(
                  child: ScaleTap(
                    onTap: () => _onTap(context, index),
                    scaleDown: 0.94,
                    child: AnimatedContainer(
                      duration: AppMotion.fast,
                      curve: AppMotion.emphasized,
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
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
                        boxShadow: AppShadows.soft(
                          scheme.primary,
                          opacity: isDark ? 0.26 : 0.18,
                        ),
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              );
            }

            return Expanded(
              child: ScaleTap(
                onTap: () => _onTap(context, index),
                child: AnimatedContainer(
                  duration: AppMotion.fast,
                  curve: AppMotion.emphasized,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: isSelected
                        ? scheme.primary.withOpacity(isDark ? 0.16 : 0.1)
                        : Colors.transparent,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? item.activeIcon : item.icon,
                        size: 20,
                        color: isSelected
                            ? scheme.primary
                            : scheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isSelected
                              ? scheme.primary
                              : scheme.onSurfaceVariant,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
    this.isCenterAction = false,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;
  final bool isCenterAction;
}
