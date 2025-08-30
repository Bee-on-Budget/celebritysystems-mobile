import 'package:json_annotation/json_annotation.dart';

part 'contract_response.g.dart';

@JsonSerializable(explicitToJson: true)
class Contract {
  final int id;
  final String info;
  final DateTime startContractAt;
  final DateTime expiredAt;
  final int companyId;
  final String supplyType;
  final String operatorType;
  final String accountName;
  final String durationType;
  final int contractValue;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<int> screenIds;

  Contract({
    required this.id,
    required this.info,
    required this.startContractAt,
    required this.expiredAt,
    required this.companyId,
    required this.supplyType,
    required this.operatorType,
    required this.accountName,
    required this.durationType,
    required this.contractValue,
    this.createdAt,
    this.updatedAt,
    required this.screenIds,
  });

  factory Contract.fromJson(Map<String, dynamic> json) =>
      _$ContractFromJson(json);

  Map<String, dynamic> toJson() => _$ContractToJson(this);
}
