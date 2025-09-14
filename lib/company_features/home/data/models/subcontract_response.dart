import 'package:celebritysystems_mobile/company_features/home/data/models/company.dart';
import 'package:celebritysystems_mobile/company_features/show_contract/data/model/contract_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subcontract_response.g.dart';

@JsonSerializable()
class SubcontractResponse {
  int id;
  Company mainCompany;
  Company controllerCompany;
  Contract contract;
  String createdAt;
  String expiredAt;

  SubcontractResponse({
    required this.id,
    required this.mainCompany,
    required this.controllerCompany,
    required this.contract,
    required this.createdAt,
    required this.expiredAt,
  });

  factory SubcontractResponse.fromJson(Map<String, dynamic> json) =>
      _$SubcontractResponseFromJson(json);
}
