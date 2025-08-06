import 'package:celebritysystems_mobile/features/login/data/models/login_request_body.dart';
import 'package:celebritysystems_mobile/features/login/data/models/login_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/networking/api_constants.dart';

part 'login_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class LoginApiService {
  factory LoginApiService(Dio dio) = _LoginApiService;

  @POST(ApiConstants.login)
  Future<LoginResponse> login(
    @Body() LoginRequestBody loginRequestBody,
  );

  @PATCH("users/id/{id}")
  Future<void> patchSubscriptionId(
    @Path("id") int id,
    @Body() Map<String, String> body,
  );
}
