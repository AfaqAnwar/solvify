import 'package:flutter/material.dart';

class StyledModalButton extends StatelessWidget {
  final Function()? onTap;
  final Color buttonColor;
  final String buttonText;
  final Color buttonTextColor;
  final double? margin;

  const StyledModalButton(
      {super.key,
      required this.onTap,
      required this.buttonColor,
      required this.buttonText,
      required this.buttonTextColor,
      this.margin});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: EdgeInsets.symmetric(horizontal: margin ?? 25),
          decoration: BoxDecoration(
              color: buttonColor, borderRadius: BorderRadius.circular(8)),
          child: Center(
              child: Text(
            buttonText,
            style: TextStyle(
                color: buttonTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          )),
        ),
      ),
    );
  }
}
