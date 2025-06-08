import 'package:bloc/bloc.dart';
import 'package:celebritysystems_mobile/features/login/logic/login%20cubit/login_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState.initial());
}
