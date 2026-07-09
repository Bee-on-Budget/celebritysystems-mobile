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
        ..options.sendTimeout = sendTimeout
        ..options.headers = {
          'Accept': 'application/json',
        };
      addDioInterceptor();
      return dio!;
    } else {
      return dio!;
    }
  }

  static void addDioInterceptor() {
    // Attach the bearer token per-request so we never send a stale or empty
    // "Bearer " header. Previously the token was baked into the default headers
    // at Dio creation time; on a logged-out device that produced
    // `Authorization: Bearer ` (empty), which the backend rejects with 401 —
    // even on the public login endpoint. That broke every fresh login.
    dio?.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final isAuthEndpoint = options.path.contains('auth/');

          if (isAuthEndpoint) {
            // Login / auth routes must be called WITHOUT an Authorization header.
            options.headers.remove('Authorization');
          } else {
            final token = await SharedPrefHelper.getSecuredString(
                SharedPrefKeys.userToken);
            if (token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            } else {
              options.headers.remove('Authorization');
            }
          }
          return handler.next(options);
        },
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

  /// Refresh the in-memory token immediately after login. The interceptor also
  /// reads the token from secure storage per-request, so this is just belt-and
  /// -suspenders to avoid any first-call race right after logging in.
  static void setTokenIntoHeaderAfterLogin(String token) {
    if (token.isEmpty) {
      dio?.options.headers.remove('Authorization');
      return;
    }
    dio?.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Reset Dio instance after logout to clear all state
  static void resetDioAfterLogout() {
    dio?.interceptors.clear();
    dio?.close(force: true);
    dio = null;
  }
}
