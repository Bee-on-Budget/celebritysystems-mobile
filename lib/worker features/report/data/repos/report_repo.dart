import 'dart:convert';
import 'dart:io';

import 'package:celebritysystems_mobile/core/networking/api_error_handler.dart';
import 'package:celebritysystems_mobile/core/networking/api_result.dart';
import 'package:celebritysystems_mobile/worker%20features/report/data/models/report_request.dart';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import '../apis/report_api_service.dart';

class ReportRepo {
  final ReportApiService _reportApiService;

  ReportRepo(this._reportApiService);

  Future<ApiResult<void>> sendReport(
    int ticketId,
    ReportRequest reportRequest,
    File? solutionImage,
    File? technicianSignature,
  ) async {
    try {
      final formData = FormData();

      // Add text fields
      formData.fields.addAll([
        MapEntry(
            'date', reportRequest.date ?? DateTime.now().toIso8601String()),
        if (reportRequest.serviceType != null)
          MapEntry('serviceType', reportRequest.serviceType!),
        MapEntry('checklist', jsonEncode(reportRequest.checklist)),
        MapEntry('dateTime', DateTime.now().toIso8601String()),
        if (reportRequest.defectsFound != null)
          MapEntry('defectsFound', reportRequest.defectsFound!),
        if (reportRequest.solutionsProvided != null)
          MapEntry('solutionsProvided', reportRequest.solutionsProvided!),
      ]);

      // Add solution image if provided
      if (solutionImage != null) {
        final mimeType =
            lookupMimeType(solutionImage.path) ?? 'application/octet-stream';
        final mimeSplit = mimeType.split('/');
        formData.files.add(MapEntry(
          'solutionImage',
          await MultipartFile.fromFile(
            solutionImage.path,
            contentType: MediaType(mimeSplit[0], mimeSplit[1]),
          ),
        ));
      }

      // Add signature image if provided
      if (technicianSignature != null) {
        final mimeType = lookupMimeType(technicianSignature.path) ??
            'application/octet-stream';
        final mimeSplit = mimeType.split('/');
        formData.files.add(MapEntry(
          'technicianSignatures',
          await MultipartFile.fromFile(
            technicianSignature.path,
            contentType: MediaType(mimeSplit[0], mimeSplit[1]),
          ),
        ));
      }

      final response = await _reportApiService.sendReport(ticketId, formData);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}

// import 'dart:convert';
// import 'dart:io';

// import 'package:celebritysystems_mobile/core/networking/api_error_handler.dart';
// import 'package:celebritysystems_mobile/core/networking/api_result.dart';
// import 'package:celebritysystems_mobile/worker%20features/report/data/models/report_request.dart';
// import 'package:dio/dio.dart';
// import 'package:mime/mime.dart';
// import 'package:http_parser/http_parser.dart';

// import '../apis/report_api_service.dart';

// class ReportRepo {
//   final ReportApiService _reportApiService;

//   ReportRepo(this._reportApiService);

//   Future<ApiResult<void>> sendReport(
//     int ticketId,
//     ReportRequest reportRequest,
//     File? solutionImage, // 👈 now accept File?
//     File? technicianSignature, // 👈 now accept File?
//   ) async {
//     try {
//       MultipartFile? solutionMultipart;
//       if (solutionImage != null) {
//         final mimeType =
//             lookupMimeType(solutionImage.path) ?? 'application/octet-stream';
//         final mimeSplit = mimeType.split('/');
//         solutionMultipart = await MultipartFile.fromFile(
//           solutionImage.path,
//           contentType: MediaType(mimeSplit[0], mimeSplit[1]),
//         );
//       }

//       MultipartFile? signatureMultipart;
//       if (technicianSignature != null) {
//         final mimeType = lookupMimeType(technicianSignature.path) ??
//             'application/octet-stream';
//         final mimeSplit = mimeType.split('/');
//         signatureMultipart = await MultipartFile.fromFile(
//           technicianSignature.path,
//           contentType: MediaType(mimeSplit[0], mimeSplit[1]),
//         );
//       }

//       final response = await _reportApiService.sendReportWithImages(
//         ticketId,
//         reportRequest.date ?? DateTime.now().toIso8601String(), // or your date
//         reportRequest.serviceType,
//         jsonEncode(reportRequest.checklist),
//         DateTime.now().toIso8601String(),
//         reportRequest.defectsFound,
//         reportRequest.solutionsProvided,
//         solutionMultipart,
//         // signatureMultipart,
//       );

//       return ApiResult.success(response);
//     } catch (error) {
//       return ApiResult.failure(ErrorHandler.handle(error));
//     }
//   }
// }

// // import 'dart:convert';
// // import 'dart:io';

// // import 'package:celebritysystems_mobile/core/networking/api_error_handler.dart';
// // import 'package:celebritysystems_mobile/core/networking/api_result.dart';
// // import 'package:celebritysystems_mobile/worker%20features/report/data/models/report_request.dart';
// // import 'package:dio/dio.dart';

// // import '../apis/report_api_service.dart';

// // class ReportRepo {
// //   final ReportApiService _reportApiService;

// //   ReportRepo(this._reportApiService);

// //   Future<ApiResult<void>> sendReport(
// //       int ticketId,
// //       ReportRequest reportRequest,
// //       MultipartFile? solutionImageFile,
// //       MultipartFile? technicianImageFile) async {
// //     try {
// //       final response = await _reportApiService.sendReportWithImages(
// //           ticketId,
// //           "2025-08-15", //reportRequest.date,
// //           reportRequest.serviceType,
// //           jsonEncode(reportRequest.checklist),
// //           DateTime.now().toIso8601String(),
// //           reportRequest.defectsFound,
// //           reportRequest.solutionsProvided,
// //           solutionImageFile
// //           // null
// //           );

// //       return ApiResult.success(response);
// //     } catch (error) {
// //       return ApiResult.failure(ErrorHandler.handle(error));
// //     }
// //   }
// // }
