import 'package:celebritysystems_mobile/company_features/company_profile/data/api/profile_api_service.dart';
import 'package:celebritysystems_mobile/company_features/company_profile/data/model/company_model.dart';
import 'package:celebritysystems_mobile/core/networking/api_error_handler.dart';
import 'package:celebritysystems_mobile/core/networking/api_result.dart';

class ProfileRepo {
  final ProfileApiService _profileApiService;

  ProfileRepo(this._profileApiService);

  Future<ApiResult<CompanyModel>> getCompanyProfile(int companyId) async {
    try {
      final CompanyModel response =
          await _profileApiService.getCompanyProfile(companyId);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
