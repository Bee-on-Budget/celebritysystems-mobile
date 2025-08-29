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
      CreateTicketRequest createCompanyTicketReq, File? issueImage) async {
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

      // Add solution image if provided
      if (issueImage != null) {
        final mimeType =
            lookupMimeType(issueImage.path) ?? 'application/octet-stream';
        final mimeSplit = mimeType.split('/');
        formData.files.add(MapEntry(
          'ticketImage',
          await MultipartFile.fromFile(
            issueImage.path,
            contentType: MediaType(mimeSplit[0], mimeSplit[1]),
          ),
        ));
      }

      final response =
          await _createCompanyTicketApiService.createTicket(formData);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
