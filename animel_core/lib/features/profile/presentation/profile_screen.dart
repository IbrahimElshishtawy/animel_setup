import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {"title": "My account", "route": "/profile/account"},
      {"title": "My pets", "route": "/profile/pets"},
      {"title": "Language", "route": null},
      {"title": "Privacy policy", "route": null},
      {"title": "Contact", "route": null},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: ListView.separated(
        itemCount: items.length + 1,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          if (index == items.length) {
            return ListTile(
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () {
                context.go("/login");
              },
            );
          }

          final item = items[index];
          return ListTile(
            title: Text(item["title"]!),
            trailing: const Icon(Icons.chevron_right),
            onTap: item["route"] != null
                ? () => context.go(item["route"]!)
                : null,
          );
        },
      ),
    );
  }
}
