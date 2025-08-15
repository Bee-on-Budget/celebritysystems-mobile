// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:celebritysystems_mobile/worker%20features/report/data/models/report_request.dart';
// import '../../../../core/di/dependency_injection.dart'; // Where `getIt` is defined

// Future<void> sendReportWithImages({
//   required int ticketId,
//   required ReportWrapper reportWrapper,
//   File? solutionImageFile,
//   File? technicianImageFile,
// }) async {
//   final dio = getIt<Dio>(); // Use the registered Dio instance

//   final jsonReport = reportWrapper.toJson();

//   MultipartFile? solutionMultipart;
//   MultipartFile? technicianMultipart;

//   if (solutionImageFile != null) {
//     solutionMultipart = await MultipartFile.fromFile(
//       solutionImageFile.path,
//       filename: 'solution.jpg',
//     );
//   }

//   if (technicianImageFile != null) {
//     technicianMultipart = await MultipartFile.fromFile(
//       technicianImageFile.path,
//       filename: 'technician.jpg',
//     );
//   }

//   final formMap = Map<String, dynamic>.from(jsonReport);

//   if (solutionMultipart != null) {
//     formMap['solution_image'] = solutionMultipart;
//   }
//   if (technicianMultipart != null) {
//     formMap['technician_image'] = technicianMultipart;
//   }

//   final formData = FormData.fromMap(formMap);

//   try {
//     final response = await dio.post(
//       'tickets/$ticketId/worker-report',
//       data: formData,
//       options: Options(contentType: 'multipart/form-data'),
//     );

//     if (response.statusCode == 200) {
//       print('Report sent successfully');
//     } else {
//       print('Failed to send report: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error sending report: $e');
//   }
// }
