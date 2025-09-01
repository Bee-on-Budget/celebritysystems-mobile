// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_history_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketHistoryResponse _$TicketHistoryResponseFromJson(
        Map<String, dynamic> json) =>
    TicketHistoryResponse(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      createdBy: json['createdBy'] as String?,
      assignedToWorkerName: json['assignedToWorkerName'] as String?,
      assignedBySupervisorName: json['assignedBySupervisorName'] as String?,
      screenName: json['screenName'] as String?,
      companyName: json['companyName'] as String?,
      attachmentFileName: json['attachmentFileName'] as String?,
      screenType: json['screenType'] as String?,
      location: json['location'] as String?,
      ticketImageName: json['ticketImageName'] as String?,
      status: json['status'] as String,
      workerReport: json['workerReport'] == null
          ? null
          : WorkerReport.fromJson(json['workerReport'] as Map<String, dynamic>),
      createdAt: TicketHistoryResponse._dateTimeFromJson(json['createdAt']),
      openedAt: TicketHistoryResponse._dateTimeFromJson(json['openedAt']),
      inProgressAt:
          TicketHistoryResponse._dateTimeFromJsonNullable(json['inProgressAt']),
      resolvedAt:
          TicketHistoryResponse._dateTimeFromJsonNullable(json['resolvedAt']),
      closedAt:
          TicketHistoryResponse._dateTimeFromJsonNullable(json['closedAt']),
      ticketImageUrl: json['ticketImageUrl'] as String?,
      serviceType: json['serviceType'] as String?,
      serviceTypeDisplayName: json['serviceTypeDisplayName'] as String?,
    );

Map<String, dynamic> _$TicketHistoryResponseToJson(
        TicketHistoryResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'createdBy': instance.createdBy,
      'assignedToWorkerName': instance.assignedToWorkerName,
      'assignedBySupervisorName': instance.assignedBySupervisorName,
      'screenName': instance.screenName,
      'companyName': instance.companyName,
      'attachmentFileName': instance.attachmentFileName,
      'screenType': instance.screenType,
      'location': instance.location,
      'ticketImageName': instance.ticketImageName,
      'status': instance.status,
      'workerReport': instance.workerReport?.toJson(),
      'createdAt': TicketHistoryResponse._dateTimeToJson(instance.createdAt),
      'openedAt': TicketHistoryResponse._dateTimeToJson(instance.openedAt),
      'inProgressAt':
          TicketHistoryResponse._dateTimeToJsonNullable(instance.inProgressAt),
      'resolvedAt':
          TicketHistoryResponse._dateTimeToJsonNullable(instance.resolvedAt),
      'closedAt':
          TicketHistoryResponse._dateTimeToJsonNullable(instance.closedAt),
      'ticketImageUrl': instance.ticketImageUrl,
      'serviceType': instance.serviceType,
      'serviceTypeDisplayName': instance.serviceTypeDisplayName,
    };

WorkerReport _$WorkerReportFromJson(Map<String, dynamic> json) => WorkerReport(
      id: (json['id'] as num).toInt(),
      ticketId: (json['ticketId'] as num).toInt(),
      reportDate: TicketHistoryResponse._dateTimeFromJson(json['reportDate']),
      serviceType: json['serviceType'] as String?,
      checklist: Map<String, String>.from(json['checklist'] as Map),
      dateTime: TicketHistoryResponse._dateTimeFromJson(json['dateTime']),
      defectsFound: json['defectsFound'] as String,
      solutionsProvided: json['solutionsProvided'] as String,
      serviceSupervisorSignatures:
          json['serviceSupervisorSignatures'] as String?,
      technicianSignatures: json['technicianSignatures'] as String?,
      authorizedPersonSignatures: json['authorizedPersonSignatures'] as String?,
      solutionImage: json['solutionImage'] as String,
      createdAt: TicketHistoryResponse._dateTimeFromJson(json['createdAt']),
      updatedAt: TicketHistoryResponse._dateTimeFromJson(json['updatedAt']),
    );

Map<String, dynamic> _$WorkerReportToJson(WorkerReport instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ticketId': instance.ticketId,
      'reportDate': TicketHistoryResponse._dateTimeToJson(instance.reportDate),
      'serviceType': instance.serviceType,
      'checklist': instance.checklist,
      'dateTime': TicketHistoryResponse._dateTimeToJson(instance.dateTime),
      'defectsFound': instance.defectsFound,
      'solutionsProvided': instance.solutionsProvided,
      'serviceSupervisorSignatures': instance.serviceSupervisorSignatures,
      'technicianSignatures': instance.technicianSignatures,
      'authorizedPersonSignatures': instance.authorizedPersonSignatures,
      'solutionImage': instance.solutionImage,
      'createdAt': TicketHistoryResponse._dateTimeToJson(instance.createdAt),
      'updatedAt': TicketHistoryResponse._dateTimeToJson(instance.updatedAt),
    };
