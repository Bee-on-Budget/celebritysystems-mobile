import 'dart:convert';
import 'dart:io';

import 'package:celebritysystems_mobile/core/networking/api_error_handler.dart';
import 'package:celebritysystems_mobile/core/networking/api_result.dart';
import 'package:celebritysystems_mobile/worker%20features/report/data/models/report_request.dart';
import 'package:dio/dio.dart';

import '../apis/report_api_service.dart';
import '../apis/report_dio_api_service.dart';

class ReportRepo {
  final ReportApiService _reportApiService;

  ReportRepo(this._reportApiService);

  Future<ApiResult<void>> sendReport(int ticketId, ReportRequest reportRequest,
      File? solutionImageFile, File? technicianImageFile) async {
    try {
      final response = await _reportApiService.sendReportWithImages(
        ticketId,
        "2025-08-15", //reportRequest.date,
        reportRequest.serviceType,
        jsonEncode(reportRequest.checklist),
        DateTime.now().toIso8601String(),
        reportRequest.defectsFound,
        reportRequest.solutionsProvided,
        // null,
        // null
      );

      // await sendReportWithImages(
      //     ticketId: ticketId,
      //     reportRequest: reportRequest,
      //     solutionImageFile: solutionImageFile,
      //     technicianImageFile: technicianImageFile);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  Future<void> sendReportWithImages({
    required int ticketId,
    required ReportRequest reportRequest,
    File? solutionImageFile,
    File? technicianImageFile,
  }) async {
    try {
      // Create FormData for multipart request
      FormData formData = FormData();

      // Add the report JSON data as a string
      formData.fields
          .add(MapEntry('report', jsonEncode(reportRequest.toJson())));

      // Add solution image if provided
      if (solutionImageFile != null) {
        String fileName = solutionImageFile.path.split('/').last;
        formData.files.add(MapEntry(
          'solution_image',
          await MultipartFile.fromFile(
            solutionImageFile.path,
            filename: fileName,
          ),
        ));
      }

      // Add technician/signature image if provided
      if (technicianImageFile != null) {
        String fileName = technicianImageFile.path.split('/').last;
        formData.files.add(MapEntry(
          'signature_image',
          await MultipartFile.fromFile(
            technicianImageFile.path,
            filename: fileName,
          ),
        ));
      }

      // Make the API call using your ReportApiService
      // await _reportApiService.sendReportWithImages(ticketId, formData);
    } catch (error) {
      print('Error in sendReportWithImages: $error');
      rethrow;
    }
  }
}

// import 'dart:io';

// import 'package:celebritysystems_mobile/core/networking/api_error_handler.dart';
// import 'package:celebritysystems_mobile/core/networking/api_result.dart';
// import 'package:celebritysystems_mobile/worker%20features/report/data/models/report_request.dart';

// import '../apis/report_api_service.dart';
// import '../apis/report_dio_api_service.dart';

// class ReportRepo {
//   final ReportApiService _reportApiService;

//   ReportRepo(this._reportApiService);
//   // ReportRepo([Object? object]);

//   Future<ApiResult<void>> sendReport(int ticketId, ReportWrapper reportRequest,
//       File? solutionImageFile, File? technicianImageFile) async {
//     try {
//       final respone = await sendReportWithImages(
//           ticketId: ticketId,
//           reportWrapper: reportRequest,
//           solutionImageFile: solutionImageFile,
//           technicianImageFile: technicianImageFile);
//       return ApiResult.success(respone);
//     } catch (error) {
//       return ApiResult.failure(ErrorHandler.handle(error));
//     }
//   }
// }
