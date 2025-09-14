// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subcontract_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubcontractResponse _$SubcontractResponseFromJson(Map<String, dynamic> json) =>
    SubcontractResponse(
      id: (json['id'] as num).toInt(),
      mainCompany:
          Company.fromJson(json['mainCompany'] as Map<String, dynamic>),
      controllerCompany:
          Company.fromJson(json['controllerCompany'] as Map<String, dynamic>),
      contract: Contract.fromJson(json['contract'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String,
      expiredAt: json['expiredAt'] as String,
    );

Map<String, dynamic> _$SubcontractResponseToJson(
        SubcontractResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mainCompany': instance.mainCompany,
      'controllerCompany': instance.controllerCompany,
      'contract': instance.contract,
      'createdAt': instance.createdAt,
      'expiredAt': instance.expiredAt,
    };
