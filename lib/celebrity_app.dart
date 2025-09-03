import 'package:celebritysystems_mobile/core/language_cubit/language_cubit.dart';
import 'package:celebritysystems_mobile/settings_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:celebritysystems_mobile/core/routing/app_router.dart';
import 'package:celebritysystems_mobile/core/routing/routes.dart';
import 'package:celebritysystems_mobile/core/theming/app_theme.dart';
import 'main.dart';

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
          final notificationTicketId = int.tryParse(ticketId ?? "0");
          debugPrint("Parsed ticket ID: $notificationTicketId");

          if (notificationTicketId != null && notificationTicketId > 0) {
            debugPrint(
                "Navigating to HomeScreen with ticket ID: $notificationTicketId");
            navigatorKey.currentState?.pushNamedAndRemoveUntil(
              Routes.homeScreen,
              (route) => false,
              arguments: notificationTicketId,
            );
          } else {
            debugPrint("Invalid ticket ID, navigating without arguments");
            navigatorKey.currentState?.pushNamedAndRemoveUntil(
              Routes.homeScreen,
              (route) => false,
            );
          }
          break;

        case 'TICKET_UPDATE':
          final updateTicketId = int.tryParse(ticketId ?? "0");
          if (updateTicketId != null && updateTicketId > 0) {
            navigatorKey.currentState?.pushNamedAndRemoveUntil(
              Routes.homeScreen,
              (route) => false,
              arguments: updateTicketId,
            );
          } else {
            navigatorKey.currentState?.pushNamedAndRemoveUntil(
              Routes.homeScreen,
              (route) => false,
            );
          }
          break;

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
        backgroundColor: Colors.blueGrey[800],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(
          label: 'View',
          textColor: Colors.white,
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
      child: BlocProvider(
        create: (context) => LanguageCubit(),
        child: MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Celebrity App',
          theme: AppTheme.lightTheme,
          initialRoute: Routes.splashScreen,
          onGenerateRoute: widget.appRouter.generateRoute,
          // Easy localization handles these automatically
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          // home: SettingsScreen(),
        ),
      ),
    );
  }
}

// @override
// Widget build(BuildContext context) {
//   return ScreenUtilInit(
//     designSize: const Size(375, 812),
//     minTextAdapt: true,
//     splitScreenMode: true,
//     builder: (_, __) {
//       return BlocProvider(
//         create: (_) => LanguageCubit(),
//         child: MaterialApp(
//           navigatorKey: navigatorKey,
//           debugShowCheckedModeBanner: false,
//           title: 'Celebrity App',
//           theme: AppTheme.lightTheme,
//           initialRoute: Routes.splashScreen,
//           onGenerateRoute: widget.appRouter.generateRoute,

//           // easy_localization setup
//           localizationsDelegates: context.localizationDelegates,
//           supportedLocales: context.supportedLocales,
//           locale: context.locale,

//           // RTL/LTR handled automatically by easy_localization
//           builder: (context, child) => Directionality(
//             textDirection: context.locale.languageCode == 'ar'
//                 ? TextDirection.rtl
//                 : TextDirection.ltr,
//             child: child ?? const SizedBox.shrink(),
//           ),
//         ),
//       );
//     },
//   );
// }
