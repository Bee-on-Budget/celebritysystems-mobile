import 'package:json_annotation/json_annotation.dart';

part 'company_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CompanyModel {
  final String name;
  final String phone;
  final String email;
  final String location;
  final bool activated;
  final List<User> userList;

  CompanyModel({
    required this.name,
    required this.phone,
    required this.email,
    required this.location,
    required this.activated,
    required this.userList,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyModelToJson(this);
}

@JsonSerializable()
class User {
  final int id;
  final String email;
  final String username;
  final String fullName;
  final bool canRead;
  final bool canEdit;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.fullName,
    required this.canRead,
    required this.canEdit,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
