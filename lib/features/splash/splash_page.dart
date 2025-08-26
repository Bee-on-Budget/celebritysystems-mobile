import 'package:celebritysystems_mobile/core/helpers/constants.dart';
import 'package:celebritysystems_mobile/core/helpers/extenstions.dart';
import 'package:celebritysystems_mobile/core/helpers/shared_pref_helper.dart';
import 'package:celebritysystems_mobile/core/helpers/token_data_extractor.dart';
import 'package:celebritysystems_mobile/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
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
      _navigateBasedOnRole(role);
    } catch (e) {
      print('Splash: Error during initialization: $e');
      _navigateToLogin();
    }
  }

  void _navigateBasedOnRole(String? role) {
    if (role == Constants.CELEBRITY_SYSTEM_WORKER) {
      print('Splash: Navigating to worker home screen');
      context.pushReplacementNamed(Routes.homeScreen);
    } else if (role == Constants.COMPANY) {
      print('Splash: Navigating to company home screen');
      // context.pushReplacementNamed(Routes.companyHomeScreen);
      context.pushReplacementNamed(Routes.companyDashboardScreen);
    } else {
      print("Splash: Unknown role '$role', navigating to login");
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    print('Splash: Navigating to login screen');
    context.pushReplacementNamed(Routes.loginScreen);
  }

  @override
  Widget build(BuildContext context) {
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
