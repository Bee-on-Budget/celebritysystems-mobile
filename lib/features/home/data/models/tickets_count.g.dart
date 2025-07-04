// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tickets_count.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketsCount _$TicketsCountFromJson(Map<String, dynamic> json) => TicketsCount(
      assignedCount: (json['assignedCount'] as num?)?.toInt(),
      completedCount: (json['completedCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TicketsCountToJson(TicketsCount instance) =>
    <String, dynamic>{
      'assignedCount': instance.assignedCount,
      'completedCount': instance.completedCount,
    };
