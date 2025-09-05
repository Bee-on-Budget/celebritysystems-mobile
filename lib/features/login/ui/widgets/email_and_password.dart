import 'package:celebritysystems_mobile/core/helpers/app_regex.dart';
import 'package:celebritysystems_mobile/core/widgets/custom_text_field.dart';
import 'package:celebritysystems_mobile/features/login/logic/login%20cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

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
            label: "email".tr(),
            icon: Icons.email_outlined,
            controller: context.read<LoginCubit>().emailController,
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  !AppRegex.isEmailValid(value)) {
                return 'please_enter_a_valid_email'.tr();
              }
              return null; // Return null if validation passes
            },
          ),
          const SizedBox(height: 20),

          // Password Input
          CustomTextField(
            label: "password".tr(),
            icon: Icons.lock_outline,
            isPassword: true,
            obscureText: isObsecure,
            toggleObscure: () {
              setState(() => isObsecure = !isObsecure);
            },
            controller: context.read<LoginCubit>().passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'please_enter_a_password'.tr();
              }
              // Add more password validation rules as needed
              return null;
            },
          ),
          const SizedBox(
            height: 24,
          )

          // Forgot Password
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: TextButton(
          //     onPressed: () {},
          //     child: const Text("Forgot Password?"),
          //   ),
          // ),
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

// import 'package:celebritysystems_mobile/core/helpers/app_regex.dart';
// import 'package:celebritysystems_mobile/core/widgets/custom_text_field.dart';
// import 'package:celebritysystems_mobile/features/login/logic/login%20cubit/login_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class EmailAndPassword extends StatefulWidget {
//   const EmailAndPassword({super.key});

//   @override
//   State<EmailAndPassword> createState() => _EmailAndPasswordState();
// }

// class _EmailAndPasswordState extends State<EmailAndPassword> {
//   bool isObsecure = true;
//   late TextEditingController passwordController;

//   @override
//   void initState() {
//     super.initState();
//     passwordController = context.read<LoginCubit>().passwordController;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: context.read<LoginCubit>().formKey,
//       child: Column(
//         children: [
//           // Email Input
//           CustomTextField(
//             label: "email".tr(),
//             icon: Icons.email_outlined,
//             controller: context.read<LoginCubit>().emailController,
//             validator: (value) {
//               setState(() {});
//               if (value == null ||
//                   value.isEmpty ||
//                   !AppRegex.isEmailValid(value)) {
//                 return 'please_enter_a_valid_email'.tr();
//               }
//             },
//           ),
//           const SizedBox(height: 20),

//           // Password Input
//           CustomTextField(
//             label: "password".tr(),
//             icon: Icons.lock_outline,
//             isPassword: true,
//             obscureText: isObsecure,
//             toggleObscure: () {
//               setState(() => isObsecure = !isObsecure);
//               // isObsecure = !isObsecure;
//             },
//             controller: context.read<LoginCubit>().passwordController,
//           ),
//           const SizedBox(
//             height: 24,
//           )

//           // Forgot Password
//           // Align(
//           //   alignment: Alignment.centerRight,
//           //   child: TextButton(
//           //     onPressed: () {},
//           //     child: const Text("Forgot Password?"),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     passwordController.dispose();
//     super.dispose();
//   }
// }
