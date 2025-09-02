import 'package:json_annotation/json_annotation.dart';

part 'analytics_response.g.dart';

@JsonSerializable(explicitToJson: true)
class AnalyticsResponse {
  final String averageResolutionTime;
  final String averageResolutionTimeFormatted;
  final Map<String, int> serviceTypeCounts;
  final Map<String, String> averageTimeByServiceType;
  final int totalTickets;

  AnalyticsResponse({
    required this.averageResolutionTime,
    required this.averageResolutionTimeFormatted,
    required this.serviceTypeCounts,
    required this.averageTimeByServiceType,
    required this.totalTickets,
  });

  factory AnalyticsResponse.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AnalyticsResponseToJson(this);
}
