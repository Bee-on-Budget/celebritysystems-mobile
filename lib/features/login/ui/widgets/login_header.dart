import 'package:celebritysystems_mobile/core/theming/colors.dart';
import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 30),
          Image.asset(
            'assets/images/logo.png',
            height: 80,
          ),
          const SizedBox(height: 16),
          Text(
            "Welcome Back",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: ColorsManager.graphiteBlack,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
