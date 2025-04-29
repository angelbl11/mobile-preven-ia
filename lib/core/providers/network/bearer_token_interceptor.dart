import 'package:dio/dio.dart';

/// Interceptor class to add a Bearer token to the request headers.
class BearerTokenInterceptor extends Interceptor {
  /// Constructor for [BearerTokenInterceptor]
  BearerTokenInterceptor({required this.token});

  /// Bearer token to be added to the request headers.
  String? token;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      if (token != null && token!.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      return super.onRequest(options, handler);
    } catch (e) {
      return handler.reject(
        DioException(
          requestOptions: options,
          error: 'Error obtaining Bearer token: $e',
        ),
      );
    }
  }
}
