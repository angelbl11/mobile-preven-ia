import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:mobile_preven_ia_app/classes/environment_keys.dart';

/// Custom Dio class
class CustomDio {
  /// Constructor for CustomDio
  CustomDio({
    List<Interceptor>? interceptors,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: EnvironmentKeys.apiUrl,
            connectTimeout: const Duration(milliseconds: 8000),
            receiveTimeout: const Duration(milliseconds: 25000),
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
}
