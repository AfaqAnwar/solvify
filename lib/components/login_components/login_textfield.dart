import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final controller;
  final String hintText;
  final bool obscureText;
  final Color textFieldBackgroundColor;
  final Color textFieldHintTextColor;
  final Color textFieldTextColor;
  final Color textFieldBorderColor;
  final Color textFieldBorderFocusColor;

  const LoginTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      required this.textFieldBackgroundColor,
      required this.textFieldHintTextColor,
      required this.textFieldTextColor,
      required this.textFieldBorderColor,
      required this.textFieldBorderFocusColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            fillColor: textFieldBackgroundColor,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: textFieldHintTextColor),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: textFieldBorderColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: textFieldBorderFocusColor))),
      ),
    );
  }
}
