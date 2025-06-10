import 'package:celebritysystems_mobile/core/networking/api_error_handler.dart';
import 'package:celebritysystems_mobile/core/networking/api_result.dart';
import 'package:celebritysystems_mobile/features/login/data/apis/login_api_service.dart';
import 'package:celebritysystems_mobile/features/login/data/models/login_request_body.dart';
import 'package:celebritysystems_mobile/features/login/data/models/login_response.dart';

class LoginRepo {
  final LoginApiService _loginApiService;

  LoginRepo(this._loginApiService);

  Future<ApiResult<LoginResponse>> login(
      LoginRequestBody loginRequestBody) async {
    try {
      final respone = await _loginApiService.login(loginRequestBody);
      return ApiResult.success(respone);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
