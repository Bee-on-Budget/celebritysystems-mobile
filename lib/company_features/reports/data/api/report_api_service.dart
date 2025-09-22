import 'package:celebritysystems_mobile/company_features/reports/data/models/analytics_response.dart';
import 'package:celebritysystems_mobile/company_features/reports/data/models/generate_report_request.dart';
import 'package:celebritysystems_mobile/company_features/reports/data/models/generate_report_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/networking/api_constants.dart';

part 'report_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ReportApiService {
  factory ReportApiService(Dio dio) = _ReportApiService;

  @POST('reporting/generate')
  Future<GenerateReportResponse> generateReport(
    @Body() GenerateReportRequest request,
  );

  @GET('tickets/analytics/summary')
  Future<AnalyticsResponse> analyticsTickets({
    @Query('screenIds') List<int>? screenIds,
    @Query('startDate') String? startDate,
    @Query('endDate') String? endDate,
  });
}
