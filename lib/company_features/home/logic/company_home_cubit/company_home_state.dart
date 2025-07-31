import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_home_state.freezed.dart';

@freezed
class CompanyHomeState<T> with _$CompanyHomeState<T> {
  const factory CompanyHomeState.initial() = _Initial;
  const factory CompanyHomeState.loading() = Loading;
  const factory CompanyHomeState.success(T data) = Success<T>;
  const factory CompanyHomeState.error({required String error}) = Error;
}
