import 'package:celebritysystems_mobile/company_features/reports/data/api/report_api_service.dart';
import 'package:celebritysystems_mobile/company_features/reports/data/models/analytics_request.dart';
import 'package:celebritysystems_mobile/company_features/reports/data/models/generate_report_request.dart';
import 'package:celebritysystems_mobile/company_features/reports/data/models/generate_report_response.dart';
import 'package:celebritysystems_mobile/company_features/reports/ui/report_screen.dart';

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

  Future<ApiResult<AnalyticsResponse>> analyticsTickets(
      AnalyticsRequest request) async {
    try {
      final AnalyticsResponse response =
          await _reportApiService.analyticsTickets(
              screenIds: request.screenIds,
              startDate: request.startDate,
              endDate: request.endDate);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
