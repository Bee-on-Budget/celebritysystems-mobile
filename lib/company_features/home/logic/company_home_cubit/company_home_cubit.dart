import 'package:celebritysystems_mobile/company_features/home/data/models/company_screen_model.dart';
import 'package:celebritysystems_mobile/company_features/home/data/repos/company_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/networking/api_result.dart' as result;
import '../../data/models/company_tickets_response.dart';
import '../../data/repos/company_ticket_repo.dart';
import 'company_home_state.dart';

class CompanyHomeCubit extends Cubit<CompanyHomeState> {
  final CompanyTicketRepo _companyTicketRepo;
  final CompanyRepo _companyRepo;

  CompanyHomeCubit(this._companyTicketRepo, this._companyRepo)
      : super(CompanyHomeState.initial());

  List<CompanyScreenModel> listOfCompanyScreen = [];

  Future<void> loadCompanyHomeData(int companyId) async {
    emit(Loading<List<CompanyTicketResponse>>());

    final ticketsResult = await _companyTicketRepo.getCompanyTickets(companyId);

    List<CompanyTicketResponse> tickets = [];

    // Extract ticket data
    switch (ticketsResult) {
      case result.Success(:final data):
        tickets = data;
        break;
      case result.Failure(:final errorHandler):
        final msg = errorHandler.apiErrorModel.message ??
            "Failed to load company tickets";
        emit(Error<List<CompanyTicketResponse>>(error: msg));
        return;
    }

    emit(Success<List<CompanyTicketResponse>>(tickets));
  }

  Future<void> loadcompanyScreensData(int companyId) async {
    emit(Loading());

    final result.ApiResult<List<CompanyScreenModel>> listOfScreen =
        await _companyRepo.getCompanyScreens(companyId);

    // Extract ticket data
    switch (listOfScreen) {
      case result.Success(:final data):
        listOfCompanyScreen = data;
      case result.Failure(:final errorHandler):
        final msg =
            errorHandler.apiErrorModel.message ?? "Failed to load tickets";
        emit(Error(error: msg));
        return;
    }

    emit(Success(listOfCompanyScreen));
  }
}
