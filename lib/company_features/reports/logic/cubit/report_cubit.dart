import 'package:celebritysystems_mobile/company_features/reports/data/models/generate_report_request.dart';
import 'package:celebritysystems_mobile/company_features/reports/data/models/generate_report_response.dart';
import 'package:celebritysystems_mobile/company_features/reports/data/repos/report_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/networking/api_result.dart' as result;
import 'report_state.dart';

class ReportCubit extends Cubit<ReportState<GenerateReportResponse>> {
  final ReportRepo _reportRepo;

  ReportCubit({required ReportRepo reportRepo})
      : _reportRepo = reportRepo,
        super(const ReportState.initial());

  Future<void> generateReport(GenerateReportRequest request) async {
    emit(const ReportState.loading());

    final result.ApiResult<GenerateReportResponse> reportResult =
        await _reportRepo.generateReport(request);

    switch (reportResult) {
      case result.Success(:final data):
        emit(ReportState.success(data));
        break;
      case result.Failure(:final errorHandler):
        final msg =
            errorHandler.apiErrorModel.message ?? "Failed to generate report";
        emit(ReportState.error(error: msg));
        break;
    }
  }

  void resetState() {
    emit(const ReportState.initial());
  }
}
