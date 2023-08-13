import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StyledButton extends StatelessWidget {
  final Function()? onTap;
  final Color buttonColor;
  final String buttonText;
  final Color buttonTextColor;

  const StyledButton(
      {super.key,
      required this.onTap,
      required this.buttonColor,
      required this.buttonText,
      required this.buttonTextColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
            color: buttonColor, borderRadius: BorderRadius.circular(8)),
        child: Center(
            child: Text(
          buttonText,
          style: TextStyle(
              color: buttonTextColor,
              fontWeight: FontWeight.w900,
              fontSize: 16),
        )),
      ),
    );
  }
}
