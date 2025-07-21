import 'package:celebritysystems_mobile/company%20features/home/ui/company_home_screen.dart';
import 'package:celebritysystems_mobile/core/routing/routes.dart';
import 'package:celebritysystems_mobile/worker%20features/home/logic/home%20cubit/home_cubit.dart';
import 'package:celebritysystems_mobile/worker%20features/home/ui/home_screen.dart';
import 'package:celebritysystems_mobile/features/login/logic/login%20cubit/login_cubit.dart';
import 'package:celebritysystems_mobile/features/login/ui/login_screen.dart';
import 'package:celebritysystems_mobile/features/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../di/dependency_injection.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    //this arugments to be passed in any screen like this { arguments as ClassName }
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
        );
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<LoginCubit>(),
            child: const LoginScreen(),
          ),
        );
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => HomeCubit(getIt()),
            child: const HomeScreen(),
          ),
        );
      case Routes.companyHomeScreen:
        return MaterialPageRoute(
          builder: (_) => const CompanyHomeScreen(),
        );
      // case Routes.reportScreen:
      //   return MaterialPageRoute(
      //     builder: (_) => const ServiceReportScreen(ticket: null,),
      //   );
      default:
        null;
    }
    return null;
  }
}
