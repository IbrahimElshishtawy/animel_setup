import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/message_model.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../auth/logic/auth_bloc.dart';
import '../logic/chat_bloc.dart';

class ChatDetailScreen extends StatefulWidget {
  final String userName;
  final String userId;

  const ChatDetailScreen({
    super.key,
    required this.userName,
    required this.userId,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(FetchMessages(widget.userId));
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      context.read<ChatBloc>().add(
        SendMessageRequested(widget.userId, _messageController.text),
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    var currentUserId = '';
    if (authState is Authenticated) {
      currentUserId = authState.user.id;
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.userName)),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const LoadingWidget();
                }
                if (state.errorMessage != null) {
                  return ErrorStateWidget(
                    message: state.errorMessage!,
                    onRetry: () {
                      context.read<ChatBloc>().add(
                        FetchMessages(widget.userId),
                      );
                    },
                  );
                }
                if (state.messages.isEmpty) {
                  return const Center(child: Text('Start a conversation'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final message = state.messages[index];
                    final isMe = message.senderId == currentUserId;
                    return _buildMessageBubble(message, isMe);
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isMe ? Theme.of(context).primaryColor : Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          message.content,
          style: TextStyle(color: isMe ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
