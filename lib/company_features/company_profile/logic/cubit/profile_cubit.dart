import 'package:celebritysystems_mobile/company_features/company_profile/data/model/company_model.dart';
import 'package:celebritysystems_mobile/company_features/company_profile/data/repo/profile_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:celebritysystems_mobile/company_features/company_profile/logic/cubit/profile_state.dart';
import '../../../../core/networking/api_result.dart' as result;

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo _profileRepo;

  ProfileCubit(this._profileRepo) : super(ProfileState.initial());

  Future<void> getCompanyProfile(int companyId) async {
    emit(Loading());

    final companyDetails = await _profileRepo.getCompanyProfile(companyId);
    CompanyModel? companyModel;

    // Extract ticket data
    switch (companyDetails) {
      case result.Success(:final data):
        companyModel = data;
        break;
      case result.Failure(:final errorHandler):
        final msg = errorHandler.apiErrorModel.message ??
            "Failed to load company tickets";
        emit(Error(error: msg));
        return;
    }

    emit(Success<CompanyModel>(companyModel!));
  }
}
