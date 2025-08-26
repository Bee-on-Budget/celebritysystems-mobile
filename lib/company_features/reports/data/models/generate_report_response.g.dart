// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generate_report_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenerateReportResponse _$GenerateReportResponseFromJson(
        Map<String, dynamic> json) =>
    GenerateReportResponse(
      reportType: json['reportType'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      screenIds: (json['screenIds'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      totalCounts:
          TotalCounts.fromJson(json['totalCounts'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GenerateReportResponseToJson(
        GenerateReportResponse instance) =>
    <String, dynamic>{
      'reportType': instance.reportType,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'screenIds': instance.screenIds,
      'totalCounts': instance.totalCounts,
    };

TotalCounts _$TotalCountsFromJson(Map<String, dynamic> json) => TotalCounts(
      componentTotals: Map<String, int>.from(json['componentTotals'] as Map),
      overallTotal: (json['overallTotal'] as num).toInt(),
    );

Map<String, dynamic> _$TotalCountsToJson(TotalCounts instance) =>
    <String, dynamic>{
      'componentTotals': instance.componentTotals,
      'overallTotal': instance.overallTotal,
    };
