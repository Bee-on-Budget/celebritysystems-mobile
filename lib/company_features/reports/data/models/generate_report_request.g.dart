// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generate_report_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenerateReportRequest _$GenerateReportRequestFromJson(
        Map<String, dynamic> json) =>
    GenerateReportRequest(
      screenIds: (json['screenIds'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      reportType: json['reportType'] as String,
    );

Map<String, dynamic> _$GenerateReportRequestToJson(
        GenerateReportRequest instance) =>
    <String, dynamic>{
      'screenIds': instance.screenIds,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'reportType': instance.reportType,
    };
