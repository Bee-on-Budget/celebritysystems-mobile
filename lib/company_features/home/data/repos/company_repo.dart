import 'package:celebritysystems_mobile/company_features/home/data/api/company_api_service.dart';
import 'package:celebritysystems_mobile/company_features/home/data/models/company_screen_model.dart';

import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_result.dart';

class CompanyRepo {
  final CompanyApiService _companyApiService;

  CompanyRepo(this._companyApiService);

  Future<ApiResult<List<CompanyScreenModel>>> getCompanyScreens(
      int companyId) async {
    try {
      final List<CompanyScreenModel> response =
          await _companyApiService.getCompanyScreens(companyId);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<CompanyScreenModel>>> getCompanyScreensForSubcompany(
      int subcompanyId, List<int> contractsIds) async {
    try {
      final List<CompanyScreenModel> response = await _companyApiService
          .getCompanyScreensForSubcompany(subcompanyId, contractsIds);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
