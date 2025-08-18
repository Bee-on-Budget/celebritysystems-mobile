import 'package:celebritysystems_mobile/core/helpers/constants.dart';
import 'package:celebritysystems_mobile/core/helpers/extenstions.dart';
import 'package:celebritysystems_mobile/core/helpers/shared_pref_helper.dart';
import 'package:celebritysystems_mobile/core/helpers/token_service.dart';
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
  bool _isSupervisor = false; // Add this to track supervisor status

  @override
  Widget build(BuildContext context) {
    if (!_isRedirecting) {
      _isRedirecting = true;
      Future.delayed(const Duration(seconds: 3), () async {
        final token =
            await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);

        print('token $token');

        final tokenService = TokenService(token);
        if (token == null || token.toString().isEmpty) {
          if (mounted) context.pushReplacementNamed(Routes.loginScreen);
        } else if (tokenService.isExpired) {
          print('tokenService ${tokenService.claims}');
          print("isExpired: ${tokenService.isExpired}");
          if (mounted) context.pushReplacementNamed(Routes.loginScreen);
        } else {
          await SharedPrefHelper.setData(
              SharedPrefKeys.username, tokenService.username);
          await SharedPrefHelper.setData(
              SharedPrefKeys.userId, tokenService.userId);

          print("User role: ${tokenService.role}");

          if (tokenService.role == Constants.CELEBRITY_SYSTEM_WORKER) {
            if (mounted) context.pushReplacementNamed(Routes.homeScreen);
          } else if (tokenService.role == Constants.COMPANY) {
            if (mounted) context.pushReplacementNamed(Routes.companyHomeScreen);
          } else if (tokenService.role == Constants.SUPERVISOR) {
            print("Redirecting supervisor to web app...");
            // Set the supervisor flag for UI updates
            if (mounted) {
              setState(() {
                _isSupervisor = true;
              });
            }
            await _launchWebApp();
          } else {
            print(
                "there is no implementation for this Role: ${tokenService.role}");
            if (mounted) context.pushReplacementNamed(Routes.loginScreen);
          }
        }
      });
    }

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
            // Use _isSupervisor instead of tokenService?.role
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
