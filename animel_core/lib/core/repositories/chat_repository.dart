import '../models/conversation_model.dart';
import '../models/message_model.dart';
import '../services/api_exception.dart';
import '../services/api_client.dart';

class ChatRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<Conversation>> getConversations() async {
    try {
      final response = await _apiClient.dio.get('/chat/conversations');
      return (response.data as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map(Conversation.fromJson)
          .toList();
    } catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<({String conversationId, List<Message> messages})> getMessages(
    String otherUserId,
  ) async {
    try {
      final response = await _apiClient.dio.get('/chat/messages/$otherUserId');
      final data = response.data as Map<String, dynamic>;
      return (
        conversationId: data['conversationId']?.toString() ?? '',
        messages: (data['messages'] as List<dynamic>? ?? [])
            .whereType<Map<String, dynamic>>()
            .map(Message.fromJson)
            .toList(),
      );
    } catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<({String conversationId, Message message})> sendMessage(
    String receiverId,
    String content,
  ) async {
    try {
      final response = await _apiClient.dio.post(
        '/chat/messages',
        data: {
          'receiverId': receiverId,
          'content': content,
        },
      );
      final data = response.data as Map<String, dynamic>;
      return (
        conversationId: data['conversationId']?.toString() ?? '',
        message: Message.fromJson(data['message'] as Map<String, dynamic>),
      );
    } catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}
