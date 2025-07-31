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
}
