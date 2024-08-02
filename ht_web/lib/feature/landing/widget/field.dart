import 'package:flutter/material.dart';

class Field extends StatelessWidget {
  const Field({
    super.key,
    required this.controller,
    required this.label,
    this.isPassword = false,
    this.validator,
  });
  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Material(
        child: TextFormField(
          obscureText: isPassword,
          keyboardType: TextInputType.emailAddress,
          controller: controller,
          decoration: InputDecoration(
            hintText: label,
          ),
          validator: validator ?? callback(),
        ),
      ),
    );
  }

  String? Function(String?) callback() {
    if (isPassword) {
      return (v) {
        if (v == null || v.isEmpty) {
          return 'Required';
        } 
        return null;
      };
    }
    return (value) {
      if (value == null || value.isEmpty) {
        return 'Required';
      }
      if (!value.contains('@')) {
        return 'Invalid Email';
      }
      return null;
    };
  }
}
