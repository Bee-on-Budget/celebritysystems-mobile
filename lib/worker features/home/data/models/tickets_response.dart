import 'package:json_annotation/json_annotation.dart';

part 'tickets_response.g.dart';

@JsonSerializable()
class TicketsResponse {
  List<OneTicketResponse>? tickets;

  TicketsResponse({this.tickets});

  factory TicketsResponse.fromJson(Map<String, dynamic> json) =>
      _$TicketsResponseFromJson(json);
}

@JsonSerializable()
class OneTicketResponse {
  String? title;
  String? description;
  String? assignedToWorkerName;
  String? assignedBySupervisorName;
  String? screenName;
  String? companyName;
  String? status;
  String? createdAt;

  OneTicketResponse(
      {this.title,
      this.description,
      this.assignedBySupervisorName,
      this.assignedToWorkerName,
      this.companyName,
      this.createdAt,
      this.screenName,
      this.status});

  factory OneTicketResponse.fromJson(Map<String, dynamic> json) =>
      _$OneTicketResponseFromJson(json);
}
