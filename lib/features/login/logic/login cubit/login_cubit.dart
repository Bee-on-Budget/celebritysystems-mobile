import 'package:celebritysystems_mobile/core/networking/api_result.dart'
    as result;
import 'package:celebritysystems_mobile/features/login/data/models/login_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:celebritysystems_mobile/core/helpers/constants.dart';
import 'package:celebritysystems_mobile/core/helpers/shared_pref_helper.dart';
import 'package:celebritysystems_mobile/core/networking/dio_factory.dart';
import 'package:celebritysystems_mobile/features/login/data/models/login_request_body.dart';
import 'package:celebritysystems_mobile/features/login/data/repos/login_repo.dart';
import 'package:celebritysystems_mobile/features/login/logic/login%20cubit/login_state.dart';
import 'package:flutter/material.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo _loginRepo;
  LoginCubit(this._loginRepo) : super(LoginState.initial());

  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void emitLoginStates() async {
    emit(LoginState.loading());

    print("******************************************");
    print(emailController);
    print("******************************************");

    final result.ApiResult<LoginResponse> response = await _loginRepo.login(
      LoginRequestBody(
        email: emailController.text,
        password: passwordController.text,
      ),
    );

    print("******************************************");
    print("response is ");
    print(response);
    print(response.toString());
    print("******************************************");

    switch (response) {
      case result.Success(:final data):
        print(
            "WE HAVE SUCCESS RESPONSEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
        await saveUserToken(data.token ?? "");
        print("SharedPrefKeys.userToken is :::::::::::: " +
            SharedPrefKeys.userToken);

        emit(LoginState.success(data));

      case result.Failure(:final errorHandler):
        emit(LoginState.error(
          error: errorHandler.apiErrorModel.message ?? 'failure happened',
        ));
    }
  }

  Future<void> saveUserToken(String token) async {
    await SharedPrefHelper.setSecuredString(SharedPrefKeys.userToken, token);
    DioFactory.setTokenIntoHeaderAfterLogin(
        token); //to refresh token after creating Dio instance
  }
}
