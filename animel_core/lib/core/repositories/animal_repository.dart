import '../models/animal_model.dart';
import '../services/api_exception.dart';
import '../services/api_client.dart';

class AnimalRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<Animal>> getAnimals({
    bool? isForAdoption,
    String? query,
    String? type,
    String? ownerId,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/animals',
        queryParameters: {
          if (isForAdoption != null) 'isForAdoption': isForAdoption,
          if (query != null) 'query': query,
          if (type != null) 'type': type,
          if (ownerId != null) 'ownerId': ownerId,
        },
      );

      return (response.data as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map(Animal.fromJson)
          .toList();
    } catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<Animal> getAnimalDetails(String id) async {
    try {
      final response = await _apiClient.dio.get('/animals/$id');
      return Animal.fromJson(response.data as Map<String, dynamic>);
    } catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<List<Animal>> getMyAnimals() async {
    try {
      final response = await _apiClient.dio.get('/animals/mine');
      return (response.data as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map(Animal.fromJson)
          .toList();
    } catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<Animal> createAnimal(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.post('/animals', data: data);
      return Animal.fromJson(response.data as Map<String, dynamic>);
    } catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<Animal> updateAnimal(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.put('/animals/$id', data: data);
      return Animal.fromJson(response.data as Map<String, dynamic>);
    } catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<void> deleteAnimal(String id) async {
    try {
      await _apiClient.dio.delete('/animals/$id');
    } catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}
