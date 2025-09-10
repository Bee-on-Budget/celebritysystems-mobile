import 'package:celebritysystems_mobile/celebrity_app.dart';
import 'package:celebritysystems_mobile/core/di/dependency_injection.dart';
import 'package:celebritysystems_mobile/core/helpers/extenstions.dart';
import 'package:celebritysystems_mobile/core/routing/app_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'dart:math' as math;
import 'core/helpers/constants.dart';
import 'core/helpers/shared_pref_helper.dart';
import 'features/login/logic/user cubit/user_cubit.dart';

// Global navigator key for navigation from anywhere in the app
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Load environment variables
  // await dotenv.load(fileName: ".env");

  // Initialize OneSignal first (basic setup only)
  await initOneSignal();

  final token =
      await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
  final userCubit = UserCubit(); //new

  print("=== APP INITIALIZATION ===");
  print("Token found: ${token != null ? "Yes" : "No"}");
  if (token != null) {
    print("Token length: ${token.length}");
    print(
        "Token preview: ${token.substring(0, math.min(50, token.length as int))}...");
  }

  if (!token.toString().isNullOrEmpty()) {
    print("Loading user from existing token...");
    await userCubit.loadUserFromToken(token!);
    final user = userCubit.state;
    print("User loaded: ${user != null ? "Yes" : "No"}");
    if (user != null) {
      print("User role: ${user.role}");
      print("User ID: ${user.userId}");
      if (user.role == Constants.COMPANY) {
        print("Company ID: ${user.companyId}");
      }
    }
  } else {
    print("No existing token found, user will need to login");
  }

  setupGetit();

  //To fix texts being hidden bug in flutter_screenUtils in release mode.
  await ScreenUtil.ensureScreenSize();
  // await checkIfLoggedInUser();

  print("=== STARTING APP ===");
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: BlocProvider(
        create: (_) => userCubit,
        child: CelebrityApp(appRouter: AppRouter()),
      ),
    ),
  );
}

Future<void> initOneSignal() async {
  // Replace with your actual OneSignal App ID
  OneSignal.initialize("18424b3e-8fed-4057-875a-9a9b2137df00");

  // Store subscription ID after initialization
  Future.delayed(Duration(seconds: 3), () async {
    String? subscriptionId = OneSignal.User.pushSubscription.id;
    print("Subscription ID: $subscriptionId");

    await SharedPrefHelper.setData(
        SharedPrefKeys.oneSignalUserId, subscriptionId);
  });

  // Request permission for notifications
  OneSignal.Notifications.requestPermission(true);

  // Note: Detailed handlers are now set up in CelebrityApp class
  // This keeps the main.dart clean and allows access to navigation context
}

checkIfLoggedInUser() async {
  String? userToken =
      await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
  if (userToken!.isNullOrEmpty()) {
    isLoggedInUser = true;
  } else {
    isLoggedInUser = false;
  }
}
