import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:mobile_preven_ia_app/core/classes/environment_keys.dart';
import 'package:mobile_preven_ia_app/core/providers/network/bearer_token_interceptor.dart';

/// Custom Dio class
class CustomDio {
  /// Constructor for CustomDio
  CustomDio({
    List<Interceptor>? interceptors,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: EnvironmentKeys.apiUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 50),
          ),
        ) {
    // Add interceptors if provided
    if (interceptors != null) {
      _dio.interceptors.addAll(interceptors);
    }

    _dio.interceptors.add(
      AwesomeDioInterceptor(
        logRequestHeaders: false,
        logRequestTimeout: false,
        logResponseHeaders: false,
      ),
    );
  }

  final Dio _dio;

  /// Getter for Dio instance
  Dio get dio => _dio;

  /// Update token
  void updateToken(String token) {
    _dio.interceptors.add(BearerTokenInterceptor(token: token));
  }
}
