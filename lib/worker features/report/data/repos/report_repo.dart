import 'dart:io';

import 'package:celebritysystems_mobile/core/networking/api_error_handler.dart';
import 'package:celebritysystems_mobile/core/networking/api_result.dart';
import 'package:celebritysystems_mobile/worker%20features/report/data/models/report_request.dart';

import '../apis/report_dio_api_service.dart';

class ReportRepo {
  // final ReportApiService _reportApiService;

  // ReportRepo(this._reportApiService);
  ReportRepo([Object? object]);

  Future<ApiResult<void>> sendReport(int ticketId, ReportWrapper reportRequest,
      File? solutionImageFile, File? technicianImageFile) async {
    try {
      final respone = await sendReportWithImages(
          ticketId: ticketId,
          reportWrapper: reportRequest,
          solutionImageFile: solutionImageFile,
          technicianImageFile: technicianImageFile);
      return ApiResult.success(respone);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
