import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_state.freezed.dart';

@freezed
class ReportState<T> with _$ReportState<T> {
  const factory ReportState.initial() = _Initial;
  const factory ReportState.loading() = Loading;
  const factory ReportState.success() = Success;
  const factory ReportState.error({required String error}) = Error;
}
