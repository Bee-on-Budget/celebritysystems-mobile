import 'package:celebritysystems_mobile/core/routing/app_router.dart';
import 'package:celebritysystems_mobile/core/routing/routes.dart';
import 'package:celebritysystems_mobile/core/theming/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CelebrityApp extends StatelessWidget {
  final AppRouter appRouter;
  const CelebrityApp({super.key, required this.appRouter});

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
        // Routes.loginScreen, //isLoggedInUser ? Routes.homeScreen : Routes.loginScreen,
        onGenerateRoute: appRouter.generateRoute,
      ),
    );
  }
}
