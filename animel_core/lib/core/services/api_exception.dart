import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  factory ApiException.fromDio(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map<String, dynamic> && data['message'] != null) {
        return ApiException(data['message'].toString());
      }

      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return const ApiException(
          'Connection timed out. Make sure your mobile and backend are on the same network, then try again.',
        );
      }

      if (error.type == DioExceptionType.connectionError) {
        return const ApiException(
          'Unable to reach the server. Check the backend host/IP and confirm the server is running.',
        );
      }
    }

    return const ApiException('Something went wrong. Please try again.');
  }

  @override
  String toString() => message;
}
