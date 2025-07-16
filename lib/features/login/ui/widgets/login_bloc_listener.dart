import 'package:celebritysystems_mobile/core/helpers/constants.dart';
import 'package:celebritysystems_mobile/core/helpers/extenstions.dart';
import 'package:celebritysystems_mobile/core/helpers/shared_pref_helper.dart';
import 'package:celebritysystems_mobile/core/routing/routes.dart';
import 'package:celebritysystems_mobile/core/theming/colors.dart';
import 'package:celebritysystems_mobile/features/login/logic/login%20cubit/login_cubit.dart';
import 'package:celebritysystems_mobile/features/login/logic/login%20cubit/login_state.dart';
import 'package:celebritysystems_mobile/features/login/logic/user%20cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBlocListener extends StatelessWidget {
  const LoginBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (previous, current) => switch (current) {
        Loading() || Success() || Error() => true,
        _ => false,
      },
      listener: (context, state) async {
        switch (state) {
          case Loading():
            showDialog(
              context: context,
              builder: (context) => const Center(
                child: CircularProgressIndicator(
                  color: ColorsManager.royalIndigo,
                ),
              ),
            );
            break;

          case Success():
            print(
                "********************   LoginBlocListener   *****************************");
            final token = await SharedPrefHelper.getSecuredString(
                SharedPrefKeys.userToken);
            await context.read<UserCubit>().loadUserFromToken(token ?? '');

            final user = context.read<UserCubit>().state;

            if (user == null || !user.isAllowed) {
              context.pop(); // remove loading dialog if it's shown

              //delete cash
              await SharedPrefHelper.clearAllData();
              await SharedPrefHelper.clearAllSecuredData();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Access Denied"),
                  content:
                      const Text("You are not authorized to access this app."),
                  actions: [
                    TextButton(
                      onPressed: () => context.pop(),
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );

              return; // stop here, don't navigate
            }

            // Allowed roles - go to home
            context.pop(); // remove loading dialog
            context.pushReplacementNamed(Routes.homeScreen);
            break;

          case Error(:final error):
            setupErrorState(context, error);
            break;

          default:
            break;
        }
      },
      child: const SizedBox.shrink(),
    );
  }

  void setupErrorState(BuildContext context, String error) {
    context.pop(); // remove loading dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.error,
          color: Colors.red,
          size: 32,
        ),
        content: Text(
          error,
          // style: TextStyles.font15DarkBlueMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: Text(
              'Got it',
              // style: TextStyles.font14BlueSemiBold,
            ),
          )
        ],
      ),
    );
  }
}
