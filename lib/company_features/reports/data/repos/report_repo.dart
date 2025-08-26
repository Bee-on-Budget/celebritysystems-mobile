import 'package:celebritysystems_mobile/company_features/reports/data/api/report_api_service.dart';
import 'package:celebritysystems_mobile/company_features/reports/data/models/generate_report_request.dart';
import 'package:celebritysystems_mobile/company_features/reports/data/models/generate_report_response.dart';

import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_result.dart';

class ReportRepo {
  final ReportApiService _reportApiService;

  ReportRepo(this._reportApiService);

  Future<ApiResult<GenerateReportResponse>> generateReport(
      GenerateReportRequest request) async {
    try {
      final GenerateReportResponse response =
          await _reportApiService.generateReport(request);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
