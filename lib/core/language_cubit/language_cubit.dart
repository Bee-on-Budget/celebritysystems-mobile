import 'package:celebritysystems_mobile/core/language_cubit/language_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit()
      : super(LanguageState(
          locale: const Locale('en'),
          languageName: 'English',
        ));

  // Available languages
  static const List<Map<String, dynamic>> supportedLanguages = [
    {'code': 'en', 'name': 'English', 'nativeName': 'English'},
    {'code': 'ar', 'name': 'Arabic', 'nativeName': 'العربية'},
  ];

  void changeLanguage(BuildContext context, String languageCode) async {
    final locale = Locale(languageCode);

    // Change language using easy_localization
    await context.setLocale(locale);

    _updateState(locale);
  }

  void toggleLanguage(BuildContext context) {
    final currentCode = state.locale.languageCode;
    final newCode = currentCode == 'en' ? 'ar' : 'en';
    changeLanguage(context, newCode);
  }

  void _updateState(Locale locale) {
    final languageData = supportedLanguages.firstWhere(
      (lang) => lang['code'] == locale.languageCode,
      orElse: () => supportedLanguages.first,
    );

    emit(LanguageState(
      locale: locale,
      languageName: languageData['nativeName'],
    ));
  }

  bool get isRTL => state.locale.languageCode == 'ar';
  String get currentLanguageCode => state.locale.languageCode;
  String get currentLanguageName => state.languageName;
}
