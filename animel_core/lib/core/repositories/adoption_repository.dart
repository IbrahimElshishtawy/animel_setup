import '../models/animal_model.dart';
import '../models/adoption_request_model.dart';
import '../services/api_exception.dart';
import '../services/api_client.dart';

class AdoptionRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<Animal>> getAdoptionAnimals({String? query, String? type}) async {
    try {
      final response = await _apiClient.dio.get(
        '/animals',
        queryParameters: {
          'isForAdoption': true,
          if (query != null && query.isNotEmpty) 'query': query,
          if (type != null && type.isNotEmpty) 'type': type,
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

  Future<Animal> createAdoptionPost(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.post(
        '/animals',
        data: {...data, 'isForAdoption': true},
      );
      return Animal.fromJson(response.data as Map<String, dynamic>);
    } catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<AdoptionRequestModel> sendAdoptionRequest(
    String animalId,
    String message,
  ) async {
    try {
      final response = await _apiClient.dio.post(
        '/animals/$animalId/adoption-request',
        data: {'message': message},
      );
      return AdoptionRequestModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<List<AdoptionRequestModel>> getSentRequests() async {
    try {
      final response = await _apiClient.dio.get(
        '/animals/adoption-requests/sent',
      );
      return (response.data as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map(AdoptionRequestModel.fromJson)
          .toList();
    } catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<List<AdoptionRequestModel>> getReceivedRequests() async {
    try {
      final response = await _apiClient.dio.get(
        '/animals/adoption-requests/received',
      );
      return (response.data as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map(AdoptionRequestModel.fromJson)
          .toList();
    } catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<AdoptionRequestModel> updateRequestStatus(
    String requestId,
    String status,
  ) async {
    try {
      final response = await _apiClient.dio.patch(
        '/animals/adoption-requests/$requestId',
        data: {'status': status},
      );
      return AdoptionRequestModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}
