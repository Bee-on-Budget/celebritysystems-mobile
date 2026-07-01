import 'package:celebritysystems_mobile/core/helpers/constants.dart';
import 'package:celebritysystems_mobile/core/helpers/shared_pref_helper.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  /// private constructor as I don't want to allow creating an instance of this class
  DioFactory._();

  static Dio? dio;

  static Dio getDio() {
    // Aggressive timeout for fast error responses
    Duration connectTimeout = const Duration(seconds: 5);
    Duration receiveTimeout = const Duration(seconds: 5);
    Duration sendTimeout = const Duration(seconds: 5);

    if (dio == null) {
      dio = Dio();
      dio!
        ..options.connectTimeout = connectTimeout
        ..options.receiveTimeout = receiveTimeout
        ..options.sendTimeout = sendTimeout;
      addDioHeaders();
      addDioInterceptor();
      return dio!;
    } else {
      return dio!;
    }
  }

  static void addDioInterceptor() {
    // Add error interceptor first to handle errors quickly
    dio?.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          // Handle specific error types for faster feedback
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.sendTimeout ||
              error.type == DioExceptionType.receiveTimeout) {
            print('⚠️ Request timeout - returning error immediately');
          }
          return handler.next(error);
        },
      ),
    );

    // Add logger
    dio?.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        error: true,
      ),
    );
  }

  static void addDioHeaders() async {
    dio?.options.headers = {
      'Accept': 'application/json',
      'Authorization':
          'Bearer ${await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken)}',
    };
  }

  /// to refresh token after creating Dio instance
  static void setTokenIntoHeaderAfterLogin(String token) {
    dio?.options.headers = {
      'Authorization': 'Bearer $token',
    };
  }

  /// Reset Dio instance after logout to clear all state
  static void resetDioAfterLogout() {
    dio?.interceptors.clear();
    dio?.close(force: true);
    dio = null;
  }
}
