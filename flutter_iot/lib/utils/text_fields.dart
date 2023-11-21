import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final Icon textFieldIcon;
  final onChanged;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    required this.textFieldIcon,
    required this.onChanged
  });

  @override
    Widget build(BuildContext context) {
      return TextField(
        controller: controller,
        maxLength: 50,
        decoration: InputDecoration(
          prefixIcon: textFieldIcon,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.green.shade300,
              width: 2
            ),
          ),
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          prefixIconColor: Colors.green.shade300,
        ),
        obscureText: obscureText,
        cursorColor: Colors.black,
        onChanged: onChanged,
      );
    }
}

