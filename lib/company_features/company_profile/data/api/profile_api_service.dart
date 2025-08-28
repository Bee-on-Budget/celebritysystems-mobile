import 'package:celebritysystems_mobile/company_features/company_profile/data/model/company_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/networking/api_constants.dart';

part 'profile_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ProfileApiService {
  factory ProfileApiService(Dio dio) = _ProfileApiService;

  @GET('company/id/{id}')
  Future<CompanyModel> getCompanyProfile(
    @Path('id') int id,
  );
}
