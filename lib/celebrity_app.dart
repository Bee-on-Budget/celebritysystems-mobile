import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:celebritysystems_mobile/core/routing/app_router.dart';
import 'package:celebritysystems_mobile/core/routing/routes.dart';
import 'package:celebritysystems_mobile/core/theming/app_theme.dart';
import 'main.dart';

int? notificationTicketId = 0;

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
    // Handles notification click for cold start, background, and foreground
    OneSignal.Notifications.addClickListener((event) {
      final data = event.notification.additionalData;
      debugPrint("Notification clicked: $data");

      _handleNotificationNavigation(
        data?['notificationType'],
        data?['ticketId'],
      );
    });

    // Show in foreground
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      event.preventDefault();
      event.notification.display();
      _showInAppNotification(event.notification);
    });
  }

  void _handleNotificationNavigation(
      String? notificationType, String? ticketId) {
    Future.delayed(const Duration(milliseconds: 300), () {
      debugPrint("Navigating: type=$notificationType, ticketId=$ticketId");

      switch (notificationType?.toUpperCase()) {
        case 'TICKET_ASSIGNMENT':
          notificationTicketId = int.tryParse(ticketId ?? "0");
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            Routes.homeScreen, (route) => false,
            // arguments: notificationTicketId
          );
          break;
        // case 'TICKET_UPDATE':
        //   navigatorKey.currentState?.pushNamed(
        //     Routes.ticketDetails,
        //     arguments: {'ticketId': ticketId},
        //   );
        //   break;
        default:
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            Routes.homeScreen,
            (route) => false,
          );
      }
    });
  }

  void _showInAppNotification(OSNotification notification) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(notification.body ?? 'New notification'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            final data = notification.additionalData;
            _handleNotificationNavigation(
              data?['notificationType'],
              data?['ticketId'],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Celebrity App',
        theme: AppTheme.lightTheme,
        initialRoute: Routes.splashScreen,
        onGenerateRoute: widget.appRouter.generateRoute,
      ),
    );
  }
}
