import 'package:json_annotation/json_annotation.dart';

part 'create_ticket_request.g.dart';

@JsonSerializable()
class CreateTicketRequest {
  String? title;
  String? description;
  int? screenId;
  String? status;
  int? companyId;

  CreateTicketRequest({
    this.title,
    this.description,
    this.screenId,
    this.status,
    this.companyId,
  });

  factory CreateTicketRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTicketRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateTicketRequestToJson(this);
}
