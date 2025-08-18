import 'package:celebritysystems_mobile/company_features/home/data/models/company_screen_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/networking/api_constants.dart';
import '../models/company.dart';

part 'company_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class CompanyApiService {
  factory CompanyApiService(Dio dio) = _CompanyApiService;

  @GET('${ApiConstants.company}/{companyId}')
  Future<Company> getCompany(
    @Path('companyId') int companyId,
  );

  @GET('contracts/company/{companyId}/screens/active')
  Future<List<CompanyScreenModel>> getCompanyScreens(
    @Path('companyId') int companyId,
  );
}
