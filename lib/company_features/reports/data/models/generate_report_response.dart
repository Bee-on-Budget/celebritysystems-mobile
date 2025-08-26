import 'package:json_annotation/json_annotation.dart';

part 'generate_report_response.g.dart';

@JsonSerializable()
class GenerateReportResponse {
  @JsonKey(name: 'reportType')
  final String reportType;

  @JsonKey(name: 'startDate')
  final String startDate;

  @JsonKey(name: 'endDate')
  final String endDate;

  @JsonKey(name: 'screenIds')
  final List<int> screenIds;

  @JsonKey(name: 'totalCounts')
  final TotalCounts totalCounts;

  GenerateReportResponse({
    required this.reportType,
    required this.startDate,
    required this.endDate,
    required this.screenIds,
    required this.totalCounts,
  });

  factory GenerateReportResponse.fromJson(Map<String, dynamic> json) =>
      _$GenerateReportResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GenerateReportResponseToJson(this);
}

@JsonSerializable()
class TotalCounts {
  @JsonKey(name: 'componentTotals')
  final Map<String, int> componentTotals;

  @JsonKey(name: 'overallTotal')
  final int overallTotal;

  TotalCounts({
    required this.componentTotals,
    required this.overallTotal,
  });

  factory TotalCounts.fromJson(Map<String, dynamic> json) =>
      _$TotalCountsFromJson(json);

  Map<String, dynamic> toJson() => _$TotalCountsToJson(this);
}
