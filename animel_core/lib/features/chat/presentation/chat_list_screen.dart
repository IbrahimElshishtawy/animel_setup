import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: ListView.separated(
        itemCount: 5,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final userName = 'User ${index + 1}';
          return ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('assets/image/image.png'),
            ),
            title: Text(userName),
            subtitle: const Text('Is the animal still available?'),
            trailing: const Text('12:30 PM'),
            onTap: () {
              context.push('/chat-detail', extra: userName);
            },
          );
        },
      ),
    );
  }
}
