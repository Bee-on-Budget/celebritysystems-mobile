import 'package:celebritysystems_mobile/core/widgets/custom_text_field.dart';
import 'package:celebritysystems_mobile/features/login/logic/login%20cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailAndPassword extends StatefulWidget {
  const EmailAndPassword({super.key});

  @override
  State<EmailAndPassword> createState() => _EmailAndPasswordState();
}

class _EmailAndPasswordState extends State<EmailAndPassword> {
  bool isObsecure = true;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    passwordController = context.read<LoginCubit>().passwordController;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<LoginCubit>().formKey,
      child: Column(
        children: [
          // Email Input
          CustomTextField(
            label: "Email",
            icon: Icons.email_outlined,
            controller: context.read<LoginCubit>().emailController,
          ),
          const SizedBox(height: 20),

          // Password Input
          CustomTextField(
            label: "Password",
            icon: Icons.lock_outline,
            isPassword: true,
            obscureText: isObsecure,
            toggleObscure: () {
              setState(() => isObsecure = !isObsecure);
              // isObsecure = !isObsecure;
            },
            controller: context.read<LoginCubit>().passwordController,
          ),

          // Forgot Password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text("Forgot Password?"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }
}
