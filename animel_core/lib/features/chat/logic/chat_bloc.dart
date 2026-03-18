import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/conversation_model.dart';
import '../../../core/models/message_model.dart';
import '../../../core/repositories/chat_repository.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class FetchConversations extends ChatEvent {}

class FetchMessages extends ChatEvent {
  final String otherUserId;

  const FetchMessages(this.otherUserId);

  @override
  List<Object?> get props => [otherUserId];
}

class SendMessageRequested extends ChatEvent {
  final String receiverId;
  final String content;

  const SendMessageRequested(this.receiverId, this.content);

  @override
  List<Object?> get props => [receiverId, content];
}

class ClearChatMessage extends ChatEvent {}

class ChatState extends Equatable {
  final List<Conversation> conversations;
  final List<Message> messages;
  final String activeUserId;
  final String conversationId;
  final bool isLoading;
  final bool isSending;
  final String? errorMessage;

  const ChatState({
    this.conversations = const [],
    this.messages = const [],
    this.activeUserId = '',
    this.conversationId = '',
    this.isLoading = false,
    this.isSending = false,
    this.errorMessage,
  });

  const ChatState.initial() : this();

  ChatState copyWith({
    List<Conversation>? conversations,
    List<Message>? messages,
    String? activeUserId,
    String? conversationId,
    bool? isLoading,
    bool? isSending,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ChatState(
      conversations: conversations ?? this.conversations,
      messages: messages ?? this.messages,
      activeUserId: activeUserId ?? this.activeUserId,
      conversationId: conversationId ?? this.conversationId,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        conversations,
        messages,
        activeUserId,
        conversationId,
        isLoading,
        isSending,
        errorMessage,
      ];
}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _repository = ChatRepository();

  ChatBloc() : super(const ChatState.initial()) {
    on<FetchConversations>(_onFetchConversations);
    on<FetchMessages>(_onFetchMessages);
    on<SendMessageRequested>(_onSendMessageRequested);
    on<ClearChatMessage>(
      (event, emit) => emit(state.copyWith(clearError: true)),
    );
  }

  Future<void> _onFetchConversations(
    FetchConversations event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final conversations = await _repository.getConversations();
      emit(state.copyWith(conversations: conversations, isLoading: false));
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: error.toString().replaceFirst('ApiException: ', ''),
        ),
      );
    }
  }

  Future<void> _onFetchMessages(
    FetchMessages event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, activeUserId: event.otherUserId, clearError: true));
    try {
      final response = await _repository.getMessages(event.otherUserId);
      emit(
        state.copyWith(
          isLoading: false,
          activeUserId: event.otherUserId,
          conversationId: response.conversationId,
          messages: response.messages,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: error.toString().replaceFirst('ApiException: ', ''),
        ),
      );
    }
  }

  Future<void> _onSendMessageRequested(
    SendMessageRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(isSending: true, clearError: true));
    try {
      final response = await _repository.sendMessage(event.receiverId, event.content);
      final updatedMessages = List<Message>.from(state.messages)..add(response.message);

      emit(
        state.copyWith(
          isSending: false,
          activeUserId: event.receiverId,
          conversationId: response.conversationId,
          messages: updatedMessages,
        ),
      );
      add(FetchConversations());
    } catch (error) {
      emit(
        state.copyWith(
          isSending: false,
          errorMessage: error.toString().replaceFirst('ApiException: ', ''),
        ),
      );
    }
  }
}
