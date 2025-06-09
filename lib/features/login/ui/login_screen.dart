import 'package:celebritysystems_mobile/core/theming/colors.dart';
import 'package:celebritysystems_mobile/core/widgets/custom_text_field.dart';
import 'package:celebritysystems_mobile/core/widgets/primary_button.dart';
import 'package:celebritysystems_mobile/features/login/ui/widgets/login_header.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscureText = true;

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

              // Email Input
              CustomTextField(
                label: "Email",
                icon: Icons.email_outlined,
                controller: _emailController,
              ),
              const SizedBox(height: 20),

              // Password Input
              CustomTextField(
                label: "Password",
                icon: Icons.lock_outline,
                isPassword: true,
                obscureText: _obscureText,
                toggleObscure: () {
                  setState(() => _obscureText = !_obscureText);
                },
                controller: _passwordController,
              ),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Forgot Password?"),
                ),
              ),
              const SizedBox(height: 20),

              // Login Button
              PrimaryButton(
                text: "Login",
                onPressed: () {
                  // Handle login
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
