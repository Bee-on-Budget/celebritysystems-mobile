import 'dart:io';

import 'package:celebritysystems_mobile/company_features/create_company_ticket/data/model/create_ticket_request.dart';
import 'package:celebritysystems_mobile/company_features/create_company_ticket/data/repo/create_ticket_repo.dart';
import 'package:celebritysystems_mobile/company_features/create_company_ticket/logic/cubit/create_ticket_state.dart';
import 'package:celebritysystems_mobile/core/networking/api_result.dart'
    as result;
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateTicketCubit extends Cubit<CreateTicketState> {
  final CreateTicketRepo _createTicketRepo;
  CreateTicketRequest? createCompanyTicketReq;

  CreateTicketCubit(this._createTicketRepo)
      : super(CreateTicketState.initial()) {
    createCompanyTicketReq = CreateTicketRequest(); // ✅ Initialize here
  }

  void createCompanyTicket(
    CreateTicketRequest createCompanyTicketReq,
    File? issueImage,
  ) async {
    emit(CreateTicketState.loading());

    // ✅ Just call repo, repo handles File → MultipartFile conversion
    final result.ApiResult<void> response =
        await _createTicketRepo.createCompanyTicket(
      createCompanyTicketReq,
      issueImage,
    );

    switch (response) {
      case result.Success():
        print("🎉 SUCCESS RESPONSE RECEIVED 🎉");
        emit(CreateTicketState.success());

      case result.Failure(:final errorHandler):
        emit(CreateTicketState.error(
          error: errorHandler.apiErrorModel.message ?? 'failure happened',
        ));
    }
  }
}
