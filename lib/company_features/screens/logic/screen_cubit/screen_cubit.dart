import 'package:celebritysystems_mobile/company_features/screens/data/repo/screen_details_repo.dart';
import 'package:celebritysystems_mobile/company_features/screens/logic/screen_cubit/screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/networking/api_result.dart' as result;

class ScreenCubit extends Cubit<ScreenState> {
  final ScreenDetailsRepo _screenDetailsRepo;

  ScreenCubit(this._screenDetailsRepo) : super(ScreenState.initial());

  Future<void> getTicketsHistoryForScreen(int screenId) async {
    emit(Loading());

    final ticketsHistory =
        await _screenDetailsRepo.getTicketsHistoryForScreen(screenId);

    switch (ticketsHistory) {
      case result.Success(:final data):
        emit(Success(data));
        break;
      case result.Failure(:final errorHandler):
        final msg = errorHandler.apiErrorModel.message ??
            "Failed to load tickets jistory for this screen";
        emit(Error(error: msg));
        return;
    }

    // emit(Success<CompanyModel>(companyModel!));
  }
}
