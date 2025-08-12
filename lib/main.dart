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

// Global navigator key for navigation from anywhere in the app
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  // await dotenv.load(fileName: ".env");

  // Initialize OneSignal first (basic setup only)
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








// import 'package:celebritysystems_mobile/celebrity_app.dart';
// import 'package:celebritysystems_mobile/core/di/dependency_injection.dart';
// import 'package:celebritysystems_mobile/core/helpers/extenstions.dart';
// import 'package:celebritysystems_mobile/core/routing/app_router.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'core/helpers/constants.dart';
// import 'core/helpers/shared_pref_helper.dart';
// import 'features/login/logic/user cubit/user_cubit.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Load environment variables
//   // await dotenv.load(fileName: ".env");

//   // Initialize OneSignal first
//   await initOneSignal();

//   final token =
//       await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
//   final userCubit = UserCubit();

//   if (!token.toString().isNullOrEmpty()) {
//     await userCubit.loadUserFromToken(token!);
//   }

//   setupGetit();

//   //To fix texts being hidden bug in flutter_screenUtils in release mode.
//   await ScreenUtil.ensureScreenSize();
//   // await checkIfLoggedInUser();

//   runApp(
//     BlocProvider(
//       create: (_) => userCubit,
//       child: CelebrityApp(appRouter: AppRouter()),
//     ),
//   );
// }

// Future<void> initOneSignal() async {
//   // Replace with your actual OneSignal App ID
//   OneSignal.initialize("18424b3e-8fed-4057-875a-9a9b2137df00");

//   // Then check for subscription ID after a delay
//   Future.delayed(Duration(seconds: 3), () async {
//     String? subscriptionId = OneSignal.User.pushSubscription.id;
//     print("Subscription ID: $subscriptionId");

//     // String playedIdTest = "I am sami";

//     await SharedPrefHelper.setData(
//         SharedPrefKeys.oneSignalUserId, subscriptionId);
//   });

//   // Request permission for notifications
//   OneSignal.Notifications.requestPermission(true);

//   // Handle notifications when app is in foreground
//   OneSignal.Notifications.addForegroundWillDisplayListener((event) {
//     // Display the notification even when app is in foreground
//     event.preventDefault();
//     event.notification.display();

//     // You can add custom logic here
//     debugPrint(
//         'Notification received in foreground: ${event.notification.body}');
//   });

//   // Handle notification clicks
//   OneSignal.Notifications.addClickListener(
//     (event) {
//       if (event.notification.additionalData != null) {
//         try {
//           final ticketId = event.notification.additionalData!['ticketId'];
//           debugPrint('Ticket ID: $ticketId');

//           final notificationType =
//               event.notification.additionalData!['notificationType'];
//           debugPrint('Notification Type: $notificationType');

//           // Handle the parsed data
//           handleTicketNotificationClick(notificationType);
//         } catch (e) {
//           debugPrint('Error parsing notification data: $e');

//           // Fallback to handle individual fields if needed
//           final ticketId = event.notification.additionalData!['ticketId'];
//           if (ticketId != null) {
//             debugPrint('Fallback - Ticket ID: $ticketId');
//           }
//         }
//       }
//     },
//   );

//   // Optional: Handle notification permission changes
//   OneSignal.Notifications.addPermissionObserver((state) {
//     debugPrint("Permission state changed: $state");
//   });

//   // Optional: Set up user identification after login
//   // You can call this after user logs in: OneSignal.login("user_id");
// }

// // Handle the notification click with the parsed model
// void handleTicketNotificationClick(String notificationType) {
//   // Navigate to ticket details screen
//   // Example navigation logic:
//   switch (notificationType) {
//     case 'TICKET_ASSIGNMENT':
//       navigateToTicketDetails();
//       break;
//     case 'TICKET_UPDATE':
//       navigateToTicketDetails();
//       break;
//     default:
//       debugPrint('Unknown notification type: ${notificationType}');
//   }
// }

// void navigateToTicketDetails() {
//   // Your navigation logic here
  
//   debugPrint('Navigating to ticket details for ID: ');
// }

// checkIfLoggedInUser() async {
//   String? userToken =
//       await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
//   if (userToken!.isNullOrEmpty()) {
//     isLoggedInUser = true;
//   } else {
//     isLoggedInUser = false;
//   }
// }
