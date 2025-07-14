import 'package:celebritysystems_mobile/celebrity_app.dart';
import 'package:celebritysystems_mobile/core/di/dependency_injection.dart';
import 'package:celebritysystems_mobile/core/helpers/extenstions.dart';
import 'package:celebritysystems_mobile/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/helpers/constants.dart';
import 'core/helpers/shared_pref_helper.dart';
import 'features/login/logic/user cubit/user_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final token =
      await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
  final userCubit = UserCubit();
  if (!token.toString().isNullOrEmpty()) {
    await userCubit.loadUserFromToken(token!);
  }
  setupGetit();
  //To fix texts being hidden bug in flutter_screenUtils in release mode.
  await ScreenUtil.ensureScreenSize();
  // await checkIfLoggedInUser();
  runApp(
    BlocProvider(
      create: (_) => userCubit,
      child: CelebrityApp(appRouter: AppRouter()),
    ),
  );
}

checkIfLoggedInUser() async {
  String? userToken =
      await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
  if (userToken!.isNullOrEmpty()) {
    isLoggedInUser = true;
  } else {
    isLoggedInUser = false;
  }
}
