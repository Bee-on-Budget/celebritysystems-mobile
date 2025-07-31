import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/routing/routes.dart';
import '../../../../../features/login/logic/user cubit/user_cubit.dart';

companyHomeAppBar(
  BuildContext context,
  Color backgroundColor,
) {

  Future<void> handleLogout() async {
    final userCubit = context.read<UserCubit>();

    // Clear user state
    userCubit.logout();

    // Navigate to login screen
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.loginScreen,
            (route) => false,
      );
    }
  }
  return AppBar(
    title: Text("Welcome Again"),
    backgroundColor: backgroundColor,
    foregroundColor: Colors.white,
    elevation: 0,
    actions: [
      IconButton(
        icon: const Icon(
          Icons.logout,
          color: Colors.white,
        ),
        onPressed: () async {
          final shouldLogout = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes'),
                ),
              ],
            ),
          );
          if (shouldLogout ?? false) {
            await handleLogout();
          }
        },
        tooltip: 'Logout',
      ),
    ],
  );
}
