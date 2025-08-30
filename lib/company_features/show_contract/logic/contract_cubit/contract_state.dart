import 'package:freezed_annotation/freezed_annotation.dart';

part 'contract_state.freezed.dart';

@freezed
class ContractState<T> with _$ContractState<T> {
  const factory ContractState.initial() = _Initial;
  const factory ContractState.loading() = Loading;
  const factory ContractState.success(T data) = Success<T>;
  const factory ContractState.error({required String error}) = Error;
}
