import '../models/message_model.dart';
import '../services/api_client.dart';

class ChatRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<Message>> getMessages(String otherUserId) async {
    try {
      final response = await _apiClient.dio.get('/chat/messages/$otherUserId');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((e) => Message.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Message?> sendMessage(String receiverId, String content) async {
    try {
      final response = await _apiClient.dio.post('/chat/messages', data: {
        'receiverId': receiverId,
        'content': content,
      });
      if (response.statusCode == 201) {
        return Message.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
