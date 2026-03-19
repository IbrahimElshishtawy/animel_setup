import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/models/conversation_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../auth/logic/auth_bloc.dart';
import '../logic/chat_bloc.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(FetchConversations());
  }

  void _retry() {
    context.read<ChatBloc>().add(FetchConversations());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final authState = context.read<AuthBloc>().state;
    final currentUserId = authState is Authenticated ? authState.user.id : '';

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: AppSpacing.screenPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Messages',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Keep seller, adopter, and helper conversations tidy with a calmer messaging layout.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                            gradient: LinearGradient(
                              colors: [
                                scheme.primary,
                                Color.alphaBlend(
                                  scheme.tertiary.withOpacity(0.24),
                                  scheme.primary,
                                ),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Conversation hub',
                                      style: theme.textTheme.labelLarge
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '${state.conversations.length} active threads',
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.forum_outlined,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                ),
                if (state.isLoading)
                  const SliverToBoxAdapter(
                    child: LoadingWidget(message: 'Loading conversations'),
                  )
                else if (state.errorMessage != null)
                  SliverToBoxAdapter(
                    child: ErrorStateWidget(
                      message: state.errorMessage!,
                      onRetry: _retry,
                    ),
                  )
                else if (state.conversations.isEmpty)
                  const SliverToBoxAdapter(
                    child: EmptyStateWidget(
                      title: 'No conversations yet',
                      message:
                          'When you message a seller, adopter, or helper, your threads will appear here.',
                      icon: Icons.chat_bubble_outline_rounded,
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    sliver: SliverList.separated(
                      itemCount: state.conversations.length,
                      itemBuilder: (context, index) {
                        final conversation = state.conversations[index];
                        final participant = _resolveOtherParticipant(
                          conversation,
                          currentUserId,
                        );
                        return _ConversationTile(
                          conversation: conversation,
                          participant: participant,
                        );
                      },
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  UserProfile? _resolveOtherParticipant(
    Conversation conversation,
    String currentUserId,
  ) {
    for (final participant in conversation.participants) {
      if (participant.id != currentUserId) {
        return participant;
      }
    }
    return conversation.participants.isEmpty ? null : conversation.participants.first;
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({
    required this.conversation,
    required this.participant,
  });

  final Conversation conversation;
  final UserProfile? participant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final lastTimestamp = conversation.lastMessageAt;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: participant == null
            ? null
            : () => context.push(
                  '/chat-detail',
                  extra: {
                    'userName': participant!.name,
                    'userId': participant!.id,
                  },
                ),
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: scheme.outlineVariant),
            boxShadow: AppShadows.soft(Colors.black, opacity: 0.04),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: scheme.primary.withOpacity(0.12),
                child: Text(
                  (participant?.name.isNotEmpty ?? false)
                      ? participant!.name.characters.first.toUpperCase()
                      : 'A',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      participant?.name ?? 'Animal Connect',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      conversation.lastMessage.isEmpty
                          ? 'Start the conversation'
                          : conversation.lastMessage,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                lastTimestamp == null ? '' : DateFormat('h:mm a').format(lastTimestamp),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
