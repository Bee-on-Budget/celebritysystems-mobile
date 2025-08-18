import 'package:celebritysystems_mobile/core/routing/routes.dart';
import 'package:celebritysystems_mobile/worker%20features/home/logic/home%20cubit/home_cubit.dart';
import 'package:celebritysystems_mobile/worker%20features/home/ui/home_screen.dart';
import 'package:celebritysystems_mobile/features/login/logic/login%20cubit/login_cubit.dart';
import 'package:celebritysystems_mobile/features/login/ui/login_screen.dart';
import 'package:celebritysystems_mobile/features/splash/splash_page.dart';
import 'package:celebritysystems_mobile/core/helpers/constants.dart';
import 'package:celebritysystems_mobile/core/helpers/shared_pref_helper.dart';
import 'package:celebritysystems_mobile/core/helpers/token_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart'; // ✅ NEW
import '../../company_features/home/logic/company_home_cubit/company_home_cubit.dart';
import '../../company_features/home/ui/home_screen/company_home_screen.dart';
import '../../company_features/create_company_ticket/ui/create_company_ticket_screen.dart';
import '../di/dependency_injection.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
          settings: settings,
        );

      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<LoginCubit>(),
            child: const LoginScreen(),
          ),
          settings: settings,
        );

      case Routes.homeScreen:
        return _handleHomeScreenRoute(settings);

      case Routes.companyHomeScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CompanyHomeCubit(getIt(), getIt()),
            child: const CompanyHomeScreen(),
          ),
          settings: settings,
        );

      case Routes.createCompanyTicketScreen:
        return MaterialPageRoute(
          builder: (_) => const CreateCompanyTicketScreen(),
          settings: settings,
        );

      default:
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

  /// 🔥 Handle Home Screen route with supervisor check
  MaterialPageRoute _handleHomeScreenRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => FutureBuilder<bool>(
        future: _checkIfSupervisor(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Loading...'),
                  ],
                ),
              ),
            );
          }

          if (snapshot.data == true) {
            // 🔥 Supervisor -> Open in WebView
            return const SupervisorWebAppScreen(
              url: "https://dashboard.celebritysystems.com/",
            );
          }

          // Normal worker -> HomeScreen
          return BlocProvider(
            create: (context) => HomeCubit(getIt()),
            child: const HomeScreen(),
          );
        },
      ),
      settings: settings,
    );
  }

  /// 🔥 Check if user is supervisor
  Future<bool> _checkIfSupervisor() async {
    try {
      final token =
          await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
      if (token != null && token.isNotEmpty) {
        final tokenService = TokenService(token);
        if (!tokenService.isExpired) {
          return tokenService.role == Constants.SUPERVISOR;
        }
      }
    } catch (e) {
      debugPrint("Error checking supervisor status: $e");
    }
    return false;
  }
}

/// 🔥 NEW: WebView Screen for Supervisors
class SupervisorWebAppScreen extends StatelessWidget {
  final String url;
  const SupervisorWebAppScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Supervisor Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              // Back to login if supervisor wants to exit
              Navigator.of(context).pushReplacementNamed(Routes.loginScreen);
            },
          ),
        ],
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
