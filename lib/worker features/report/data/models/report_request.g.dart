// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportRequest _$ReportRequestFromJson(Map<String, dynamic> json) =>
    ReportRequest(
      date: json['date'] as String?,
      serviceType: json['service_type'] as String?,
      dateTime: json['date_time'] == null
          ? null
          : DateTime.parse(json['date_time'] as String),
      checklist: json['checklist'] == null
          ? null
          : CheckList.fromJson(json['checklist'] as Map<String, dynamic>),
      defectsFound: json['defects_found'] as String?,
      solutionsProvided: json['solutions_provided'] as String?,
    );

Map<String, dynamic> _$ReportRequestToJson(ReportRequest instance) =>
    <String, dynamic>{
      'date': instance.date,
      'service_type': instance.serviceType,
      'date_time': instance.dateTime?.toIso8601String(),
      'checklist': instance.checklist,
      'defects_found': instance.defectsFound,
      'solutions_provided': instance.solutionsProvided,
    };

CheckList _$CheckListFromJson(Map<String, dynamic> json) => CheckList(
      dataCables: json['Data Cables (Cat6/RJ45)'] as String?,
      powerCable: json['Power Cable'] as String?,
      powerSupplies: json['Power Supplies'] as String?,
      ledModules: json['LED Modules'] as String?,
      coolingSystems: json['Cooling Systems'] as String?,
      serviceLightsSockets: json['Service Lights & Sockets'] as String?,
      operatingComputers: json['Operating Computers'] as String?,
      software: json['Software'] as String?,
      powerDBs: json['Power DBs'] as String?,
      mediaConverters: json['Media Converters'] as String?,
      controlSystems: json['Control Systems'] as String?,
      videoProcessors: json['Video Processors'] as String?,
    );

Map<String, dynamic> _$CheckListToJson(CheckList instance) => <String, dynamic>{
      'Data Cables (Cat6/RJ45)': instance.dataCables,
      'Power Cable': instance.powerCable,
      'Power Supplies': instance.powerSupplies,
      'LED Modules': instance.ledModules,
      'Cooling Systems': instance.coolingSystems,
      'Service Lights & Sockets': instance.serviceLightsSockets,
      'Operating Computers': instance.operatingComputers,
      'Software': instance.software,
      'Power DBs': instance.powerDBs,
      'Media Converters': instance.mediaConverters,
      'Control Systems': instance.controlSystems,
      'Video Processors': instance.videoProcessors,
    };
