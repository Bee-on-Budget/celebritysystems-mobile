import 'package:json_annotation/json_annotation.dart';

part 'report_request.g.dart';

@JsonSerializable()
class ReportRequest {
  final DateTime dateTime;
  final String serviceType;
  final CheckList checkList;
  final String defectsFound;
  final String solutionsProvider;

  ReportRequest({
    required this.dateTime,
    required this.serviceType,
    required this.checkList,
    required this.defectsFound,
    required this.solutionsProvider,
  });

  factory ReportRequest.fromJson(Map<String, dynamic> json) =>
      _$ReportRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ReportRequestToJson(this);
}

@JsonSerializable()
class CheckList {
  final String dataCables;

  final String powerCable;

  final String powerSupplies;

  final String ledModules;

  final String coolingSystems;

  final String serviceLightsSockets;

  final String operatingComputers;

  final String software;

  final String powerDBs;

  final String mediaConverters;

  final String controlSystems;

  final String videoProcessors;

  CheckList({
    required this.dataCables,
    required this.powerCable,
    required this.powerSupplies,
    required this.ledModules,
    required this.coolingSystems,
    required this.serviceLightsSockets,
    required this.operatingComputers,
    required this.software,
    required this.powerDBs,
    required this.mediaConverters,
    required this.controlSystems,
    required this.videoProcessors,
  });

  factory CheckList.fromJson(Map<String, dynamic> json) =>
      _$CheckListFromJson(json);

  Map<String, dynamic> toJson() => _$CheckListToJson(this);
}
