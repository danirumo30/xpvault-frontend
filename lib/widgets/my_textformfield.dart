import 'package:flutter/material.dart';
import 'package:xpvault/themes/app_color.dart';

class MyTextformfield extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController? textEditingController;
  final String? Function(String?)? validator;
  
  const MyTextformfield({super.key, required this.hintText, required this.obscureText, this.suffixIcon, this.textEditingController, this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        controller: textEditingController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.border)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)
          ),
          filled: true,
          fillColor: AppColors.background,
          hintStyle: TextStyle(
            color: AppColors.textMuted
          ),
          errorStyle: TextStyle(
            color: AppColors.error,
            fontSize: 13
          ),
          hintText: hintText,
          suffixIcon: suffixIcon
        ),
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20
        ),
        obscureText: obscureText,
        validator: validator,
      ),
    );
  }
}