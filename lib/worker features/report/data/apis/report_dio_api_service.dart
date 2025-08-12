import 'package:celebritysystems_mobile/worker%20features/report/data/models/report_request.dart';
import 'package:dio/dio.dart';
import 'dart:io';

Future<void> sendReportWithImages({
  required int ticketId,
  required ReportWrapper reportWrapper,
  File? solutionImageFile,
  File? technicianImageFile,
}) async {
  final dio = Dio();
  late MultipartFile solutionMultipart;
  late MultipartFile technicianMultipart;

  // Convert report to flat map of text fields
  // final formFields = report.toFormDataMap();
  final JsonReport = reportWrapper.toJson();

  // Prepare multipart files
  if (solutionImageFile != null) {
    solutionMultipart = await MultipartFile.fromFile(
      solutionImageFile.path,
      filename: 'solution.jpg',
    );
  }

  if (technicianImageFile != null) {
    technicianMultipart = await MultipartFile.fromFile(
      technicianImageFile.path,
      filename: 'technician.jpg',
    );
  }

  if (solutionMultipart != null && technicianMultipart != null) {}
  // Compose FormData
  final formData = FormData.fromMap({
    ...JsonReport,
    'solution_image': solutionMultipart,
    'technician_image': technicianMultipart,
  });

  try {
    final response = await dio.post(
      'tickets/$ticketId/worker-report',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );

    if (response.statusCode == 200) {
      print('Report sent successfully');
    } else {
      print('Failed to send report: ${response.statusCode}');
    }
  } catch (e) {
    print('Error sending report: $e');
  }
}
