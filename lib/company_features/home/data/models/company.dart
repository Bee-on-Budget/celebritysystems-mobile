import 'package:json_annotation/json_annotation.dart';

part 'company.g.dart';

@JsonSerializable()
class Company {
  int id;
  String name;
  String email;
  bool activated;
  String companyType;

  Company({
    required this.id,
    required this.name,
    required this.email,
    required this.activated,
    required this.companyType,
  });

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);
}
