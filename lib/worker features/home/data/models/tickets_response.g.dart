// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tickets_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketsResponse _$TicketsResponseFromJson(Map<String, dynamic> json) =>
    TicketsResponse(
      tickets: (json['tickets'] as List<dynamic>?)
          ?.map((e) => OneTicketResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TicketsResponseToJson(TicketsResponse instance) =>
    <String, dynamic>{
      'tickets': instance.tickets,
    };

OneTicketResponse _$OneTicketResponseFromJson(Map<String, dynamic> json) =>
    OneTicketResponse(
      title: json['title'] as String?,
      description: json['description'] as String?,
      assignedBySupervisorName: json['assignedBySupervisorName'] as String?,
      assignedToWorkerName: json['assignedToWorkerName'] as String?,
      companyName: json['companyName'] as String?,
      createdAt: json['createdAt'] as String?,
      screenName: json['screenName'] as String?,
      status: json['status'] as String?,
      location: json['location'] as String?,
      screenType: json['screenType'] as String?,
    );

Map<String, dynamic> _$OneTicketResponseToJson(OneTicketResponse instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'assignedToWorkerName': instance.assignedToWorkerName,
      'assignedBySupervisorName': instance.assignedBySupervisorName,
      'screenName': instance.screenName,
      'companyName': instance.companyName,
      'status': instance.status,
      'createdAt': instance.createdAt,
      'location': instance.location,
      'screenType': instance.screenType,
    };
