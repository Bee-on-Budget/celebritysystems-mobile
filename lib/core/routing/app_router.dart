import 'dart:io';

import 'package:celebritysystems_mobile/company_features/company_profile/logic/cubit/profile_cubit.dart';
import 'package:celebritysystems_mobile/company_features/company_profile/ui/company_profile.dart';
import 'package:celebritysystems_mobile/company_features/create_company_ticket/logic/cubit/create_ticket_cubit.dart';
import 'package:celebritysystems_mobile/company_features/screens/data/models/ticket_history_response.dart';
import 'package:celebritysystems_mobile/company_features/screens/logic/screen_cubit/screen_cubit.dart';
import 'package:celebritysystems_mobile/company_features/screens/ui/screen_details.dart';
import 'package:celebritysystems_mobile/company_features/show_contract/logic/contract_cubit/contract_cubit.dart';
import 'package:celebritysystems_mobile/company_features/show_contract/screens/show_contract.dart';
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
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../company_features/company_dashboard_screen.dart';
import '../../company_features/home/data/models/company_screen_model.dart';
import '../../company_features/home/logic/company_home_cubit/company_home_cubit.dart';
import '../../company_features/home/ui/home_screen/company_home_screen.dart';
import '../../company_features/create_company_ticket/ui/create_ticket_screen.dart';
import '../../company_features/reports/ui/report_screen.dart';
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

      case Routes.companyDashboardScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<CompanyHomeCubit>(),
            child: const CompanyDashboardScreen(),
          ),
          settings: settings,
        );

      case Routes.companyHomeScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<CompanyHomeCubit>(),
            child: const CompanyHomeScreen(),
          ),
          settings: settings,
        );

      case Routes.createCompanyTicketScreen:
        // Extract the arguments with null safety
        final List<CompanyScreenModel> screensList;

        if (arguments != null && arguments is List<CompanyScreenModel>) {
          screensList = arguments;
        } else {
          debugPrint(
              "Warning: Expected List<CompanyScreenModel> but got: ${arguments.runtimeType}");
          screensList = []; // Fallback to empty list
        }

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<CreateTicketCubit>(),
            child: CreateTicketScreen(
              screensList: screensList,
            ),
          ),
          settings: settings,
        );

      case Routes.companyReportsScreen:
        // Extract the arguments with null safety
        final List<CompanyScreenModel> screensList;

        if (arguments != null && arguments is List<CompanyScreenModel>) {
          screensList = arguments;
        } else {
          debugPrint(
              "Warning: Expected List<CompanyScreenModel> but got: ${arguments.runtimeType}");
          screensList = []; // Fallback to empty list
        }

        return MaterialPageRoute(
          builder: (_) => ReportScreen(
              // listOfCompanyScreen: screensList,
              ),
          settings: settings,
        );

      case Routes.companyProfileScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ProfileCubit>(),
            child: CompanyDetailsScreen(),
          ),
          settings: settings,
        );
      case Routes.contractScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ContractCubit(getIt()),
            child: ContractScreen(),
          ),
          settings: settings,
        );
      case Routes.screenDetailsHistory:
        // Extract the arguments with null safety
        final CompanyScreenModel screen;

        if (arguments != null && arguments is CompanyScreenModel) {
          screen = arguments;
        } else {
          debugPrint(
              "Warning: Expected CompanyScreenModel but got: ${arguments.runtimeType}");
          screen = CompanyScreenModel(); // Fallback to empty list
        }
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ScreenCubit(getIt()),
            child: ScreenHistoryPage(
              screen: screen,
            ),
          ),
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
class SupervisorWebAppScreen extends StatefulWidget {
  final String url;

  const SupervisorWebAppScreen({super.key, required this.url});

  State<SupervisorWebAppScreen> createState() => _SupervisorWebAppScreenState();
}

class _SupervisorWebAppScreenState extends State<SupervisorWebAppScreen> {
  late final WebViewController controller;
  bool _shouldBlockBackButton = false;
  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            print("onPageStarted $url");
            if (url.contains("/login")) {
              _onLogout();
            }
          },
          onUrlChange: (url) {
            print("onUrlChange ${url.url}");
            if (url.url?.contains("/login") ?? false) {
              print("This is the new url ${url.url}");
              _onLogout();
            }
          },
          onNavigationRequest: (request) {
            print("onNavigationRequest ${request.url}");
            if (request.url.contains("/login")) {
              setState(() {
                _shouldBlockBackButton = true;
              });
              _onLogout();
              return NavigationDecision.prevent;
            }
            // Reset back button blocking for other pages
            if (_shouldBlockBackButton) {
              setState(() {
                _shouldBlockBackButton = false;
              });
            }
            return NavigationDecision.navigate;
          },
          onPageFinished: (url) {
            // Inject JavaScript to monitor logout button clicks
            _injectLogoutMonitor();
          },
        ),
      )
      ..addJavaScriptChannel(
        'FlutterLogout',
        onMessageReceived: (JavaScriptMessage message) {
          print("Logout detected from web: ${message.message}");
          _onLogout();
        },
      );

    _setCookieAndLoad();
  }

  Future<void> _setCookieAndLoad() async {
    try {
      final token = await SharedPrefHelper.getSecuredString(
        SharedPrefKeys.userToken,
      );

      if (token != null && token.isNotEmpty) {
        final cookie = WebViewCookie(
          name: "jwt",
          value: token,
          domain: Uri.parse(widget.url).host,
          path: "/",
        );

        await WebViewCookieManager().setCookie(cookie);
      }

      controller.loadRequest(Uri.parse(widget.url));
    } catch (e) {
      print("Error setting cookie: $e");
      controller.loadRequest(Uri.parse(widget.url));
    }
  }

  Future<void> _injectLogoutMonitor() async {
    // Method 4: Monitor for JWT token removal from localStorage/sessionStorage
    const String jsCode = '''
      (function() {
        console.log("Token removal monitor injected");
        
        // Monitor localStorage.removeItem()
        const originalLocalRemoveItem = localStorage.removeItem;
        localStorage.removeItem = function(key) {
          console.log("localStorage.removeItem called with key:", key);
          if (key.toLowerCase().includes('token') || 
              key.toLowerCase().includes('jwt') || 
              key.toLowerCase().includes('auth') ||
              key.toLowerCase().includes('session')) {
            console.log("Auth token removed from localStorage:", key);
            FlutterLogout.postMessage('token_removed_local');
          }
          return originalLocalRemoveItem.apply(this, arguments);
        };
        
        // Monitor sessionStorage.removeItem()
        const originalSessionRemoveItem = sessionStorage.removeItem;
        sessionStorage.removeItem = function(key) {
          console.log("sessionStorage.removeItem called with key:", key);
          if (key.toLowerCase().includes('jwt')) {
            console.log("Auth token removed from sessionStorage:", key);
            FlutterLogout.postMessage('token_removed_session');
          }
          return originalSessionRemoveItem.apply(this, arguments);
        };
        
        // Monitor localStorage.clear()
        const originalLocalClear = localStorage.clear;
        localStorage.clear = function() {
          console.log("localStorage.clear() called - all data cleared");
          FlutterLogout.postMessage('storage_cleared_local');
          return originalLocalClear.apply(this, arguments);
        };
        
        // Monitor sessionStorage.clear()
        const originalSessionClear = sessionStorage.clear;
        sessionStorage.clear = function() {
          console.log("sessionStorage.clear() called - all data cleared");
          FlutterLogout.postMessage('storage_cleared_session');
          return originalSessionClear.apply(this, arguments);
        };
        
        console.log("All storage monitoring methods set up successfully");
      })();
    ''';

    try {
      await controller.runJavaScript(jsCode);
      print("Logout monitor JavaScript injected successfully");
    } catch (e) {
      print("Error injecting logout monitor: $e");
    }
  }

  Future<void> _onLogout() async {
    try {
      await SharedPrefHelper.clearAllSecuredData();
      await SharedPrefHelper.clearAllDataExceptOneSignalUserId();

      if (mounted) {
        Navigator.of(context).pushReplacementNamed(Routes.loginScreen);
      }
    } catch (e) {
      print("Error during logout: $e");
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(Routes.loginScreen);
      }
    }
  }

  void _showExitMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Press back again to exit the application'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleBackPress() async {
    final now = DateTime.now();

    // If we're on login page, do nothing (back button is completely disabled)
    if (_shouldBlockBackButton) {
      return;
    }

    // Check if this is a double tap (within 2 seconds)
    if (_lastBackPressTime != null &&
        now.difference(_lastBackPressTime!) < const Duration(seconds: 2)) {
      // Double tap detected - properly exit the app
      try {
        // Clear all app data and cookies
        await WebViewCookieManager().clearCookies();
        await SharedPrefHelper.clearAllSecuredData();

        if (mounted) {
          // Use exit() instead of SystemNavigator.pop() for cleaner exit
          exit(0);
        }
      } catch (e) {
        print("Error during app exit: $e");
        // Fallback to SystemNavigator.pop()
        SystemNavigator.pop();
      }
      return;
    }

    // First tap - show message and record time
    _lastBackPressTime = now;
    _showExitMessage();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: false, // Always prevent default back navigation
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          if (didPop) return;
          await _handleBackPress();
        },
        child: Scaffold(
          body: WebViewWidget(controller: controller),
        ),
      ),
    );
  }
}
