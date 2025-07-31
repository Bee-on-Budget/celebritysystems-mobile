import 'package:json_annotation/json_annotation.dart';

part 'company_tickets_response.g.dart';

@JsonSerializable()
class CompanyTicketResponse {
  int? id;
  String? title;
  String? description;
  int? assignedToWorkerId;
  String? assignedToWorkerName;
  int? assignedBySupervisorId;
  String? assignedBySupervisorName;
  int? screenId;
  String? screenName;
  int? companyId;
  String? companyName;
  String? status;
  String? createdAt;
  String? location;
  String? screenType;

  CompanyTicketResponse({
    this.id,
    this.title,
    this.description,
    this.assignedToWorkerId,
    this.assignedToWorkerName,
    this.assignedBySupervisorId,
    this.assignedBySupervisorName,
    this.screenId,
    this.screenName,
    this.companyName,
    this.companyId,
    this.status,
    this.createdAt,
    this.location,
    this.screenType,
  });

  factory CompanyTicketResponse.fromJson(Map<String, dynamic> json) =>
      _$CompanyTicketResponseFromJson(json);
}
