import 'package:celebritysystems_mobile/company_features/home/data/api/subcontract_api_service.dart';
import 'package:celebritysystems_mobile/company_features/home/data/models/subcontract_response.dart';

import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_result.dart';

class SubcontractRepo {
  final SubcontractApiService _subcontractApiService;

  SubcontractRepo(this._subcontractApiService);

  Future<ApiResult<List<SubcontractResponse>>> loadSubcontracts(
      int companyId) async {
    try {
      final List<SubcontractResponse> response =
          await _subcontractApiService.getSubcontractsByCompanyId(companyId);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
