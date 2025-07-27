// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportRequest _$ReportRequestFromJson(Map<String, dynamic> json) =>
    ReportRequest(
      dateTime: DateTime.parse(json['dateTime'] as String),
      serviceType: json['serviceType'] as String,
      checkList: CheckList.fromJson(json['checkList'] as Map<String, dynamic>),
      defectsFound: json['defectsFound'] as String,
      solutionsProvider: json['solutionsProvider'] as String,
    );

Map<String, dynamic> _$ReportRequestToJson(ReportRequest instance) =>
    <String, dynamic>{
      'dateTime': instance.dateTime.toIso8601String(),
      'serviceType': instance.serviceType,
      'checkList': instance.checkList,
      'defectsFound': instance.defectsFound,
      'solutionsProvider': instance.solutionsProvider,
    };

CheckList _$CheckListFromJson(Map<String, dynamic> json) => CheckList(
      dataCables: json['dataCables'] as String,
      powerCable: json['powerCable'] as String,
      powerSupplies: json['powerSupplies'] as String,
      ledModules: json['ledModules'] as String,
      coolingSystems: json['coolingSystems'] as String,
      serviceLightsSockets: json['serviceLightsSockets'] as String,
      operatingComputers: json['operatingComputers'] as String,
      software: json['software'] as String,
      powerDBs: json['powerDBs'] as String,
      mediaConverters: json['mediaConverters'] as String,
      controlSystems: json['controlSystems'] as String,
      videoProcessors: json['videoProcessors'] as String,
    );

Map<String, dynamic> _$CheckListToJson(CheckList instance) => <String, dynamic>{
      'dataCables': instance.dataCables,
      'powerCable': instance.powerCable,
      'powerSupplies': instance.powerSupplies,
      'ledModules': instance.ledModules,
      'coolingSystems': instance.coolingSystems,
      'serviceLightsSockets': instance.serviceLightsSockets,
      'operatingComputers': instance.operatingComputers,
      'software': instance.software,
      'powerDBs': instance.powerDBs,
      'mediaConverters': instance.mediaConverters,
      'controlSystems': instance.controlSystems,
      'videoProcessors': instance.videoProcessors,
    };
