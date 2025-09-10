import 'package:celebritysystems_mobile/core/di/dependency_injection.dart';
import 'package:celebritysystems_mobile/core/helpers/constants.dart';
import 'package:celebritysystems_mobile/core/helpers/shared_pref_helper.dart';
import 'package:celebritysystems_mobile/core/helpers/user_model.dart';
import 'package:celebritysystems_mobile/features/login/logic/login%20cubit/login_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';

class UserCubit extends Cubit<UserModel?> {
  // final LoginRepo loginRepo;

  UserCubit() : super(null);

  Future<void> loadUserFromToken(String token) async {
    try {
      final payload = _decodeJWT(token);
      final user = UserModel.fromPayload(payload);
      print("Created user: $user");
      emit(user);
    } catch (e) {
      print("Error in loadUserFromToken: $e");
      emit(null);
    }
  }

  void logout(int userId) async {
    LoginCubit loginCubit = getIt();
    await SharedPrefHelper.clearAllDataExceptOneSignalUserId();
    await SharedPrefHelper.clearAllSecuredData();
    print("userId is: $userId");
    await loginCubit.sendSubscreptionId(" ", userId);
    emit(null);
  }

  Map<String, dynamic> _decodeJWT(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }
    final payload =
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    return json.decode(payload);
  }
}


  // Future<void> loadUserFromToken(String token) async {
  //   try {
  //     final payload = _decodeJWT(token);
  //     final user = UserModel(
  //         username: payload['username'],
  //         role: payload['role'],
  //         companyId: payload['companyId'],
  //         userId: payload['sub']);
  //     emit(user);
  //   } catch (e) {
  //     emit(null);
  //   }
  // }


  // Future<void> loadUserFromToken(String token) async {
  //   try {
  //     print("=== UserCubit Debug ===");
  //     print("Token: $token");

  //     final payload = _decodeJWT(token);
  //     print("Raw payload: $payload");
  //     print(
  //         "Username: ${payload['username']} (${payload['username'].runtimeType})");
  //     print("Role: ${payload['role']} (${payload['role'].runtimeType})");
  //     print(
  //         "CompanyId: ${payload['companyId']} (${payload['companyId'].runtimeType})");
  //     print("Sub (userId): ${payload['sub']} (${payload['sub'].runtimeType})");

  //     final user = UserModel(
  //         username: payload['username'],
  //         role: payload['role'],
  //         companyId: payload['companyId'],
  //         userId: payload['sub'] is String
  //             ? int.tryParse(payload['sub'])
  //             : payload['sub']);

  //     print(
  //         "Created user: username=${user.username}, role=${user.role}, companyId=${user.companyId}, userId=${user.userId}");
  //     print("Is allowed: ${user.isAllowed}");

  //     emit(user);
  //     print("User emitted successfully");
  //   } catch (e) {
  //     print("Error in loadUserFromToken: $e");
  //     print("Stack trace: ${StackTrace.current}");
  //     emit(null);
  //   }
  // }