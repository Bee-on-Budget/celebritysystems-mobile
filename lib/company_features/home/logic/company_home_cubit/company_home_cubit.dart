import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/networking/api_result.dart' as result;
import '../../data/models/company_tickets_response.dart';
import '../../data/repos/company_ticket_repo.dart';
import 'company_home_state.dart';

class CompanyHomeCubit extends Cubit<CompanyHomeState> {
  final CompanyTicketRepo _companyTicketRepo;

  CompanyHomeCubit(this._companyTicketRepo) : super(CompanyHomeState.initial());

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
}
