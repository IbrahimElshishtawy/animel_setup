// ignore_for_file: constant_identifier_names

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'storage_service.dart';

class ApiClient {
  static const String _apiBaseUrlFromEnv = String.fromEnvironment(
    'API_BASE_URL',
  );

  // Default LAN address for running the backend on this machine and testing
  // from a real mobile device on the same Wi-Fi network.
  // static const String _mobileLanBaseUrl = 'http://192.168.1.3:6000/api';
  // static const String _androidEmulatorBaseUrl = 'http://10.0.2.2:6000/api';
  static const String _BaseUrl = 'http://192.168.1.3:6000/api';

  static String get baseUrl {
    if (_apiBaseUrlFromEnv.isNotEmpty) {
      return _normalizeBaseUrl(_apiBaseUrlFromEnv);
    }

    if (kIsWeb) {
      return _BaseUrl;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return _BaseUrl;
      default:
        return _BaseUrl;
    }
  }

  static String get mobileLanBaseUrl => _BaseUrl;

  static String get androidEmulatorBaseUrl => _BaseUrl;

  static String _normalizeBaseUrl(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return trimmed;
    return trimmed.endsWith('/api') ? trimmed : '$trimmed/api';
  }

  final Dio _dio;
  final StorageService _storageService = StorageService();

  ApiClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
          sendTimeout: const Duration(seconds: 20),
          headers: const {'Accept': 'application/json'},
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storageService.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (e, handler) async {
          if (e.response?.statusCode == 401) {
            await _storageService.clearAll();
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
