// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contract _$ContractFromJson(Map<String, dynamic> json) => Contract(
      id: (json['id'] as num).toInt(),
      info: json['info'] as String,
      startContractAt: DateTime.parse(json['startContractAt'] as String),
      expiredAt: DateTime.parse(json['expiredAt'] as String),
      companyId: (json['companyId'] as num).toInt(),
      supplyType: json['supplyType'] as String,
      operatorType: json['operatorType'] as String,
      accountName: json['accountName'] as String,
      durationType: json['durationType'] as String,
      contractValue: (json['contractValue'] as num).toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      screenIds: (json['screenIds'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$ContractToJson(Contract instance) => <String, dynamic>{
      'id': instance.id,
      'info': instance.info,
      'startContractAt': instance.startContractAt.toIso8601String(),
      'expiredAt': instance.expiredAt.toIso8601String(),
      'companyId': instance.companyId,
      'supplyType': instance.supplyType,
      'operatorType': instance.operatorType,
      'accountName': instance.accountName,
      'durationType': instance.durationType,
      'contractValue': instance.contractValue,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'screenIds': instance.screenIds,
    };
