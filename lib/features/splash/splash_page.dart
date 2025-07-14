import 'package:celebritysystems_mobile/core/helpers/constants.dart';
import 'package:celebritysystems_mobile/core/helpers/extenstions.dart';
import 'package:celebritysystems_mobile/core/helpers/shared_pref_helper.dart';
import 'package:celebritysystems_mobile/core/helpers/token_service.dart';
import 'package:celebritysystems_mobile/core/routing/routes.dart';
import 'package:celebritysystems_mobile/features/home/ui/home_screen.dart';
import 'package:celebritysystems_mobile/features/login/ui/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () async {
      final token =
          await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);

      print('token $token');

      final tokenService = TokenService(token);
      if (token == null || token.toString().isEmpty) {
        context.pushReplacementNamed(Routes.loginScreen);
      } else if (tokenService.isExpired) {
        print('tokenService ${tokenService.claims}');
        print("isExpired: ${tokenService.isExpired}");
        context.pushReplacementNamed(Routes.loginScreen);
      } else {
        if (tokenService.role == Constants.CELEBRITY_SYSTEM_WORKER) {
          context.pushReplacementNamed(Routes.homeScreen);
        } else if (tokenService.role == Constants.COMPANY) {
          context.pushReplacementNamed(Routes.homeScreen);
        } else {
          print("there is no implementation for this Role");
          context.pushReplacementNamed(Routes.loginScreen);
        }
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          height: 1200.h,
          width: 1200.h,
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
    );
  }
}
