// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalyticsRequest _$AnalyticsRequestFromJson(Map<String, dynamic> json) =>
    AnalyticsRequest(
      screenIds: (json['screenIds'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
    );

Map<String, dynamic> _$AnalyticsRequestToJson(AnalyticsRequest instance) =>
    <String, dynamic>{
      'screenIds': instance.screenIds,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
    };
