import 'package:celebritysystems_mobile/core/routing/app_router.dart';
import 'package:celebritysystems_mobile/core/routing/routes.dart';
import 'package:celebritysystems_mobile/core/theming/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    // Additional OneSignal setup that might need context
    // This runs after the widget is built and context is available

    // You can add user identification here if needed
    // OneSignal.login("user_id"); // Call this after user logs in

    // Set up tags for user segmentation
    // OneSignal.User.addTags({
    //   "app_version": "1.0.0",
    //   "user_type": "premium"
    // });
  }

  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Celebrity App',
        // You can use the library anywhere in the app even in theme
        theme: AppTheme.lightTheme,
        initialRoute: Routes.splashScreen,
        // Routes.loginScreen,
        //isLoggedInUser ? Routes.homeScreen : Routes.loginScreen,
        onGenerateRoute: widget.appRouter.generateRoute,
      ),
    );
  }
}
