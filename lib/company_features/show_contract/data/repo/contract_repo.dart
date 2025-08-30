import 'package:celebritysystems_mobile/company_features/show_contract/data/api/contract_api_service.dart';
import 'package:celebritysystems_mobile/company_features/show_contract/data/model/contract_response.dart';
import 'package:celebritysystems_mobile/core/networking/api_error_handler.dart';
import 'package:celebritysystems_mobile/core/networking/api_result.dart';

class ContractRepo {
  final ContractApiService _contractApiService;

  ContractRepo(this._contractApiService);

  Future<ApiResult<List<Contract>>> getContracts(int companyId) async {
    try {
      final response = await _contractApiService.getcontracts(companyId);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
