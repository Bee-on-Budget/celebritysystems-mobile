// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_ticket_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateTicketRequest _$CreateTicketRequestFromJson(Map<String, dynamic> json) =>
    CreateTicketRequest(
      title: json['title'] as String?,
      description: json['description'] as String?,
      screenId: (json['screenId'] as num?)?.toInt(),
      status: json['status'] as String?,
      companyId: (json['companyId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CreateTicketRequestToJson(
        CreateTicketRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'screenId': instance.screenId,
      'status': instance.status,
      'companyId': instance.companyId,
    };
