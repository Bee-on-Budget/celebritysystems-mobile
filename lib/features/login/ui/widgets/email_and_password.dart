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

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../core/theming/colors.dart';
// import '../../logic/login cubit/login_cubit.dart';

// class EmailAndPassword extends StatefulWidget {
//   const EmailAndPassword({super.key});

//   @override
//   State<EmailAndPassword> createState() => _EmailAndPasswordState();
// }

// class _EmailAndPasswordState extends State<EmailAndPassword>
//     with TickerProviderStateMixin {
//   bool isObscure = true;
//   late TextEditingController passwordController;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     passwordController = context.read<LoginCubit>().passwordController;

//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );

//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     ));

//     _animationController.forward();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FadeTransition(
//       opacity: _fadeAnimation,
//       child: Form(
//         key: context.read<LoginCubit>().formKey,
//         child: Column(
//           children: [
//             // Enhanced Email Input
//             _buildEnhancedTextField(
//               label: "Email Address",
//               icon: Icons.email_outlined,
//               controller: context.read<LoginCubit>().emailController,
//               isPassword: false,
//             ),

//             const SizedBox(height: 24),

//             // Enhanced Password Input
//             _buildEnhancedTextField(
//               label: "Password",
//               icon: Icons.lock_outline,
//               controller: context.read<LoginCubit>().passwordController,
//               isPassword: true,
//               obscureText: isObscure,
//               toggleObscure: () {
//                 setState(() => isObscure = !isObscure);
//               },
//             ),

//             const SizedBox(height: 16),

//             // Enhanced Forgot Password
//             Align(
//               alignment: Alignment.centerRight,
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: TextButton(
//                   onPressed: () {},
//                   style: TextButton.styleFrom(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: Text(
//                     "Forgot Password?",
//                     style: TextStyle(
//                       color: ColorsManager.royalIndigo,
//                       fontWeight: FontWeight.w500,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEnhancedTextField({
//     required String label,
//     required IconData icon,
//     required TextEditingController controller,
//     required bool isPassword,
//     bool obscureText = false,
//     VoidCallback? toggleObscure,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: Colors.grey.shade200,
//           width: 1.5,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: TextFormField(
//         controller: controller,
//         obscureText: isPassword ? obscureText : false,
//         decoration: InputDecoration(
//           labelText: label,
//           labelStyle: TextStyle(
//             color: Colors.grey.shade600,
//             fontWeight: FontWeight.w500,
//           ),
//           prefixIcon: Container(
//             margin: const EdgeInsets.all(12),
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: ColorsManager.royalIndigo.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(
//               icon,
//               color: ColorsManager.royalIndigo,
//               size: 20,
//             ),
//           ),
//           suffixIcon: isPassword
//               ? IconButton(
//                   onPressed: toggleObscure,
//                   icon: AnimatedSwitcher(
//                     duration: const Duration(milliseconds: 200),
//                     child: Icon(
//                       obscureText ? Icons.visibility_off : Icons.visibility,
//                       key: ValueKey(obscureText),
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                 )
//               : null,
//           border: InputBorder.none,
//           enabledBorder: InputBorder.none,
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//             borderSide: BorderSide(
//               color: ColorsManager.royalIndigo,
//               width: 2,
//             ),
//           ),
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//         ),
//         style: TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w500,
//           color: ColorsManager.graphiteBlack,
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }
// }
