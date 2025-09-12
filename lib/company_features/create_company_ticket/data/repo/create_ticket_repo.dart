import 'dart:io';

import 'package:celebritysystems_mobile/company_features/create_company_ticket/data/api/create_ticket_api_service.dart';
import 'package:celebritysystems_mobile/company_features/create_company_ticket/data/model/create_ticket_request.dart';
import 'package:celebritysystems_mobile/core/networking/api_error_handler.dart';
import 'package:celebritysystems_mobile/core/networking/api_result.dart';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class CreateTicketRepo {
  final CreateTicketApiService _createCompanyTicketApiService;

  CreateTicketRepo(this._createCompanyTicketApiService);

  Future<ApiResult<void>> createCompanyTicket(
    CreateTicketRequest createCompanyTicketReq,
    File? mediaFile, // Single media file (image or video)
  ) async {
    try {
      final formData = FormData();

      // Add text fields
      formData.fields.addAll([
        MapEntry('title', createCompanyTicketReq.title ?? ""),
        if (createCompanyTicketReq.screenId != null)
          MapEntry('screenId', createCompanyTicketReq.screenId.toString()),
        MapEntry('description', createCompanyTicketReq.description ?? ""),
        MapEntry('status', "OPEN"),
        if (createCompanyTicketReq.companyId != null)
          MapEntry('companyId', createCompanyTicketReq.companyId.toString()),
        if (createCompanyTicketReq.serviceType != null)
          MapEntry(
              'serviceType', createCompanyTicketReq.serviceType.toString()),
      ]);

      // Add media file (image or video) if provided
      if (mediaFile != null) {
        // Check file size
        final fileSizeInBytes = await mediaFile.length();
        final fileSizeInMB = fileSizeInBytes / (1024 * 1024);
        print('📁 File size: ${fileSizeInMB.toStringAsFixed(2)} MB');

        final mimeType =
            lookupMimeType(mediaFile.path) ?? 'application/octet-stream';
        final mimeSplit = mimeType.split('/');

        // Generate filename with timestamp
        final extension = mediaFile.path.split('.').last;
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final isVideo = ['mp4', 'mov', 'avi', 'mkv', '3gp', 'webm']
            .contains(extension.toLowerCase());
        final filename = isVideo
            ? 'ticket_video_$timestamp.$extension'
            : 'ticket_image_$timestamp.$extension';

        formData.files.add(MapEntry(
          'ticketImage', // Backend expects 'ticketImage' for both image and video
          await MultipartFile.fromFile(
            mediaFile.path,
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

      // Make request with extended timeout
      final response = await _createCompanyTicketApiService.createTicket(
        formData,
        options, // Pass custom timeout options
      );
      return ApiResult.success(response);
    } catch (error) {
      print('❌ Upload error: $error');
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}

// import 'dart:io';

// import 'package:celebritysystems_mobile/company_features/create_company_ticket/data/api/create_ticket_api_service.dart';
// import 'package:celebritysystems_mobile/company_features/create_company_ticket/data/model/create_ticket_request.dart';
// import 'package:celebritysystems_mobile/core/networking/api_error_handler.dart';
// import 'package:celebritysystems_mobile/core/networking/api_result.dart';
// import 'package:dio/dio.dart';
// import 'package:mime/mime.dart';
// import 'package:http_parser/http_parser.dart';

// class CreateTicketRepo {
//   final CreateTicketApiService _createCompanyTicketApiService;

//   CreateTicketRepo(this._createCompanyTicketApiService);

//   Future<ApiResult<void>> createCompanyTicket(
//     CreateTicketRequest createCompanyTicketReq,
//     File? mediaFile, // Single media file (image or video)
//   ) async {
//     try {
//       final formData = FormData();

//       // Add text fields
//       formData.fields.addAll([
//         MapEntry('title', createCompanyTicketReq.title ?? ""),
//         if (createCompanyTicketReq.screenId != null)
//           MapEntry('screenId', createCompanyTicketReq.screenId.toString()),
//         MapEntry('description', createCompanyTicketReq.description ?? ""),
//         MapEntry('status', "OPEN"),
//         if (createCompanyTicketReq.companyId != null)
//           MapEntry('companyId', createCompanyTicketReq.companyId.toString()),
//         if (createCompanyTicketReq.serviceType != null)
//           MapEntry(
//               'serviceType', createCompanyTicketReq.serviceType.toString()),
//       ]);

//       // Add media file (image or video) if provided
//       if (mediaFile != null) {
//         final mimeType =
//             lookupMimeType(mediaFile.path) ?? 'application/octet-stream';
//         final mimeSplit = mimeType.split('/');

//         // Generate filename with timestamp
//         final extension = mediaFile.path.split('.').last;
//         final timestamp = DateTime.now().millisecondsSinceEpoch;
//         final filename = 'ticket_media_$timestamp.$extension';

//         formData.files.add(MapEntry(
//           'ticketImage', // Backend expects 'ticketImage' for both image and video
//           await MultipartFile.fromFile(
//             mediaFile.path,
//             filename: filename,
//             contentType: MediaType(mimeSplit[0], mimeSplit[1]),
//           ),
//         ));
//       }

//       final response =
//           await _createCompanyTicketApiService.createTicket(formData);
//       return ApiResult.success(response);
//     } catch (error) {
//       return ApiResult.failure(ErrorHandler.handle(error));
//     }
//   }
// }

// import 'dart:io';

// import 'package:celebritysystems_mobile/company_features/create_company_ticket/data/api/create_ticket_api_service.dart';
// import 'package:celebritysystems_mobile/company_features/create_company_ticket/data/model/create_ticket_request.dart';
// import 'package:celebritysystems_mobile/core/networking/api_error_handler.dart';
// import 'package:celebritysystems_mobile/core/networking/api_result.dart';
// import 'package:dio/dio.dart';
// import 'package:mime/mime.dart';
// import 'package:http_parser/http_parser.dart';

// class CreateTicketRepo {
//   final CreateTicketApiService _createCompanyTicketApiService;

//   CreateTicketRepo(this._createCompanyTicketApiService);

//   Future<ApiResult<void>> createCompanyTicket(
//       CreateTicketRequest createCompanyTicketReq, File? issueImage) async {
//     try {
//       final formData = FormData();

//       // Add text fields
//       formData.fields.addAll([
//         MapEntry('title', createCompanyTicketReq.title ?? ""),
//         if (createCompanyTicketReq.screenId != null)
//           MapEntry('screenId', createCompanyTicketReq.screenId.toString()),
//         MapEntry('description', createCompanyTicketReq.description ?? ""),
//         MapEntry('status', "OPEN"),
//         if (createCompanyTicketReq.companyId != null)
//           MapEntry('companyId', createCompanyTicketReq.companyId.toString()),
//         if (createCompanyTicketReq.serviceType != null)
//           MapEntry(
//               'serviceType', createCompanyTicketReq.serviceType.toString()),
//       ]);

//       // Add solution image if provided
//       if (issueImage != null) {
//         final mimeType =
//             lookupMimeType(issueImage.path) ?? 'application/octet-stream';
//         final mimeSplit = mimeType.split('/');
//         formData.files.add(MapEntry(
//           'ticketImage',
//           await MultipartFile.fromFile(
//             issueImage.path,
//             contentType: MediaType(mimeSplit[0], mimeSplit[1]),
//           ),
//         ));
//       }

//       final response =
//           await _createCompanyTicketApiService.createTicket(formData);
//       return ApiResult.success(response);
//     } catch (error) {
//       return ApiResult.failure(ErrorHandler.handle(error));
//     }
//   }
// }
