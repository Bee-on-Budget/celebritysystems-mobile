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
    File? solutionMedia,
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
      // if (solutionMedia != null) {
      //   final mimeType =
      //       lookupMimeType(solutionMedia.path) ?? 'application/octet-stream';
      //   final mimeSplit = mimeType.split('/');
      //   formData.files.add(MapEntry(
      //     'solutionImage',
      //     await MultipartFile.fromFile(
      //       solutionMedia.path,
      //       contentType: MediaType(mimeSplit[0], mimeSplit[1]),
      //     ),
      //   ));
      // }

      // Add media file (image or video) if provided
      if (solutionMedia != null) {
        // Check file size
        final fileSizeInBytes = await solutionMedia.length();
        final fileSizeInMB = fileSizeInBytes / (1024 * 1024);
        print('📁 File size: ${fileSizeInMB.toStringAsFixed(2)} MB');

        final mimeType =
            lookupMimeType(solutionMedia.path) ?? 'application/octet-stream';
        final mimeSplit = mimeType.split('/');

        // Generate filename with timestamp
        final extension = solutionMedia.path.split('.').last;
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final isVideo = ['mp4', 'mov', 'avi', 'mkv', '3gp', 'webm']
            .contains(extension.toLowerCase());
        final filename = isVideo
            ? 'ticket_video_$timestamp.$extension'
            : 'ticket_image_$timestamp.$extension';

        formData.files.add(MapEntry(
          'solutionImage', // Backend expects 'ticketImage' for both image and video
          await MultipartFile.fromFile(
            solutionMedia.path,
            filename: filename,
            contentType: MediaType(mimeSplit[0], mimeSplit[1]),
          ),
        ));

        print('📤 Uploading ${isVideo ? 'video' : 'image'}: $filename');
      }

      // Make request with extended timeout
      final options = Options(
        receiveTimeout: const Duration(minutes: 5), // 5 minutes for large files
        sendTimeout: const Duration(minutes: 5), // 5 minutes for uploads
      );

      final response = await _reportApiService.sendReport(
        ticketId, formData, options, // Pass custom timeout options
      );
      return ApiResult.success(response);
    } catch (error) {
      print('❌ Upload error: $error');
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
