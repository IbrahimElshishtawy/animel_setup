import '../models/user_model.dart';
import '../services/api_client.dart';
import '../services/api_exception.dart';

class UserRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<UserProfile>> getNearbyUsers({String? journey}) async {
    try {
      final response = await _apiClient.dio.get(
        '/users/nearby',
        queryParameters: journey == null ? null : {'journey': journey},
      );
      final payload = response.data as Map<String, dynamic>;
      final users = payload['users'] as List<dynamic>? ?? const [];
      return users
          .whereType<Map<String, dynamic>>()
          .map(UserProfile.fromJson)
          .toList();
    } catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}
