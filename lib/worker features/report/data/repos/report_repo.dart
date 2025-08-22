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

      final response = await _reportApiService.sendReport(ticketId, formData);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
