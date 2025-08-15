import 'package:celebritysystems_mobile/core/routing/routes.dart';
import 'package:celebritysystems_mobile/worker%20features/home/logic/home%20cubit/home_cubit.dart';
import 'package:celebritysystems_mobile/worker%20features/home/ui/home_screen.dart';
import 'package:celebritysystems_mobile/features/login/logic/login%20cubit/login_cubit.dart';
import 'package:celebritysystems_mobile/features/login/ui/login_screen.dart';
import 'package:celebritysystems_mobile/features/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../company_features/home/logic/company_home_cubit/company_home_cubit.dart';
import '../../company_features/home/ui/home_screen/company_home_screen.dart';
import '../../company_features/create_company_ticket/ui/create_company_ticket_screen.dart';
import '../di/dependency_injection.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    // Debug logging to track arguments
    debugPrint("=== APP ROUTER DEBUG ===");
    debugPrint("Route name: ${settings.name}");
    debugPrint("Arguments: ${settings.arguments}");
    debugPrint("Arguments type: ${settings.arguments.runtimeType}");
    debugPrint("=== END APP ROUTER DEBUG ===");

    // This arguments to be passed in any screen like this { arguments as ClassName }
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
          settings: settings, // ✅ Added settings parameter
        );

      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<LoginCubit>(),
            child: const LoginScreen(),
          ),
          settings: settings, // ✅ Added settings parameter
        );

      case Routes.homeScreen:
        debugPrint("Creating HomeScreen route with arguments: $arguments");
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => HomeCubit(getIt()),
            child: const HomeScreen(),
          ),
          settings: settings, // ✅ CRITICAL: This preserves the arguments!
        );

      case Routes.companyHomeScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CompanyHomeCubit(getIt()),
            child: const CompanyHomeScreen(),
          ),
          settings: settings, // ✅ Added settings parameter
        );

      case Routes.createCompanyTicketScreen:
        return MaterialPageRoute(
          builder: (_) => const CreateCompanyTicketScreen(),
          settings: settings, // ✅ Added settings parameter
        );

      // case Routes.reportScreen:
      //   return MaterialPageRoute(
      //     builder: (_) => const ServiceReportScreen(ticket: null,),
      //     settings: settings,
      //   );

      default:
        debugPrint("Route ${settings.name} not found!");
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route ${settings.name} not found'),
            ),
          ),
          settings: settings,
        );
    }
  }
}
