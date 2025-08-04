import 'package:celebritysystems_mobile/celebrity_app.dart';
import 'package:celebritysystems_mobile/core/di/dependency_injection.dart';
import 'package:celebritysystems_mobile/core/helpers/extenstions.dart';
import 'package:celebritysystems_mobile/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'core/helpers/constants.dart';
import 'core/helpers/shared_pref_helper.dart';
import 'features/login/logic/user cubit/user_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize OneSignal first
  await initOneSignal();

  final token =
      await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
  final userCubit = UserCubit();

  if (!token.toString().isNullOrEmpty()) {
    await userCubit.loadUserFromToken(token!);
  }

  setupGetit();

  //To fix texts being hidden bug in flutter_screenUtils in release mode.
  await ScreenUtil.ensureScreenSize();
  // await checkIfLoggedInUser();

  runApp(
    BlocProvider(
      create: (_) => userCubit,
      child: CelebrityApp(appRouter: AppRouter()),
    ),
  );
}

Future<void> initOneSignal() async {
  // Replace with your actual OneSignal App ID
  OneSignal.initialize("18424b3e-8fed-4057-875a-9a9b2137df00");

  //sami
  print("Sami Debugging");

  // Then check for subscription ID after a delay
  Future.delayed(Duration(seconds: 2), () {
    String? subscriptionId = OneSignal.User.pushSubscription.id;
    print("Subscription ID: $subscriptionId");

    // if (subscriptionId != null) {
    //   SharedPreferences.getInstance().then((value) {
    //     value.setString(Preferences.oneSignalUserId, subscriptionId);
    //   });

    //     print("inside if subscriptionId from oneSignal is:  " + subscriptionId);
    // }
  });

  //sami

  // Request permission for notifications
  OneSignal.Notifications.requestPermission(true);

  // Handle notifications when app is in foreground
  OneSignal.Notifications.addForegroundWillDisplayListener((event) {
    // Display the notification even when app is in foreground
    event.preventDefault();
    event.notification.display();

    // You can add custom logic here
    debugPrint(
        'Notification received in foreground: ${event.notification.body}');
  });

  // Handle notification clicks
  OneSignal.Notifications.addClickListener((event) {
    debugPrint('Notification clicked: ${event.notification.body}');

    // You can add navigation logic here based on notification data
    // For example, navigate to specific screen based on notification payload
    if (event.notification.additionalData != null) {
      final data = event.notification.additionalData!;
      // Handle navigation based on data
      debugPrint('Additional data: $data');
    }
  });

  // Optional: Handle notification permission changes
  OneSignal.Notifications.addPermissionObserver((state) {
    debugPrint("Permission state changed: $state");
  });

  // Optional: Set up user identification after login
  // You can call this after user logs in: OneSignal.login("user_id");
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
