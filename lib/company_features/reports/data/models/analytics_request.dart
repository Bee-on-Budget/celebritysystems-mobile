import 'package:json_annotation/json_annotation.dart';

part 'analytics_request.g.dart';

@JsonSerializable()
class AnalyticsRequest {
  @JsonKey(name: 'screenIds')
  final List<int> screenIds;

  @JsonKey(name: 'startDate')
  final String startDate;

  @JsonKey(name: 'endDate')
  final String endDate;

  // @JsonKey(name: 'reportType')
  // final String reportType;

  AnalyticsRequest({
    required this.screenIds,
    required this.startDate,
    required this.endDate,
    // required this.reportType,
  });

  factory AnalyticsRequest.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AnalyticsRequestToJson(this);
}
