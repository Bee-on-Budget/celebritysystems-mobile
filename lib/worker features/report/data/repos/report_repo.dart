import 'package:celebritysystems_mobile/core/networking/api_error_handler.dart';
import 'package:celebritysystems_mobile/core/networking/api_result.dart';
import 'package:celebritysystems_mobile/worker%20features/report/data/apis/report_api_service.dart';
import 'package:celebritysystems_mobile/worker%20features/report/data/models/report_request.dart';

class ReportRepo {
  final ReportApiService _reportApiService;

  ReportRepo(this._reportApiService);

  Future<ApiResult<void>> sendReport(ReportRequest reportRequest) async {
    try {
      final respone = await _reportApiService.sendReport(reportRequest);
      return ApiResult.success(respone);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
