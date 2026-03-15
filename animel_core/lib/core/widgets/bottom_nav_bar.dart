import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavBar({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        context.go("/home");
        break;
      case 1:
        context.go("/shop");
        break;
      case 2:
        context.go("/map");
        break;
      case 3:
        context.go("/adopt");
        break;
      case 4:
        context.go("/profile");
        break;
      default:
        context.go("/home");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: theme.primaryColor,
      unselectedItemColor: Colors.grey.shade500,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      onTap: (i) => _onTap(context, i),
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(MdiIcons.storeOutline), activeIcon: Icon(MdiIcons.store), label: "Shop"),
        const BottomNavigationBarItem(icon: Icon(Icons.map_outlined), activeIcon: Icon(Icons.map), label: "Map"),
        const BottomNavigationBarItem(icon: Icon(Icons.pets_outlined), activeIcon: Icon(Icons.pets), label: "Adopt"),
        const BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
