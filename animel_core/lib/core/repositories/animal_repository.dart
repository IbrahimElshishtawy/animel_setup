import 'package:dio/dio.dart';
import '../models/animal_model.dart';
import '../services/api_client.dart';

class AnimalRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<Animal>> getAnimals({bool? isForAdoption, String? query, String? type}) async {
    try {
      final response = await _apiClient.dio.get('/animals', queryParameters: {
        if (isForAdoption != null) 'isForAdoption': isForAdoption,
        if (query != null) 'query': query,
        if (type != null) 'type': type,
      });

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((e) => Animal.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Animal?> createAnimal(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.post('/animals', data: data);
      if (response.statusCode == 201) {
        return Animal.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateAnimal(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.put('/animals/$id', data: data);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteAnimal(String id) async {
    try {
      final response = await _apiClient.dio.delete('/animals/$id');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
