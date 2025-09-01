import 'package:freezed_annotation/freezed_annotation.dart';

part 'screen_state.freezed.dart';

@freezed
class ScreenState<T> with _$ScreenState<T> {
  const factory ScreenState.initial() = _Initial;
  const factory ScreenState.loading() = Loading;
  const factory ScreenState.success(T data) = Success<T>;
  const factory ScreenState.error({required String error}) = Error;
}
