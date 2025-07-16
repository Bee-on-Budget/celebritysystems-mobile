import 'package:celebritysystems_mobile/core/theming/colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorsManager.mistWhite,
        appBar: AppBar(
          title: const Text("  My Tickets"),
          backgroundColor: ColorsManager.coralBlaze,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Center(
          child: Text("data"),
        ));
  }
}
