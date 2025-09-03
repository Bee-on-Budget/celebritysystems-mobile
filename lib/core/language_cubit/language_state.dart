import 'package:flutter/material.dart';

// Simple state class
class LanguageState {
  final Locale locale;
  final String languageName;

  LanguageState({
    required this.locale,
    required this.languageName,
  });
}
