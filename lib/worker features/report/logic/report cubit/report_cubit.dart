import 'dart:io';
import 'package:celebritysystems_mobile/core/networking/api_result.dart'
    as result;
import 'package:celebritysystems_mobile/worker%20features/report/data/models/report_request.dart';
import 'package:celebritysystems_mobile/worker%20features/report/logic/report%20cubit/report_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:celebritysystems_mobile/worker%20features/report/data/repos/report_repo.dart';

class ReportCubit extends Cubit<ReportState> {
  final ReportRepo _reportRepo;
  ReportRequest? reportRequest;

  ReportCubit(this._reportRepo) : super(ReportState.initial()) {
    reportRequest = ReportRequest(); // ✅ Initialize here
  }

  void sendReport(
    int ticketId,
    ReportRequest reportRequest,
    File? solutionImage,
    File? signatureImage,
  ) async {
    emit(ReportState.loading());

    print("===== Checklist =====");
    print(reportRequest.checklist);
    print("===== Defects Found =====");
    print(reportRequest.defectsFound);
    print(reportRequest.toString());

    // ✅ Just call repo, repo handles File → MultipartFile conversion
    final result.ApiResult<void> response = await _reportRepo.sendReport(
      ticketId,
      reportRequest,
      solutionImage,
      signatureImage,
    );

    print("******************************************");
    print("response is ");
    print(response);
    print(response.toString());
    print("******************************************");

    switch (response) {
      case result.Success():
        print("🎉 SUCCESS RESPONSE RECEIVED 🎉");
        emit(ReportState.success());

      case result.Failure(:final errorHandler):
        emit(ReportState.error(
          error: errorHandler.apiErrorModel.message ?? 'failure happened',
        ));
    }
  }
}
