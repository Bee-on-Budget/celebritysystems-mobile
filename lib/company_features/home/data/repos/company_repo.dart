import 'package:celebritysystems_mobile/company_features/home/data/api/company_api_service.dart';
import 'package:celebritysystems_mobile/company_features/home/data/models/company_screen_model.dart';

import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_result.dart';
import '../api/company_tickets_api_service.dart';
import '../models/company_tickets_response.dart';

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
}
