import '../models/user_model.dart';
import '../services/api_client.dart';
import '../services/storage_service.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();
  final StorageService _storageService = StorageService();

  Future<UserProfile?> login(String email, String password) async {
    try {
      final response = await _apiClient.dio.post('/users/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final token = response.data['token'];
        final userData = response.data['user'];
        await _storageService.saveToken(token);
        await _storageService.saveUserId(userData['_id']);
        return UserProfile.fromJson(userData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<UserProfile?> register(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.post('/users/register', data: data);
      if (response.statusCode == 201) {
        final token = response.data['token'];
        final userData = response.data['user'];
        await _storageService.saveToken(token);
        await _storageService.saveUserId(userData['_id']);
        return UserProfile.fromJson(userData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    await _storageService.clearAll();
  }

  Future<UserProfile?> getCurrentUser() async {
    try {
      final token = await _storageService.getToken();
      if (token == null) return null;

      final response = await _apiClient.dio.get('/users/profile');
      if (response.statusCode == 200) {
        return UserProfile.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<UserProfile?> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.put('/users/profile', data: data);
      if (response.statusCode == 200) {
        return UserProfile.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
