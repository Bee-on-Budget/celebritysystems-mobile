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
        child: SingleChildScrollView(
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
                // PrimaryButton(
                //   text: "Login",
                //   onPressed: () {
                //     // Handle login
                //     context.read<LoginCubit>().emitLoginStates();
                //   },
                // ),

                // Enhanced Login Button with gradient
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ColorsManager.coralBlaze,
                        // ColorsManager.coralBlaze,
                        ColorsManager.deepCharcoal,
                        // Colors.blue.shade600,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: ColorsManager.royalIndigo.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        context.read<LoginCubit>().emitLoginStates();
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const LoginBlocListener(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:celebritysystems_mobile/core/theming/colors.dart';
// import 'package:celebritysystems_mobile/features/login/logic/login%20cubit/login_cubit.dart';
// import 'package:celebritysystems_mobile/features/login/ui/widgets/email_and_password.dart';
// import 'package:celebritysystems_mobile/features/login/ui/widgets/login_bloc_listener.dart';
// import 'package:celebritysystems_mobile/features/login/ui/widgets/login_header.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               ColorsManager.mistWhite,
//               Colors.blue.shade50,
//               Colors.purple.shade50,
//             ],
//             stops: const [0.0, 0.6, 1.0],
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 20),
//                   // Animated Container with shadow for the main content
//                   AnimatedContainer(
//                     duration: const Duration(milliseconds: 800),
//                     curve: Curves.easeOutBack,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(24),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 20,
//                             offset: const Offset(0, 8),
//                             spreadRadius: -5,
//                           ),
//                           BoxShadow(
//                             color: Colors.blue.withOpacity(0.05),
//                             blurRadius: 40,
//                             offset: const Offset(0, 20),
//                             spreadRadius: -10,
//                           ),
//                         ],
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(32.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Enhanced Header
//                             const LoginHeader(),
//                             const SizedBox(height: 40),

//                             // Form with enhanced styling
//                             Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(16),
//                                 color: Colors.grey.shade50,
//                               ),
//                               padding: const EdgeInsets.all(20),
//                               child: const EmailAndPassword(),
//                             ),

//                             const SizedBox(height: 32),

//                             // Enhanced Login Button with gradient
//                             Container(
//                               width: double.infinity,
//                               height: 56,
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     ColorsManager.royalIndigo,
//                                     Colors.blue.shade600,
//                                   ],
//                                 ),
//                                 borderRadius: BorderRadius.circular(16),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: ColorsManager.royalIndigo
//                                         .withOpacity(0.3),
//                                     blurRadius: 12,
//                                     offset: const Offset(0, 6),
//                                   ),
//                                 ],
//                               ),
//                               child: Material(
//                                 color: Colors.transparent,
//                                 child: InkWell(
//                                   onTap: () {
//                                     context
//                                         .read<LoginCubit>()
//                                         .emitLoginStates();
//                                   },
//                                   borderRadius: BorderRadius.circular(16),
//                                   child: Container(
//                                     alignment: Alignment.center,
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         const Text(
//                                           "Login",
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.w600,
//                                             letterSpacing: 0.5,
//                                           ),
//                                         ),
//                                         const SizedBox(width: 8),
//                                         Icon(
//                                           Icons.arrow_forward_rounded,
//                                           color: Colors.white,
//                                           size: 20,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   // Floating decorative elements
//                   Positioned(
//                     child: Container(
//                       alignment: Alignment.center,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             width: 40,
//                             height: 2,
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   Colors.transparent,
//                                   Colors.grey.shade300,
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 16),
//                             child: Text(
//                               "Secure Login",
//                               style: TextStyle(
//                                 color: Colors.grey.shade500,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                           Container(
//                             width: 40,
//                             height: 2,
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   Colors.grey.shade300,
//                                   Colors.transparent,
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   const LoginBlocListener(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
