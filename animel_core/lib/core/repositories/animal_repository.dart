import 'package:dio/dio.dart';
import '../models/animal_model.dart';

class AnimalRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:5000/api'));

  Future<List<Animal>> getAnimals({bool? isForAdoption, String? query}) async {
    try {
      final response = await _dio.get('/animals', queryParameters: {
        if (isForAdoption != null) 'isForAdoption': isForAdoption,
        if (query != null) 'query': query,
      });

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((e) => Animal.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      // For now, fallback to mock if backend is not reachable
      return [];
    }
  }
}
