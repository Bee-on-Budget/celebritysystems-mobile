import 'package:json_annotation/json_annotation.dart';

part 'report_request.g.dart';

@JsonSerializable()
class ReportWrapper {
  ReportRequest? report;

  ReportWrapper({this.report});

  factory ReportWrapper.fromJson(Map<String, dynamic> json) =>
      _$ReportWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$ReportWrapperToJson(this);
}

@JsonSerializable()
class ReportRequest {
  String? date;

  @JsonKey(name: 'service_type')
  String? serviceType;

  @JsonKey(name: 'date_time')
  DateTime? dateTime;

  CheckList? checklist;

  @JsonKey(name: 'defects_found')
  String? defectsFound;

  @JsonKey(name: 'solutions_provided')
  String? solutionsProvided;

  @JsonKey(name: 'service_supervisor_signatures')
  String? serviceSupervisorSignatures;

  @JsonKey(name: 'technician_signatures')
  String? technicianSignatures;

  @JsonKey(name: 'authorized_person_Signatures')
  String? authorizedPersonSignatures;

  @JsonKey(name: 'solution_image')
  String? solutionImage;

  ReportRequest({
    this.date,
    this.serviceType,
    this.dateTime,
    this.checklist,
    this.defectsFound,
    this.solutionsProvided,
    this.serviceSupervisorSignatures,
    this.technicianSignatures,
    this.authorizedPersonSignatures,
    this.solutionImage,
  });

  factory ReportRequest.fromJson(Map<String, dynamic> json) =>
      _$ReportRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ReportRequestToJson(this);
}

@JsonSerializable()
class CheckList {
  @JsonKey(name: "Data Cables (Cat6/RJ45)")
  String? dataCables;

  @JsonKey(name: "Power Cable")
  String? powerCable;

  @JsonKey(name: "Power Supplies")
  String? powerSupplies;

  @JsonKey(name: "LED Modules")
  String? ledModules;

  @JsonKey(name: "Cooling Systems")
  String? coolingSystems;

  @JsonKey(name: "Service Lights & Sockets")
  String? serviceLightsSockets;

  @JsonKey(name: "Operating Computers")
  String? operatingComputers;

  @JsonKey(name: "Software")
  String? software;

  @JsonKey(name: "Power DBs")
  String? powerDBs;

  @JsonKey(name: "Media Converters")
  String? mediaConverters;

  @JsonKey(name: "Control Systems")
  String? controlSystems;

  @JsonKey(name: "Video Processors")
  String? videoProcessors;

  CheckList({
    this.dataCables,
    this.powerCable,
    this.powerSupplies,
    this.ledModules,
    this.coolingSystems,
    this.serviceLightsSockets,
    this.operatingComputers,
    this.software,
    this.powerDBs,
    this.mediaConverters,
    this.controlSystems,
    this.videoProcessors,
  });

  factory CheckList.fromJson(Map<String, dynamic> json) =>
      _$CheckListFromJson(json);

  Map<String, dynamic> toJson() => _$CheckListToJson(this);
}
