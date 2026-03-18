import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/models/message_model.dart';
import '../../../core/repositories/chat_repository.dart';

// Events
abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object> get props => [];
}

class FetchMessages extends ChatEvent {
  final String otherUserId;
  const FetchMessages(this.otherUserId);
  @override
  List<Object> get props => [otherUserId];
}

class SendMessageRequested extends ChatEvent {
  final String receiverId;
  final String content;
  const SendMessageRequested(this.receiverId, this.content);
  @override
  List<Object> get props => [receiverId, content];
}

// States
abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}
class ChatLoading extends ChatState {}
class ChatLoaded extends ChatState {
  final List<Message> messages;
  const ChatLoaded(this.messages);
  @override
  List<Object> get props => [messages];
}
class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);
  @override
  List<Object> get props => [message];
}

// Bloc
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository = ChatRepository();

  ChatBloc() : super(ChatInitial()) {
    on<FetchMessages>((event, emit) async {
      emit(ChatLoading());
      try {
        final messages = await _chatRepository.getMessages(event.otherUserId);
        emit(ChatLoaded(messages));
      } catch (e) {
        emit(const ChatError('Failed to fetch messages'));
      }
    });

    on<SendMessageRequested>((event, emit) async {
      try {
        final message = await _chatRepository.sendMessage(event.receiverId, event.content);
        if (message != null) {
          if (state is ChatLoaded) {
            final updatedMessages = List<Message>.from((state as ChatLoaded).messages)..add(message);
            emit(ChatLoaded(updatedMessages));
          } else {
            emit(ChatLoaded([message]));
          }
        }
      } catch (e) {
        // Silently fail or emit error
      }
    });
  }
}
