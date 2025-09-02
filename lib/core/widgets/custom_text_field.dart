import 'package:celebritysystems_mobile/core/theming/colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPassword;
  final TextEditingController controller;
  final VoidCallback? toggleObscure;
  final bool obscureText;
  final String? Function(String?)? validator; // Make this a proper field

  const CustomTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.isPassword = false,
    this.toggleObscure,
    this.obscureText = false,
    this.validator, // Add validator to constructor
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // Change from TextField to TextFormField
      controller: controller,
      obscureText: isPassword ? obscureText : false,
      validator: validator, // Use the validator
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: toggleObscure,
              )
            : null,
        filled: true,
        fillColor: ColorsManager.paleLavenderBlue,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: ColorsManager.slateGray),
      ),
    );
  }
}

// import 'package:celebritysystems_mobile/core/theming/colors.dart';
// import 'package:flutter/material.dart';

// class CustomTextField extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final bool isPassword;
//   final TextEditingController controller;
//   final VoidCallback? toggleObscure;
//   final bool obscureText;

//   const CustomTextField({
//     super.key,
//     required this.label,
//     required this.icon,
//     required this.controller,
//     this.isPassword = false,
//     this.toggleObscure,
//     this.obscureText = false,
//     String? Function(dynamic value)? validator,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       obscureText: isPassword ? obscureText : false,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon),
//         suffixIcon: isPassword
//             ? IconButton(
//                 icon: Icon(
//                   obscureText ? Icons.visibility_off : Icons.visibility,
//                 ),
//                 onPressed: toggleObscure,
//               )
//             : null,
//         filled: true,
//         fillColor: ColorsManager.paleLavenderBlue,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//         hintStyle: const TextStyle(color: ColorsManager.slateGray),
//       ),
//     );
//   }
// }
