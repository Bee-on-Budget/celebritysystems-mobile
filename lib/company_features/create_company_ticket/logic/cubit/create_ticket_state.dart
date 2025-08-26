import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_ticket_state.freezed.dart';

@freezed
class CreateTicketState<T> with _$CreateTicketState<T> {
  const factory CreateTicketState.initial() = _Initial;
  const factory CreateTicketState.loading() = Loading;
  const factory CreateTicketState.success() = Success;
  const factory CreateTicketState.error({required String error}) = Error;
}
