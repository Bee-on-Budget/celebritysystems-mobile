import 'package:json_annotation/json_annotation.dart';

part 'tickets_count.g.dart';

@JsonSerializable()
class TicketsCount {
  int? assignedCount;
  int? completedCount;

  TicketsCount({this.assignedCount, this.completedCount});

  factory TicketsCount.fromJson(Map<String, dynamic> json) =>
      _$TicketsCountFromJson(json);
}
