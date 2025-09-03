import 'package:celebritysystems_mobile/core/language_cubit/language_cubit.dart';
import 'package:celebritysystems_mobile/core/language_cubit/language_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'language'.tr(),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),

            BlocBuilder<LanguageCubit, LanguageState>(
              builder: (context, state) {
                return Column(
                  children: LanguageCubit.supportedLanguages.map((language) {
                    return RadioListTile<String>(
                      title: Text(language['nativeName']),
                      subtitle: Text(language['name']),
                      value: language['code'],
                      groupValue: state.locale.languageCode,
                      onChanged: (value) {
                        if (value != null) {
                          context
                              .read<LanguageCubit>()
                              .changeLanguage(context, value);
                        }
                      },
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 32),

            // Quick toggle button
            BlocBuilder<LanguageCubit, LanguageState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    context.read<LanguageCubit>().toggleLanguage(context);
                  },
                  child: Text(
                    state.locale.languageCode == 'en'
                        ? 'Switch to Arabic'
                        : 'التبديل إلى الإنجليزية',
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
