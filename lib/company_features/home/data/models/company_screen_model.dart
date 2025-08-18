import 'package:json_annotation/json_annotation.dart';

part 'company_screen_model.g.dart';

@JsonSerializable()
class CompanyScreenModel {
  int? id;
  String? name;
  String? screenType;
  String? location;
  String? solutionType;

  CompanyScreenModel(
      {this.id, this.name, this.screenType, this.location, this.solutionType});

  factory CompanyScreenModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyScreenModelFromJson(json);
}
