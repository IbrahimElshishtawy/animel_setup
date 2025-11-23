import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My account"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.go("/profile/account/edit"),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("First name: John"),
            SizedBox(height: 8),
            Text("Last name: Doe"),
            SizedBox(height: 8),
            Text("Email: john@example.com"),
            SizedBox(height: 8),
            Text("Address: Cairo, Egypt"),
          ],
        ),
      ),
    );
  }
}
