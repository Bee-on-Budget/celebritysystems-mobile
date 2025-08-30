import 'package:celebritysystems_mobile/company_features/show_contract/data/model/contract_response.dart';
import 'package:celebritysystems_mobile/core/networking/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
part 'contract_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ContractApiService {
  factory ContractApiService(Dio dio) = _ContractApiService;

  @GET('${ApiConstants.contracts}/{companyId}')
  Future<List<Contract>> getcontracts(
    @Path('companyId') int companyId,
  );
}
