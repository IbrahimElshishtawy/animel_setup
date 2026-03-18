import 'package:dio/dio.dart';
import 'storage_service.dart';

class ApiClient {
  static final String baseUrl = 'http://localhost:5000/api';
  final Dio _dio;
  final StorageService _storageService = StorageService();

  ApiClient()
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        )) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storageService.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (e, handler) {
        // Global error handling could go here
        return handler.next(e);
      },
    ));
  }

  Dio get dio => _dio;
}
