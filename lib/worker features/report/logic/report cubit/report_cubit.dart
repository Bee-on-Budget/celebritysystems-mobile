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

  // late String serviceType;
  // late CheckList checkList;

  void sendReport(int ticketId, ReportRequest reportRequest) async {
    // TODO solution image, sigImage
    emit(ReportState.loading());
    print("000000 reportRequest.checklist 00000000000000000000");
    print(reportRequest.checklist.toString());
    print("000000000000     defectsFound    0000000000000000000");
    print(reportRequest.defectsFound.toString());

    print("000000000000     solutionsProvided    0000000000000000000");
    print(reportRequest.solutionsProvided.toString());

    print(reportRequest.toString());
    ReportWrapper reportWrapper = ReportWrapper(report: reportRequest);

    final result.ApiResult<void> response = await _reportRepo.sendReport(
        ticketId, reportWrapper, null, null); // TODO solution image, sigImage

    print("******************************************");
    print("response is ");
    print(response);
    print(response.toString());
    print("******************************************");

    switch (response) {
      case result.Success():
        print(
            "WE HAVE SUCCESS RESPONSEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");

        emit(ReportState.success());

      case result.Failure(:final errorHandler):
        emit(ReportState.error(
          error: errorHandler.apiErrorModel.message ?? 'failure happened',
        ));
    }
  }
}
