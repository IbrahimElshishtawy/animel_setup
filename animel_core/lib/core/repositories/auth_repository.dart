import '../models/user_model.dart';
import '../services/api_exception.dart';
import '../services/api_client.dart';
import '../services/storage_service.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();
  final StorageService _storageService = StorageService();

  Future<UserProfile> login(String email, String password) async {
    try {
      final response = await _apiClient.dio.post('/users/login', data: {
        'email': email,
        'password': password,
      });

      final token = response.data['token']?.toString() ?? '';
      final userData = response.data['user'] as Map<String, dynamic>;
      await _storageService.saveToken(token);
      await _storageService.saveUserId(userData['_id'].toString());
      return UserProfile.fromJson(userData);
    } catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<UserProfile> register(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.post('/users/register', data: data);
      final token = response.data['token']?.toString() ?? '';
      final userData = response.data['user'] as Map<String, dynamic>;
      await _storageService.saveToken(token);
      await _storageService.saveUserId(userData['_id'].toString());
      return UserProfile.fromJson(userData);
    } catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.dio.post('/users/logout');
    } catch (_) {
      // The backend logout is stateless; local session cleanup still matters most.
    } finally {
      await _storageService.clearAll();
    }
  }

  Future<UserProfile?> getCurrentUser() async {
    try {
      final token = await _storageService.getToken();
      if (token == null) return null;

      final response = await _apiClient.dio.get('/users/profile');
      return UserProfile.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<UserProfile> updateProfile(Map<String, dynamic> data) async {
    try {
      final payload = Map<String, dynamic>.from(data)
        ..removeWhere((key, value) => value == null);
      final response = await _apiClient.dio.put('/users/profile', data: payload);
      return UserProfile.fromJson(response.data as Map<String, dynamic>);
    } catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}
