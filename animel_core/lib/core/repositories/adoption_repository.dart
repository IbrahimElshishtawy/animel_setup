import '../models/animal_model.dart';
import '../services/api_client.dart';

class AdoptionRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<Animal>> getAdoptionAnimals({String? query, String? type}) async {
    try {
      final response = await _apiClient.dio.get(
        '/animals',
        queryParameters: {
          'isForAdoption': true,
          'query': ?query,
          'type': ?type,
        },
      );

      if (response.statusCode == 200) {
        return (response.data as List).map((e) => Animal.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Animal?> createAdoptionPost(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.post(
        '/animals',
        data: {...data, 'isForAdoption': true},
      );
      if (response.statusCode == 201) {
        return Animal.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
