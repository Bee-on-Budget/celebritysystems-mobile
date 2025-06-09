import 'package:celebritysystems_mobile/core/theming/colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: ColorsManager.mistWhite,
      primaryColor: ColorsManager.royalIndigo,
      colorScheme: ColorScheme.light(
        primary: ColorsManager.royalIndigo,
        secondary: ColorsManager.coralBlaze,
        error: ColorsManager.softCrimson,
        surface: ColorsManager.paleLavenderBlue,
      ),
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          color: ColorsManager.graphiteBlack,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: ColorsManager.graphiteBlack,
        ),
        bodyMedium: TextStyle(
          color: ColorsManager.slateGray,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsManager.royalIndigo,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorsManager.paleLavenderBlue,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: ColorsManager.slateGray),
      ),
    );
  }
}
