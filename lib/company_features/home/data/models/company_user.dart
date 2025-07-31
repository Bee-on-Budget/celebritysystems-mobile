import 'package:json_annotation/json_annotation.dart';

part 'company_user.g.dart';

@JsonSerializable()
class CompanyUser {
  int id;
  String email;
  String username;
  String fullName;
  bool canEdit;
  bool canRead;

  CompanyUser({
    required this.id,
    required this.email,
    required this.username,
    required this.fullName,
    required this.canEdit,
    required this.canRead,
  });

  factory CompanyUser.fromJson(Map<String, dynamic> json) =>
      _$CompanyUserFromJson(json);
}