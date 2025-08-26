import 'package:json_annotation/json_annotation.dart';

part 'generate_report_request.g.dart';

@JsonSerializable()
class GenerateReportRequest {
  @JsonKey(name: 'screenIds')
  final List<int> screenIds;

  @JsonKey(name: 'startDate')
  final String startDate;

  @JsonKey(name: 'endDate')
  final String endDate;

  @JsonKey(name: 'reportType')
  final String reportType;

  GenerateReportRequest({
    required this.screenIds,
    required this.startDate,
    required this.endDate,
    required this.reportType,
  });

  factory GenerateReportRequest.fromJson(Map<String, dynamic> json) =>
      _$GenerateReportRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GenerateReportRequestToJson(this);
}
