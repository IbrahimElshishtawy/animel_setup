import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../auth/logic/auth_bloc.dart';
import '../../../core/widgets/bottom_nav_bar.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
      body: ListView.separated(
        itemCount: 5,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final userName = 'User ${index + 1}';
          final userId = 'user_${index + 1}'; // Mock ID
          return ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('assets/image/image.png'),
            ),
            title: Text(userName),
            subtitle: const Text('Is the animal still available?'),
            trailing: const Text('12:30 PM'),
            onTap: () {
              context.push('/chat-detail', extra: {
                'userName': userName,
                'userId': userId,
              });
            },
          );
        },
      ),
    );
  }
}
