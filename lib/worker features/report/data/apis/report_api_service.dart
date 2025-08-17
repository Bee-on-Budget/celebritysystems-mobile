import 'package:celebritysystems_mobile/core/networking/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'report_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ReportApiService {
  factory ReportApiService(Dio dio) = _ReportApiService;

  @POST('/tickets/{ticketId}/worker-report')
  Future<void> sendReport(
    @Path('ticketId') int ticketId,
    @Body() FormData formData,
  );
}

// import 'dart:io';

// import 'package:celebritysystems_mobile/core/networking/api_constants.dart';
// import 'package:dio/dio.dart';
// import 'package:retrofit/retrofit.dart';

// part 'report_api_service.g.dart';

// @RestApi(baseUrl: ApiConstants.apiBaseUrl)
// abstract class ReportApiService {
//   factory ReportApiService(Dio dio) = _ReportApiService;

//   @POST('/tickets/{ticketId}/worker-report')
//   @MultiPart()
//   Future<void> sendReportWithImages(
//     @Path('ticketId') int ticketId,
//     @Part(name: "date") String? date,
//     @Part(name: "serviceType") String? serviceType,
//     @Part(name: "checklist") String? checklistJson,
//     @Part(name: "dateTime") String? dateTime, // Send as ISO string
//     @Part(name: "defectsFound") String? defectsFound,
//     @Part(name: "solutionsProvided") String? solutionsProvided,
//     @Part(name: "solutionImage") MultipartFile solutionImage,
//     // @Part(name: "technicianSignatures") MultipartFile? technicianSignatures,
//   );
// }
