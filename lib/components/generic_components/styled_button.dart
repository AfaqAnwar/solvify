import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:flutter/src/services/mouse_cursor.dart';

class StyledButton extends StatelessWidget {
  final Function()? onTap;
  final Color buttonColor;
  final String buttonText;
  final Color buttonTextColor;
  final double? margin;
  final bool? disable;

  const StyledButton(
      {super.key,
      required this.onTap,
      required this.buttonColor,
      required this.buttonText,
      required this.buttonTextColor,
      this.margin,
      this.disable});

  @override
  Widget build(BuildContext context) {
    SystemMouseCursor cursor;
    if (disable != null && disable == true) {
      cursor = SystemMouseCursors.basic;
    } else {
      cursor = SystemMouseCursors.click;
    }

    return MouseRegion(
      cursor: cursor,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(15),
          margin: EdgeInsets.symmetric(horizontal: margin ?? 25),
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
      ),
    );
  }
}
