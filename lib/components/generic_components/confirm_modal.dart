import 'package:flutter/material.dart';
import 'package:solvify/components/generic_components/styled_modal_button.dart';
import 'package:solvify/styles/app_style.dart';

class ConfirmModal extends StatelessWidget {
  final Function()? onYesTap;
  final Function()? onNoTap;
  final Color backgroundColor;
  final String title;
  final String body;

  const ConfirmModal(
      {super.key,
      required this.backgroundColor,
      required this.title,
      required this.body,
      required this.onYesTap,
      required this.onNoTap});

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: StyledModalButton(
                      margin: 5,
                      onTap: () {
                        onYesTap!();
                      },
                      buttonColor: AppStyle.primaryError,
                      buttonText: "Yes",
                      buttonTextColor: Colors.white),
                ),
                Expanded(
                  child: StyledModalButton(
                      margin: 5,
                      onTap: () {
                        onNoTap!();
                      },
                      buttonColor: AppStyle.getAccent(),
                      buttonText: "No",
                      buttonTextColor: Colors.white),
                ),
              ],
            )
          ]),
        ));
  }
}
