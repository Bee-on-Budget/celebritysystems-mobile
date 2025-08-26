import 'package:celebritysystems_mobile/core/helpers/constants.dart';
import 'package:celebritysystems_mobile/core/helpers/extenstions.dart';
import 'package:celebritysystems_mobile/core/helpers/shared_pref_helper.dart';
import 'package:celebritysystems_mobile/core/helpers/token_data_extractor.dart';
import 'package:celebritysystems_mobile/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _isRedirecting = false;
  bool _isSupervisor = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    if (_isRedirecting) return;

    _isRedirecting = true;

    // Wait for 3 seconds to show splash screen
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    await _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    try {
      final token =
          await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
      print('Splash: Token found: ${token != null ? "Yes" : "No"}');

      if (token == null || token.toString().isEmpty) {
        print('Splash: No token, navigating to login');
        _navigateToLogin();
        return;
      }

      // Validate token using utility class
      if (!TokenDataExtractor.isTokenValid(token)) {
        print('Splash: Token invalid or expired, navigating to login');
        _navigateToLogin();
        return;
      }

      // Extract and save token data using utility class
      final success = await TokenDataExtractor.extractAndSaveTokenData(token,
          source: 'Splash');
      if (!success) {
        print('Splash: Failed to extract token data, navigating to login');
        _navigateToLogin();
        return;
      }

      // Navigate based on role
      final role = TokenDataExtractor.getUserRole(token);
      await _navigateBasedOnRole(role);
    } catch (e) {
      print('Splash: Error during initialization: $e');
      _navigateToLogin();
    }
  }

  Future<void> _navigateBasedOnRole(String? role) async {
    if (role == Constants.CELEBRITY_SYSTEM_WORKER) {
      print('Splash: Navigating to worker home screen');
      if (mounted) context.pushReplacementNamed(Routes.homeScreen);
    } else if (role == Constants.COMPANY) {
      print('Splash: Navigating to company dashboard screen');
      if (mounted) context.pushReplacementNamed(Routes.companyDashboardScreen);
    } else if (role == Constants.SUPERVISOR) {
      print("Splash: Redirecting supervisor to web app...");
      // Set the supervisor flag for UI updates
      if (mounted) {
        setState(() {
          _isSupervisor = true;
        });
      }
      await _launchWebApp();
    } else {
      print("Splash: Unknown role '$role', navigating to login");
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    print('Splash: Navigating to login screen');
    if (mounted) context.pushReplacementNamed(Routes.loginScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200.h,
              width: 200.h,
              child: Image.asset('assets/images/logo.png'),
            ),
            // Show loading indicator for supervisor redirect
            if (_isRedirecting && _isSupervisor)
              Padding(
                padding: EdgeInsets.only(top: 50.h),
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    SizedBox(height: 20.h),
                    Text(
                      'Redirecting to dashboard...',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchWebApp() async {
    final Uri url = Uri.parse('https://dashboard.celebritysystems.com/');

    try {
      print("Attempting to launch: $url");

      final bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (launched) {
        print("Successfully launched webapp");

        // Show a dialog asking if they want to close the app
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Redirected to Dashboard'),
                content: const Text(
                  'You have been redirected to the web dashboard. You can now close this app or return to login.',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.pushReplacementNamed(Routes.loginScreen);
                    },
                    child: const Text('Back to Login'),
                  ),
                  TextButton(
                    onPressed: () {
                      SystemNavigator.pop(); // Close the app
                    },
                    child: const Text('Close App'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        print('Failed to launch $url');
        _handleLaunchFailure();
      }
    } catch (e) {
      print('Error launching web app: $e');
      _handleLaunchFailure();
    }
  }

  void _handleLaunchFailure() {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Cannot Open Dashboard'),
            content: const Text(
              'Unable to open the web dashboard. Please check your internet connection or contact support.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.pushReplacementNamed(Routes.loginScreen);
                },
                child: const Text('Back to Login'),
              ),
            ],
          );
        },
      );
    }
  }
}
