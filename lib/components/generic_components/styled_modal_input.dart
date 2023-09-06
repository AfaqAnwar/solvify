import 'package:flutter/material.dart';
import 'package:solvify/components/generic_components/input_textfield.dart';
import 'package:solvify/components/generic_components/styled_modal_button.dart';
import 'package:solvify/styles/app_style.dart';

class StyledModalInput extends StatelessWidget {
  final Function()? onTap;
  final Color backgroundColor;
  final String title;
  final String body;
  final String? buttonText;
  final InputTextField inputTextField;

  const StyledModalInput(
      {super.key,
      required this.backgroundColor,
      required this.title,
      required this.body,
      required this.onTap,
      this.buttonText,
      required this.inputTextField});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: ShapeBorder.lerp(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            1)!,
        backgroundColor: backgroundColor,
        content: SingleChildScrollView(
          child: ListBody(children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: AppStyle.currentMainHeadingFont.fontFamily,
                fontSize: 18,
                color: AppStyle.faqTextHeading,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Text(
                  body,
                  style:
                      TextStyle(color: AppStyle.getTextColor(), fontSize: 14),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            inputTextField,
            const SizedBox(
              height: 15,
            ),
            StyledModalButton(
                onTap: () {
                  onTap!();
                },
                buttonColor: AppStyle.getAccent(),
                buttonText: buttonText ?? 'Okay',
                buttonTextColor: Colors.white)
          ]),
        ));
  }
}
