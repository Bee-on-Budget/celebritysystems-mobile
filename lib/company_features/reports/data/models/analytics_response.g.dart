// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalyticsResponse _$AnalyticsResponseFromJson(Map<String, dynamic> json) =>
    AnalyticsResponse(
      averageResolutionTime: json['averageResolutionTime'] as String,
      averageResolutionTimeFormatted:
          json['averageResolutionTimeFormatted'] as String,
      serviceTypeCounts:
          Map<String, int>.from(json['serviceTypeCounts'] as Map),
      averageTimeByServiceType:
          Map<String, String>.from(json['averageTimeByServiceType'] as Map),
      totalTickets: (json['totalTickets'] as num).toInt(),
    );

Map<String, dynamic> _$AnalyticsResponseToJson(AnalyticsResponse instance) =>
    <String, dynamic>{
      'averageResolutionTime': instance.averageResolutionTime,
      'averageResolutionTimeFormatted': instance.averageResolutionTimeFormatted,
      'serviceTypeCounts': instance.serviceTypeCounts,
      'averageTimeByServiceType': instance.averageTimeByServiceType,
      'totalTickets': instance.totalTickets,
    };
