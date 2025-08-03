// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyUser _$CompanyUserFromJson(Map<String, dynamic> json) => CompanyUser(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String,
      username: json['username'] as String,
      fullName: json['fullName'] as String,
      canEdit: json['canEdit'] as bool,
      canRead: json['canRead'] as bool,
    );

Map<String, dynamic> _$CompanyUserToJson(CompanyUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'fullName': instance.fullName,
      'canEdit': instance.canEdit,
      'canRead': instance.canRead,
    };
