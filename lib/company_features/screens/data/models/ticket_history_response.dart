import 'package:json_annotation/json_annotation.dart';

part 'ticket_history_response.g.dart';

@JsonSerializable(explicitToJson: true)
class TicketHistoryResponse {
  final int id;
  final String title;
  final String description;
  final String? createdBy;
  final String? assignedToWorkerName;
  final String? assignedBySupervisorName;

  // Additional fields from API response
  final String? screenName;
  final String? companyName;
  final String? attachmentFileName;
  final String? screenType;
  final String? location;
  final String? ticketImageName;

  final String status;
  final WorkerReport? workerReport;

  // Use custom converters for DateTime fields
  @JsonKey(
      name: 'createdAt', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime openedAt;

  @JsonKey(fromJson: _dateTimeFromJsonNullable, toJson: _dateTimeToJsonNullable)
  final DateTime? inProgressAt;

  @JsonKey(fromJson: _dateTimeFromJsonNullable, toJson: _dateTimeToJsonNullable)
  final DateTime? resolvedAt;

  @JsonKey(fromJson: _dateTimeFromJsonNullable, toJson: _dateTimeToJsonNullable)
  final DateTime? closedAt;

  // Make ticketImageUrl nullable since API can return null
  final String? ticketImageUrl;
  final String? serviceType;
  final String? serviceTypeDisplayName;

  TicketHistoryResponse({
    required this.id,
    required this.title,
    required this.description,
    this.createdBy,
    this.assignedToWorkerName,
    this.assignedBySupervisorName,
    this.screenName,
    this.companyName,
    this.attachmentFileName,
    this.screenType,
    this.location,
    this.ticketImageName,
    required this.status,
    this.workerReport,
    required this.createdAt,
    required this.openedAt,
    this.inProgressAt,
    this.resolvedAt,
    this.closedAt,
    this.ticketImageUrl,
    this.serviceType,
    this.serviceTypeDisplayName,
  });

  // Custom DateTime converters
  static DateTime _dateTimeFromJson(dynamic json) {
    if (json is String) {
      return DateTime.parse(json);
    }
    return json as DateTime;
  }

  static String _dateTimeToJson(DateTime dateTime) {
    return dateTime.toIso8601String();
  }

  static DateTime? _dateTimeFromJsonNullable(dynamic json) {
    if (json == null) return null;
    if (json is String) {
      return DateTime.parse(json);
    }
    return json as DateTime;
  }

  static String? _dateTimeToJsonNullable(DateTime? dateTime) {
    return dateTime?.toIso8601String();
  }

  factory TicketHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$TicketHistoryResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TicketHistoryResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class WorkerReport {
  final int id;
  final int ticketId;

  @JsonKey(
      fromJson: TicketHistoryResponse._dateTimeFromJson,
      toJson: TicketHistoryResponse._dateTimeToJson)
  final DateTime reportDate;

  final String? serviceType; // Make nullable as API shows null
  final Map<String, String> checklist;

  @JsonKey(
      fromJson: TicketHistoryResponse._dateTimeFromJson,
      toJson: TicketHistoryResponse._dateTimeToJson)
  final DateTime dateTime;

  final String defectsFound;
  final String solutionsProvided;

  // Additional fields from API response
  final String? serviceSupervisorSignatures;
  final String? technicianSignatures;
  final String? authorizedPersonSignatures;

  final String solutionImage;

  @JsonKey(
      fromJson: TicketHistoryResponse._dateTimeFromJson,
      toJson: TicketHistoryResponse._dateTimeToJson)
  final DateTime createdAt;

  @JsonKey(
      fromJson: TicketHistoryResponse._dateTimeFromJson,
      toJson: TicketHistoryResponse._dateTimeToJson)
  final DateTime updatedAt;

  WorkerReport({
    required this.id,
    required this.ticketId,
    required this.reportDate,
    this.serviceType,
    required this.checklist,
    required this.dateTime,
    required this.defectsFound,
    required this.solutionsProvided,
    this.serviceSupervisorSignatures,
    this.technicianSignatures,
    this.authorizedPersonSignatures,
    required this.solutionImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WorkerReport.fromJson(Map<String, dynamic> json) =>
      _$WorkerReportFromJson(json);
  Map<String, dynamic> toJson() => _$WorkerReportToJson(this);
}

// import 'package:json_annotation/json_annotation.dart';

// part 'ticket_history_response.g.dart';

// @JsonSerializable(explicitToJson: true)
// class TicketHistoryResponse {
//   final int id;
//   final String title;
//   final String description;
//   final String? createdBy;
//   final String? assignedToWorkerName;
//   final String? assignedBySupervisorName;
//   final String status;
//   final WorkerReport? workerReport;
//   final DateTime openedAt;
//   final DateTime? inProgressAt;
//   final DateTime? resolvedAt;
//   final DateTime? closedAt;
//   final String ticketImageUrl;
//   final String? serviceType;
//   final String? serviceTypeDisplayName;

//   TicketHistoryResponse({
//     required this.id,
//     required this.title,
//     required this.description,
//     this.createdBy,
//     this.assignedToWorkerName,
//     this.assignedBySupervisorName,
//     required this.status,
//     this.workerReport,
//     required this.openedAt,
//     this.inProgressAt,
//     this.resolvedAt,
//     this.closedAt,
//     required this.ticketImageUrl,
//     this.serviceType,
//     this.serviceTypeDisplayName,
//   });

//   factory TicketHistoryResponse.fromJson(Map<String, dynamic> json) =>
//       _$TicketHistoryResponseFromJson(json);
//   Map<String, dynamic> toJson() => _$TicketHistoryResponseToJson(this);
// }

// @JsonSerializable(explicitToJson: true)
// class WorkerReport {
//   final int id;
//   final int ticketId;
//   final DateTime reportDate;
//   final Map<String, String> checklist;
//   final DateTime dateTime;
//   final String defectsFound;
//   final String solutionsProvided;
//   final String solutionImage;

//   WorkerReport({
//     required this.id,
//     required this.ticketId,
//     required this.reportDate,
//     required this.checklist,
//     required this.dateTime,
//     required this.defectsFound,
//     required this.solutionsProvided,
//     required this.solutionImage,
//   });

//   factory WorkerReport.fromJson(Map<String, dynamic> json) =>
//       _$WorkerReportFromJson(json);
//   Map<String, dynamic> toJson() => _$WorkerReportToJson(this);
// }
