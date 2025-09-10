import 'package:celebritysystems_mobile/core/language_cubit/language_cubit.dart';
import 'package:celebritysystems_mobile/core/language_cubit/language_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/routing/routes.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../features/login/logic/user cubit/user_cubit.dart';

companyHomeAppBar(
  BuildContext context,
  Color backgroundColor,
  void Function(VoidCallback fn) setState,
) {
  Future<void> handleLogout() async {
    final userCubit = context.read<UserCubit>();

    final user = context.read<UserCubit>().state;
    // Clear user state
    userCubit.logout(user!.userId!);

    // Navigate to login screen
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.loginScreen,
        (route) => false,
      );
    }
  }

  return AppBar(
    title: Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.home_max_outlined,
            color: Colors.white,
            size: 24,
          ),
        ),
        SizedBox(width: 12),
        Text(
          'tickets_page'.tr(),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    ),
    backgroundColor: Colors.transparent,
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorsManager.royalIndigo,
            ColorsManager.coralBlaze,
          ],
        ),
      ),
    ),
    foregroundColor: Colors.white,
    elevation: 0,
    automaticallyImplyLeading: false,
    actions: [
      BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, state) {
          return IconButton(
            icon: Icon(
              Icons.translate,
            ),
            onPressed: () {
              context.read<LanguageCubit>().toggleLanguage(context);
              // context.read<LanguageCubit>().changeLanguage(context, "an");
              setState(() {});
            },
            tooltip: 'Switch to English',
          );
        },
      ),
      IconButton(
        icon: const Icon(
          Icons.logout,
          color: Colors.white,
        ),
        onPressed: () async {
          final shouldLogout = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('logout'.tr()),
              content: Text('are_you_sure_you_want_to_logout'.tr()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('no'.tr()),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('yes'.tr()),
                ),
              ],
            ),
          );
          if (shouldLogout ?? false) {
            await handleLogout();
          }
        },
        tooltip: 'logout'.tr(),
      ),
    ],
  );
}
