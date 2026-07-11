import 'dart:async';
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
            child: CompanyHomeScreen(),
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
      case '/':
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
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
              url: "https://dashboard.celebritysystems.com/dashboard",
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

  // Loading / error state so the supervisor never sees a blank white screen.
  bool _isLoading = true;
  bool _hasError = false;
  Timer? _loadTimeoutTimer;
  static const Duration _loadTimeout = Duration(seconds: 35);

  // iOS WKWebView frequently fails the very FIRST request after a cold launch
  // (connection-lost / cookie not yet committed); a reload then succeeds. So we
  // silently auto-retry a few times before ever showing the error screen.
  int _autoRetryCount = 0;
  static const int _maxAutoRetries = 4;

  // On iOS the first load can also reach the dashboard WITHOUT the jwt cookie
  // (WKWebView commits it late), making the web app redirect to /login. That
  // redirect does NOT mean the user logged out — so before treating it as a
  // logout, re-set the cookie and reload a few times. Only a persistent
  // /login bounce (or an explicit logout signal from the page) logs out.
  int _loginRedirectRetries = 0;
  static const int _maxLoginRedirectRetries = 3;
  bool _handlingLoginRedirect = false;

  // Once the dashboard has rendered real content, a later /login navigation
  // is a REAL logout (the web app's logout only expires the jwt cookie — it
  // never touches localStorage, so the FlutterLogout monitor won't fire).
  // Repairing the cookie after that would make logging out impossible.
  bool _dashboardRenderedOnce = false;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            print("onPageStarted $url");
            // Keep the loading overlay up even while a /login bounce is being
            // repaired, so the user never sees the web login page flash by.
            _startLoading();
          },
          onProgress: (progress) {
            // Any real progress means the page is responding, so clear the
            // error state if we had shown it.
            if (progress > 0 && _hasError && mounted) {
              setState(() => _hasError = false);
            }
          },
          onUrlChange: (url) {
            print("onUrlChange ${url.url}");
            if (url.url?.contains("/login") ?? false) {
              print("This is the new url ${url.url}");
              // SPA client-side route change to /login — the document exists,
              // so we can repair the cookie from inside the page.
              _handleLoginRedirect("onUrlChange: ${url.url}");
            }
          },
          onNavigationRequest: (request) {
            print("onNavigationRequest ${request.url}");
            // IMPORTANT: allow the /login navigation instead of blocking it.
            // We need the page to actually be on the dashboard origin so we
            // can set the auth cookie from inside it via JavaScript (the
            // native cookie API is unreliable on iOS). The loading overlay
            // hides the login page while we repair and bounce back.
            return NavigationDecision.navigate;
          },
          onPageFinished: (url) {
            final path = Uri.tryParse(url)?.path ?? '';

            if (path.startsWith('/login')) {
              _handleLoginRedirect("onPageFinished: $url");
              return;
            }

            // The local bootstrap page (path '/') redirects to the dashboard
            // immediately — keep the spinner up and don't treat it as the
            // rendered dashboard (its <script> body would fool the content
            // check and close the login-repair window prematurely).
            if (!path.startsWith('/dashboard')) {
              return;
            }

            _stopLoading();
            // Inject JavaScript to monitor logout button clicks
            _injectLogoutMonitor();
            // Guard against pages that return HTTP 200 but render an empty
            // body (e.g. auth not accepted in the webview) — that's a blank
            // screen to the user even though no error fired.
            _verifyContentRendered();
          },
          onWebResourceError: (error) {
            print(
                "onWebResourceError: ${error.errorCode} ${error.description} (mainFrame: ${error.isForMainFrame})");
            // Ignore cancellations (iOS NSURLErrorCancelled = -999): our own
            // retry/redirect reloads cancel the in-flight load, and counting
            // those as failures burns the retry budget instantly.
            final desc = error.description.toLowerCase();
            if (error.errorCode == -999 || desc.contains('cancel')) {
              return;
            }
            // Only surface errors for the MAIN document. On iOS WKWebView
            // `isForMainFrame` is often null for harmless sub-resource failures
            // (fonts, analytics, cancelled requests); treating those as fatal
            // would wrongly show a network-error screen over a working page.
            // So require an explicit true here.
            if (error.isForMainFrame == true) {
              _handleLoadFailure("web resource error: ${error.description}");
            }
          },
          // NOTE: intentionally not treating onHttpError as fatal. A 4xx/5xx on
          // a single sub-resource (an API widget, an image) must not blank the
          // whole dashboard behind an error screen. We only rely on main-frame
          // navigation failures and the load timeout below.
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

  /// Boots the WebView through a local bootstrap page instead of hitting the
  /// dashboard directly. loadHtmlString with a baseUrl on the dashboard's
  /// origin gives the page that origin, so `document.cookie` inside it sets
  /// the jwt cookie SYNCHRONOUSLY in the real cookie jar — no native-store
  /// race (the iOS WKWebView cookie API commits late/never, which is what
  /// made the first dashboard load land without auth and bounce to /login).
  /// Only after the cookie is provably set does it navigate to the dashboard.
  Future<void> _setCookieAndLoad() async {
    try {
      final token = await SharedPrefHelper.getSecuredString(
        SharedPrefKeys.userToken,
      );

      if (token == null || token.isEmpty) {
        // No session at all — nothing to authenticate with.
        _onLogout();
        return;
      }

      final origin = Uri.parse(widget.url);

      // Belt-and-suspenders: also seed the native store (reliable on Android).
      try {
        await WebViewCookieManager().setCookie(
          WebViewCookie(
            name: "jwt",
            value: token,
            domain: origin.host,
            path: "/",
          ),
        );
      } catch (e) {
        print("Native cookie set failed (continuing via bootstrap): $e");
      }

      // Same-origin bootstrap: set the cookie from inside a page on the
      // dashboard's origin, then enter the dashboard with auth in place.
      final bootstrapHtml = '''
<!DOCTYPE html>
<html>
<head><meta charset="utf-8"></head>
<body>
<script>
  document.cookie = "jwt=$token; path=/; max-age=86400; Secure; SameSite=Strict";
  window.location.replace("${widget.url}");
</script>
</body>
</html>''';

      await controller.loadHtmlString(
        bootstrapHtml,
        baseUrl: "${origin.scheme}://${origin.host}/",
      );
    } catch (e) {
      print("Bootstrap load failed, falling back to direct load: $e");
      controller.loadRequest(Uri.parse(widget.url));
    }
  }

  void _startLoading() {
    _loadTimeoutTimer?.cancel();
    if (mounted) {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
    }
    // Watchdog: if the page never finishes loading, show a retry UI instead
    // of leaving the reviewer on a blank white screen.
    _loadTimeoutTimer = Timer(_loadTimeout, () {
      if (mounted && _isLoading) {
        _handleLoadFailure("load timeout");
      }
    });
  }

  void _stopLoading() {
    _loadTimeoutTimer?.cancel();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Called on any load failure. Silently reloads a few times before ever
  /// showing the error screen, because the first attempt on iOS often fails
  /// while a retry succeeds — automating that retry keeps the reviewer from
  /// ever seeing the "Unable to load" screen on a transient hiccup.
  void _handleLoadFailure(String reason) {
    _loadTimeoutTimer?.cancel();
    if (!mounted) return;

    if (_autoRetryCount < _maxAutoRetries) {
      _autoRetryCount++;
      print(
          "Dashboard load failed ($reason). Auto-retry $_autoRetryCount/$_maxAutoRetries");
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
      // Exponential backoff: 1.5s, 3s, 4.5s, 6s. On iOS the network stack is
      // often not ready for the first seconds after a cold launch — rapid
      // retries all fail in that window while a retry a few seconds later
      // succeeds (which is why a manual Retry always worked).
      final delay = Duration(milliseconds: 1500 * _autoRetryCount);
      Future.delayed(delay, () {
        if (mounted) _setCookieAndLoad();
      });
    } else {
      print("Dashboard load failed ($reason). Auto-retries exhausted.");
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  /// Called when the web app redirects to /login. On iOS this usually means
  /// the request went out without the jwt cookie (WKWebView's native cookie
  /// store is unreliable) — NOT that the user logged out. Since the /login
  /// page is on the dashboard's own origin, we can set the cookie from INSIDE
  /// the page with document.cookie (which iOS honors) and bounce straight
  /// back to the dashboard. Only log out after several consecutive bounces.
  void _handleLoginRedirect(String source) async {
    if (_handlingLoginRedirect) return; // debounce overlapping callbacks
    if (!mounted) return;

    if (_dashboardRenderedOnce) {
      // The user was inside the dashboard and navigated to /login — that's a
      // real logout (the web logout just expires the jwt cookie). Repairing
      // the cookie here would trap the user in the dashboard forever.
      print("Post-render /login navigation ($source) — real logout");
      _onLogout();
      return;
    }

    if (_loginRedirectRetries >= _maxLoginRedirectRetries) {
      print("Login redirect persisted after retries ($source) — logging out");
      _onLogout();
      return;
    }

    _handlingLoginRedirect = true;
    _loginRedirectRetries++;
    print(
        "Login redirect ($source). Re-auth attempt $_loginRedirectRetries/$_maxLoginRedirectRetries");
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final token =
          await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);

      if (token == null || token.isEmpty) {
        // Genuinely no session — this is a real logout.
        _onLogout();
        return;
      }

      // Also refresh the native store (harmless, helps Android).
      await WebViewCookieManager().setCookie(
        WebViewCookie(
          name: "jwt",
          value: token,
          domain: Uri.parse(widget.url).host,
          path: "/",
        ),
      );

      // Set the cookie from inside the page — same-origin, so document.cookie
      // lands in WKWebView's real cookie jar — then go back to the dashboard.
      // Attributes mirror the web app's own setToken() exactly. JWTs are
      // base64url + dots, safe to interpolate.
      await controller.runJavaScript(
        'document.cookie = "jwt=$token; path=/; max-age=86400; Secure; SameSite=Strict";'
        'window.location.replace("${widget.url}");',
      );
    } catch (e) {
      print("Login redirect repair failed: $e — falling back to reload");
      await _setCookieAndLoad();
    } finally {
      // Small delay before accepting the next /login event so the redirect
      // above has a chance to happen before we count another bounce.
      Future.delayed(const Duration(seconds: 2), () {
        _handlingLoginRedirect = false;
      });
    }
  }

  void _retry() {
    // Manual retry from the error screen — give the auto-retries a fresh budget.
    _autoRetryCount = 0;
    _loginRedirectRetries = 0;
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    _setCookieAndLoad();
  }

  /// Checks whether the loaded page actually rendered any content. A page can
  /// return HTTP 200 yet display nothing (empty body / failed client-side
  /// auth), which the reviewer perceives as a blank screen.
  Future<void> _verifyContentRendered() async {
    // A single-page app can take several seconds to hydrate, especially on a
    // slow network. Poll a few times before deciding the page is truly empty,
    // so we never show a network-error screen over a page that is just still
    // rendering.
    const attempts = 4;
    const interval = Duration(seconds: 2);

    for (var i = 0; i < attempts; i++) {
      await Future.delayed(interval);
      if (!mounted || _hasError) return;

      try {
        // The SPA may have client-side-navigated away (e.g. to /login)
        // between polls — never score a page other than the dashboard, or
        // we'd mark the handshake done on the login form itself.
        final currentUrl = await controller.currentUrl();
        final currentPath = Uri.tryParse(currentUrl ?? '')?.path ?? '';
        if (!currentPath.startsWith('/dashboard')) {
          return; // navigation handlers own this situation now
        }

        final raw = await controller.runJavaScriptReturningResult(
          "(function(){var b=document.body;if(!b)return 0;"
          "var t=(b.innerText||'').trim().length;"
          "var c=b.childElementCount||0;return t+c;})()",
        );
        final score = int.tryParse(raw.toString().replaceAll('"', '')) ?? 0;
        // Any content at all → the page rendered successfully. Clear the
        // retry budgets so a later, unrelated hiccup gets its own retries,
        // and mark the handshake done: from now on /login means real logout.
        if (score > 0) {
          _autoRetryCount = 0;
          _loginRedirectRetries = 0;
          _dashboardRenderedOnce = true;
          return;
        }
      } catch (e) {
        // If we can't even evaluate JS, don't assume failure — the page may
        // still be initializing. Just try again.
        print("content check attempt ${i + 1} failed: $e");
      }
    }

    // Still completely empty after several seconds → treat as a failed load
    // (auto-retry first, error screen only as a last resort).
    if (mounted && !_hasError) {
      _handleLoadFailure("empty content after $attempts checks");
    }
  }

  Future<void> _injectLogoutMonitor() async {
    // The dashboard's logout ONLY expires the jwt cookie (it never touches
    // localStorage/sessionStorage), so the storage hooks below never fire for
    // a real logout. The reliable signal is the cookie itself: watch it, and
    // when it transitions from present to gone, that IS a logout.
    const String jsCode = '''
      (function() {
        console.log("Token removal monitor injected");

        // Watch the jwt cookie: present -> gone means the user logged out.
        if (!window.__jwtCookieWatch) {
          window.__jwtCookieWatch = true;
          var readJwt = function() {
            var m = document.cookie.match(/(?:^|;\\s*)jwt=([^;]*)/);
            return !!(m && m[1] && m[1].length > 0);
          };
          var hadJwt = readJwt();
          console.log("jwt cookie watcher installed, present:", hadJwt);
          setInterval(function() {
            var has = readJwt();
            if (hadJwt && !has) {
              console.log("jwt cookie removed - logout detected");
              FlutterLogout.postMessage('jwt_cookie_removed');
            }
            hadJwt = has;
          }, 700);
        }
        
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
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              // Hide the webview while it errors so a half-loaded blank page
              // isn't shown behind the error UI.
              if (!_hasError) WebViewWidget(controller: controller),
              if (_isLoading && !_hasError)
                const ColoredBox(
                  color: Colors.white,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              if (_hasError) _buildErrorView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return ColoredBox(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Unable to load the dashboard',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please check your internet connection and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _retry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(Routes.loginScreen);
                },
                child: const Text('Back to login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _loadTimeoutTimer?.cancel();
    super.dispose();
  }
}
