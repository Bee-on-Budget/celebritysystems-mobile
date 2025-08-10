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
  int? id;
  String? title;
  String? description;
  String? assignedToWorkerName;
  String? assignedBySupervisorName;
  String? screenName;
  String? companyName;
  String? status;
  String? createdAt;
  String? location;
  String? screenType;
  String? ticketImageUrl;

  OneTicketResponse(
      {this.id,
      this.title,
      this.description,
      this.assignedBySupervisorName,
      this.assignedToWorkerName,
      this.companyName,
      this.createdAt,
      this.screenName,
      this.status,
      this.location,
      this.screenType,
      this.ticketImageUrl});

  factory OneTicketResponse.fromJson(Map<String, dynamic> json) =>
      _$OneTicketResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OneTicketResponseToJson(this);
}
