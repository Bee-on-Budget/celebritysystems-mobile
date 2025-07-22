// import 'package:celebritysystems_mobile/core/theming/colors.dart';
// import 'package:flutter/material.dart';

// class LoginHeader extends StatelessWidget {
//   const LoginHeader({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         children: [
//           const SizedBox(height: 30),
//           Image.asset(
//             'assets/images/logo.png',
//             height: 80,
//           ),
//           const SizedBox(height: 16),
//           Text(
//             "Welcome Back",
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: ColorsManager.graphiteBlack,
//             ),
//           ),
//           const SizedBox(height: 8),
//         ],
//       ),
//     );
//   }
// }

import 'package:celebritysystems_mobile/core/theming/colors.dart';
import 'package:flutter/material.dart';

class LoginHeader extends StatefulWidget {
  const LoginHeader({super.key});

  @override
  State<LoginHeader> createState() => _LoginHeaderState();
}

class _LoginHeaderState extends State<LoginHeader>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _slideController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Animated Logo with pulse effect
            ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: ColorsManager.royalIndigo.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 60,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Enhanced welcome text with gradient
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  ColorsManager.graphiteBlack,
                  ColorsManager.coralBlaze,
                ],
              ).createShader(bounds),
              child: Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Sign in to continue",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }
}
