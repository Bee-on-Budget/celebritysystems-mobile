// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_screen_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyScreenModel _$CompanyScreenModelFromJson(Map<String, dynamic> json) =>
    CompanyScreenModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      screenType: json['screenType'] as String?,
      location: json['location'] as String?,
      solutionType: json['solutionType'] as String?,
    );

Map<String, dynamic> _$CompanyScreenModelToJson(CompanyScreenModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'screenType': instance.screenType,
      'location': instance.location,
      'solutionType': instance.solutionType,
    };
