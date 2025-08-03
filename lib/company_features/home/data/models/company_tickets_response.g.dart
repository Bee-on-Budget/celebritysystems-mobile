// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_tickets_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyTicketResponse _$CompanyTicketResponseFromJson(
        Map<String, dynamic> json) =>
    CompanyTicketResponse(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      assignedToWorkerId: (json['assignedToWorkerId'] as num?)?.toInt(),
      assignedToWorkerName: json['assignedToWorkerName'] as String?,
      assignedBySupervisorId: (json['assignedBySupervisorId'] as num?)?.toInt(),
      assignedBySupervisorName: json['assignedBySupervisorName'] as String?,
      screenId: (json['screenId'] as num?)?.toInt(),
      screenName: json['screenName'] as String?,
      companyName: json['companyName'] as String?,
      companyId: (json['companyId'] as num?)?.toInt(),
      status: json['status'] as String?,
      createdAt: json['createdAt'] as String?,
      location: json['location'] as String?,
      screenType: json['screenType'] as String?,
    );

Map<String, dynamic> _$CompanyTicketResponseToJson(
        CompanyTicketResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'assignedToWorkerId': instance.assignedToWorkerId,
      'assignedToWorkerName': instance.assignedToWorkerName,
      'assignedBySupervisorId': instance.assignedBySupervisorId,
      'assignedBySupervisorName': instance.assignedBySupervisorName,
      'screenId': instance.screenId,
      'screenName': instance.screenName,
      'companyId': instance.companyId,
      'companyName': instance.companyName,
      'status': instance.status,
      'createdAt': instance.createdAt,
      'location': instance.location,
      'screenType': instance.screenType,
    };
