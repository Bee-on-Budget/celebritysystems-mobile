import 'package:celebritysystems_mobile/core/networking/api_result.dart'
    as result;
import 'package:celebritysystems_mobile/worker%20features/report/data/models/report_request.dart';
import 'package:celebritysystems_mobile/worker%20features/report/logic/report%20cubit/report_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:celebritysystems_mobile/worker%20features/report/data/repos/report_repo.dart';

class ReportCubit extends Cubit<ReportState> {
  final ReportRepo _reportRepo;
  ReportCubit(this._reportRepo) : super(ReportState.initial());

  // late String serviceType;
  // late CheckList checkList;
  ReportRequest? reportRequest;

  void sendReport(ReportRequest reportRequest) async {
    emit(ReportState.loading());
    print(reportRequest);
    print("0000000000000000000000000000000000000000000000000000");

    print(reportRequest.toString());
    ReportWrapper reportWrapper = ReportWrapper(report: reportRequest);

    final result.ApiResult<void> response =
        await _reportRepo.sendReport(reportWrapper);

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
