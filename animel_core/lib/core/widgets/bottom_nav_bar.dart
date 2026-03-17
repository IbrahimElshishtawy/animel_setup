// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key, required this.currentIndex});

  final int currentIndex;

  static const _items = [
    _NavItem(
      label: 'Home',
      icon: Icons.home_rounded,
      outlinedIcon: Icons.home_outlined,
      route: '/home',
    ),
    _NavItem(
      label: 'Shop',
      icon: Icons.storefront_rounded,
      outlinedIcon: Icons.storefront_outlined,
      route: '/shop',
    ),
    _NavItem(
      label: 'Map',
      icon: Icons.explore_rounded,
      outlinedIcon: Icons.explore_outlined,
      route: '/map',
    ),
    _NavItem(
      label: 'Adopt',
      icon: Icons.pets_rounded,
      outlinedIcon: Icons.pets_outlined,
      route: '/adopt',
    ),
    _NavItem(
      label: 'Profile',
      icon: Icons.person_rounded,
      outlinedIcon: Icons.person_outline_rounded,
      route: '/profile',
    ),
  ];

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;
    context.go(_items[index].route);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.94),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFEADDE8)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x144B1A45),
              blurRadius: 26,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: List.generate(_items.length, (index) {
            final item = _items[index];
            final isSelected = index == currentIndex;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () => _onTap(context, index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        gradient: isSelected
                            ? const LinearGradient(
                                colors: [
                                  Color(0xFF4B1A45),
                                  Color(0xFF7B315E),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: isSelected ? null : Colors.transparent,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isSelected ? item.icon : item.outlinedIcon,
                            size: 22,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF8B7B88),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF8B7B88),
                            ),
                          ),
                        ],
                      ),
                    ),
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
    required this.outlinedIcon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final IconData outlinedIcon;
  final String route;
}
