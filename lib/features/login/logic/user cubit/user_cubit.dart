import 'package:celebritysystems_mobile/core/helpers/shared_pref_helper.dart';
import 'package:celebritysystems_mobile/core/helpers/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';

class UserCubit extends Cubit<UserModel?> {
  UserCubit() : super(null);

  Future<void> loadUserFromToken(String token) async {
    try {
      final payload = _decodeJWT(token);
      final user = UserModel(
        username: payload['username'],
        role: payload['role'],
        companyId: payload['companyId'],
      );
      emit(user);
    } catch (e) {
      emit(null);
    }
  }

  void logout() async {
    await SharedPrefHelper.clearAllData();
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
