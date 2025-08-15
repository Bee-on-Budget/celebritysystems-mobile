// import 'package:celebritysystems_mobile/worker%20features/report/data/models/report_request.dart';
// import 'package:dio/dio.dart';
// import 'package:retrofit/retrofit.dart';

// import '../../../../core/networking/api_constants.dart';

// part 'report_api_service.g.dart';

// @RestApi(baseUrl: ApiConstants.apiBaseUrl)
// abstract class ReportApiService {
//   factory ReportApiService(Dio dio) = _ReportApiService;

//   @POST("tickets/{ticketId}/worker-report")
//   Future<void> sendReport(
//     @Path('ticketId') int ticketId,
//     @Body() ReportWrapper reportRequest,
//   );
// }

import 'dart:io';

import 'package:celebritysystems_mobile/core/networking/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'report_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ReportApiService {
  factory ReportApiService(Dio dio) = _ReportApiService;

  @POST('/tickets/{ticketId}/worker-report')
  @MultiPart()
  Future<void> sendReportWithImages(
    @Path('ticketId') int ticketId,
    @Part(name: "date") String? date,
    @Part(name: "serviceType") String? serviceType,
    @Part(name: "checklist") String? checklistJson,
    @Part(name: "dateTime") String? dateTime, // Send as ISO string
    @Part(name: "defectsFound") String? defectsFound,
    @Part(name: "solutionsProvided") String? solutionsProvided,
    // @Part(name: "technicianSignatures") File? technicianSignatures,
    // @Part(name: "solutionImage") File? solutionImage,
  );
}
