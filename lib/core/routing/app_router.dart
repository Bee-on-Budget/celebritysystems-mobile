import 'package:celebritysystems_mobile/core/routing/routes.dart';
import 'package:celebritysystems_mobile/features/home/ui/home_screen.dart';
import 'package:celebritysystems_mobile/features/login/logic/login%20cubit/login_cubit.dart';
import 'package:celebritysystems_mobile/features/login/ui/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../di/dependency_injection.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    //this arugments to be passed in any screen like this { arguments as ClassName }
    final arguments = settings.arguments;

    switch (settings.name) {
      // case Routes.onBoardingScreen:
      //   return MaterialPageRoute(
      //     builder: (_) => const OnboardingScreen(),
      //   );
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<LoginCubit>(),
            child: const LoginScreen(),
          ),
        );
      case Routes.homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen()
            // BlocProvider(
            //   create: (context) => HomeCubit(getIt())..getSpecializations(),
            //   child: const HomeScreen(),
            // ),
            );
      default:
        null;
    }
    return null;
  }
}
