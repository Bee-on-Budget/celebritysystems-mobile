import 'package:celebritysystems_mobile/core/theming/colors.dart';
import 'package:celebritysystems_mobile/core/widgets/primary_button.dart';
import 'package:celebritysystems_mobile/features/login/logic/login%20cubit/login_cubit.dart';
import 'package:celebritysystems_mobile/features/login/ui/widgets/email_and_password.dart';
import 'package:celebritysystems_mobile/features/login/ui/widgets/login_bloc_listener.dart';
import 'package:celebritysystems_mobile/features/login/ui/widgets/login_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.mistWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo/Header
              LoginHeader(),
              const SizedBox(height: 40),
              EmailAndPassword(),
              const SizedBox(height: 20),

              // Login Button
              PrimaryButton(
                text: "Login",
                onPressed: () {
                  // Handle login
                  context.read<LoginCubit>().emitLoginStates();
                },
              ),
              const LoginBlocListener(),
            ],
          ),
        ),
      ),
    );
  }
}
