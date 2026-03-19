// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/models/message_model.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../auth/logic/auth_bloc.dart';
import '../logic/chat_bloc.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({
    super.key,
    required this.userName,
    required this.userId,
  });

  final String userName;
  final String userId;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.userId.isNotEmpty) {
      context.read<ChatBloc>().add(FetchMessages(widget.userId));
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isEmpty || widget.userId.isEmpty) return;

    context.read<ChatBloc>().add(SendMessageRequested(widget.userId, content));
    _messageController.clear();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final currentUserId = authState is Authenticated ? authState.user.id : '';
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.userName),
            Text(
              'Secure conversation',
              style: theme.textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listenWhen: (previous, current) =>
                  previous.messages.length != current.messages.length,
              listener: (context, state) => _scrollToBottom(),
              builder: (context, state) {
                if (widget.userId.isEmpty) {
                  return const EmptyStateWidget(
                    title: 'Conversation unavailable',
                    message: 'This thread is missing recipient information.',
                    icon: Icons.person_off_outlined,
                  );
                }
                if (state.isLoading) {
                  return const LoadingWidget(message: 'Loading messages');
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
                  return const EmptyStateWidget(
                    title: 'No messages yet',
                    message:
                        'Start with a friendly introduction to open the conversation.',
                    icon: Icons.chat_bubble_outline_rounded,
                  );
                }

                return ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  itemCount: state.messages.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final message = state.messages[index];
                    final isMe = message.senderId == currentUserId;
                    return _MessageBubble(message: message, isMe: isMe);
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              border: Border(top: BorderSide(color: scheme.outlineVariant)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                        prefixIcon: Icon(Icons.chat_bubble_outline_rounded),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  BlocBuilder<ChatBloc, ChatState>(
                    buildWhen: (previous, current) =>
                        previous.isSending != current.isSending,
                    builder: (context, state) {
                      return AnimatedContainer(
                        duration: AppMotion.fast,
                        curve: AppMotion.emphasized,
                        decoration: BoxDecoration(
                          color: scheme.primary,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          boxShadow: AppShadows.soft(
                            scheme.primary,
                            opacity: 0.18,
                          ),
                        ),
                        child: IconButton(
                          onPressed: state.isSending ? null : _sendMessage,
                          icon: state.isSending
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(
                                  Icons.send_rounded,
                                  color: Colors.white,
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.isMe});

  final Message message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.76,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isMe ? scheme.primary : theme.cardColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(isMe ? 18 : 6),
              bottomRight: Radius.circular(isMe ? 6 : 18),
            ),
            border: isMe ? null : Border.all(color: scheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.content,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isMe ? Colors.white : scheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                DateFormat('h:mm a').format(message.timestamp),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isMe
                      ? Colors.white.withOpacity(0.72)
                      : scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
