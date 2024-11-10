import 'package:flutter/material.dart';

class CTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData prefixIcon;
  final bool obscureText;

  const CTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        prefixIcon: Icon(prefixIcon),
      ),
    );
  }
}
