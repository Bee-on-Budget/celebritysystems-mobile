import 'dart:io';

import 'package:celebritysystems_mobile/core/networking/api_error_handler.dart';
import 'package:celebritysystems_mobile/core/networking/api_result.dart';
import 'package:celebritysystems_mobile/worker%20features/home/data/apis/ticket_api_service.dart';
import 'package:celebritysystems_mobile/worker%20features/home/data/models/tickets_count.dart';
import 'package:celebritysystems_mobile/worker%20features/home/data/models/tickets_response.dart';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class TicketRepo {
  final TicketApiService _ticketApiService;

  TicketRepo(this._ticketApiService);

  Future<ApiResult<List<OneTicketResponse>>> getTickets(String username) async {
    try {
      final List<OneTicketResponse> respone =
          await _ticketApiService.getTickets(username);

      print("in repo try respone is " + respone.toString());
      return ApiResult.success(respone);
    } catch (error) {
      print("in repo catch error is " + error.toString());
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  Future<ApiResult<TicketsCount>> getTicketsCount(String username) async {
    try {
      final TicketsCount respone =
          await _ticketApiService.getTicketsCount(username);

      print("in repo try respone is " + respone.toString());
      return ApiResult.success(respone);
    } catch (error) {
      print("in repo catch error is " + error.toString());
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> downloadImage(int ticketId) async {
    try {
      final respone = await _ticketApiService.downloadImage(ticketId);

      print("in repo try respone is " + respone.toString());
      return ApiResult.success(respone);
    } catch (error) {
      print("in repo catch error is " + error.toString());
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  Future<ApiResult<void>> sendImage(
      int ticketId, File fileImage, String userId) async {
    try {
      final formData = FormData();

      // Add text fields
      formData.fields.addAll([
        MapEntry('ticketId', ticketId.toString()),
        MapEntry('uploadedBy', userId),
      ]);

      // Add image
      if (fileImage != null) {
        final mimeType =
            lookupMimeType(fileImage.path) ?? 'application/octet-stream';
        final mimeSplit = mimeType.split('/');

        // Generate filename with timestamp
        final extension = fileImage.path.split('.').last;
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final filename = 'ticket_image_$timestamp.$extension';

        formData.files.add(MapEntry(
          'filePath',
          await MultipartFile.fromFile(
            fileImage.path,
            filename: filename,
            contentType: MediaType(mimeSplit[0], mimeSplit[1]),
          ),
        ));

        print('📤 Uploading image}: $fileImage');
      }

      // Make request with extended timeout
      final response = await _ticketApiService.sendImage(
        formData,
      );
      return ApiResult.success(response);
    } catch (error) {
      print('❌ Upload error: $error');
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
