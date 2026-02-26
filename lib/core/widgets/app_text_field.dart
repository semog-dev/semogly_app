import 'package:flutter/material.dart';
import 'package:semogly_app/core/theme/app_styles.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool isPassword;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: AppStyles.textPrimary),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppStyles.surface,
        hintText: hint,
        hintStyle: const TextStyle(color: AppStyles.textSecondary),
        prefixIcon: Icon(icon, color: AppStyles.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppStyles.primary, width: 2),
        ),
      ),
    );
  }
}
