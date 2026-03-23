import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final _storage = const FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _favoriteAnimalIdsKey = 'favorite_animal_ids';

  String _journeyKey(String userId) => 'user_journey_$userId';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<void> saveUserId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, id);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  Future<void> saveUserJourney(String userId, String journey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_journeyKey(userId), journey);
  }

  Future<String?> getUserJourney(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_journeyKey(userId));
  }

  Future<List<String>> getFavoriteAnimalIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoriteAnimalIdsKey) ?? const [];
  }

  Future<void> saveFavoriteAnimalIds(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoriteAnimalIdsKey, ids);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
