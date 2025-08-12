import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:celebritysystems_mobile/core/routing/app_router.dart';
import 'package:celebritysystems_mobile/core/routing/routes.dart';
import 'package:celebritysystems_mobile/core/theming/app_theme.dart';
import 'main.dart'; // Import for navigatorKey

class CelebrityApp extends StatefulWidget {
  final AppRouter appRouter;
  const CelebrityApp({super.key, required this.appRouter});

  @override
  State<CelebrityApp> createState() => _CelebrityAppState();
}

class _CelebrityAppState extends State<CelebrityApp> {
  @override
  void initState() {
    super.initState();
    setupOneSignalHandlers();
  }

  void setupOneSignalHandlers() {
    // Handle notification clicks with navigation
    OneSignal.Notifications.addClickListener((event) {
      debugPrint('Notification clicked: ${event.notification.body}');

      if (event.notification.additionalData != null) {
        try {
          final ticketId = event.notification.additionalData!['ticketId'];
          final notificationType =
              event.notification.additionalData!['notificationType'];

          debugPrint('Ticket ID: $ticketId');
          debugPrint('Notification Type: $notificationType');

          // Handle navigation based on notification type
          _handleNotificationNavigation(notificationType, ticketId);
        } catch (e) {
          debugPrint('Error parsing notification data: $e');

          // Fallback to handle individual fields if needed
          final ticketId = event.notification.additionalData!['ticketId'];
          if (ticketId != null) {
            debugPrint('Fallback - Ticket ID: $ticketId');
            _handleNotificationNavigation('DEFAULT', ticketId);
          }
        }
      } else {
        // Handle notifications without additional data
        debugPrint(
            'Notification without additional data, navigating to default screen');
        _handleNotificationNavigation('DEFAULT', null);
      }
    });

    // Handle notifications when app is in foreground
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      // Display the notification even when app is in foreground
      event.preventDefault();
      event.notification.display();

      debugPrint(
          'Notification received in foreground: ${event.notification.body}');

      // You can show custom in-app notification here if needed
      _showInAppNotification(event.notification);
    });

    // Handle permission changes
    OneSignal.Notifications.addPermissionObserver((state) {
      debugPrint("OneSignal notification permission state changed: $state");
    });

    // Set up user identification after login (call this when user logs in)
    // OneSignal.login("user_id");

    // Set up tags for user segmentation
    OneSignal.User.addTags({
      "app_version": "1.0.0",
      "platform": "mobile",
      // Add more tags as needed
    });

    debugPrint('OneSignal handlers setup completed');
  }

  void _handleNotificationNavigation(
      String? notificationType, String? ticketId) {
    // Add a small delay to ensure the app is fully loaded and navigation is ready
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return; // Check if widget is still mounted

      debugPrint(
          'Handling notification navigation - Type: $notificationType, TicketId: $ticketId');

      switch (notificationType?.toUpperCase()) {
        case 'TICKET_ASSIGNMENT':
          _navigateToHome();
          break;
        // case 'TICKET_UPDATE':
        //   _navigateToTicketDetails(ticketId);
        //   break;
        default:
          debugPrint('Unknown or default notification type: $notificationType');
          // Navigate to a default screen like home or notifications list
          _navigateToHome();
      }
    });
  }

  // void _navigateToTicketDetails(String? ticketId) {
  //   if (!mounted) return;

  //   try {
  //     if (ticketId != null) {
  //       // Navigate with ticket ID as argument
  //       Navigator.of(context).pushNamed(
  //         Routes.ticketDetails, // Make sure this route exists in your AppRouter
  //         arguments: {'ticketId': ticketId},
  //       );
  //       debugPrint('Navigating to ticket details for ID: $ticketId');
  //     } else {
  //       // Navigate to tickets list if no specific ID
  //       Navigator.of(context).pushNamed(Routes.ticketsList);
  //       debugPrint('Navigating to tickets list (no specific ticket ID)');
  //     }
  //   } catch (e) {
  //     debugPrint('Navigation error to ticket details: $e');
  //     _navigateToHome(); // Fallback navigation
  //   }
  // }

  void _navigateToHome() {
    if (!mounted) return;

    try {
      // Use pushNamedAndRemoveUntil to clear the stack and go to home
      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.homeScreen,
        (route) => false,
      );
      debugPrint('Navigating to home screen');
    } catch (e) {
      debugPrint('Navigation error to home: $e');
    }
  }

  void _showInAppNotification(OSNotification notification) {
    // Optional: Show a custom in-app notification when app is in foreground
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(notification.body ?? 'New notification'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            // Handle the action when user taps on the snackbar
            if (notification.additionalData != null) {
              final ticketId = notification.additionalData!['ticketId'];
              final notificationType =
                  notification.additionalData!['notificationType'];
              _handleNotificationNavigation(notificationType, ticketId);
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up OneSignal listeners if needed
    // OneSignal handles cleanup automatically, but you can add custom cleanup here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in, unit in dp)
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        navigatorKey:
            navigatorKey, // Global navigator key for navigation from anywhere
        debugShowCheckedModeBanner: false,
        title: 'Celebrity App',
        // You can use the library anywhere in the app even in theme
        theme: AppTheme.lightTheme,
        initialRoute: Routes.splashScreen,
        // Routes.loginScreen,
        // isLoggedInUser ? Routes.homeScreen : Routes.loginScreen,
        onGenerateRoute: widget.appRouter.generateRoute,
      ),
    );
  }
}

// import 'package:celebritysystems_mobile/core/routing/app_router.dart';
// import 'package:celebritysystems_mobile/core/routing/routes.dart';
// import 'package:celebritysystems_mobile/core/theming/app_theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class CelebrityApp extends StatefulWidget {
//   final AppRouter appRouter;
//   const CelebrityApp({super.key, required this.appRouter});

//   @override
//   State<CelebrityApp> createState() => _CelebrityAppState();
// }

// class _CelebrityAppState extends State<CelebrityApp> {
//   @override
//   void initState() {
//     super.initState();
//     setupOneSignalHandlers();
//   }

//   void setupOneSignalHandlers() {
//     // Additional OneSignal setup that might need context
//     // This runs after the widget is built and context is available

//     // You can add user identification here if needed
//     // OneSignal.login("user_id"); // Call this after user logs in

//     // Set up tags for user segmentation
//     // OneSignal.User.addTags({
//     //   "app_version": "1.0.0",
//     //   "user_type": "premium"
//     // });
//   }

//   @override
//   Widget build(BuildContext context) {
//     //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
//     return ScreenUtilInit(
//       designSize: const Size(375, 812),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Celebrity App',
//         // You can use the library anywhere in the app even in theme
//         theme: AppTheme.lightTheme,
//         initialRoute: Routes.splashScreen,
//         // Routes.loginScreen,
//         //isLoggedInUser ? Routes.homeScreen : Routes.loginScreen,
//         onGenerateRoute: widget.appRouter.generateRoute,
//       ),
//     );
//   }
// }
