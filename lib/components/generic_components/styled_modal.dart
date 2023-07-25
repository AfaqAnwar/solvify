import 'package:flutter/material.dart';
import 'package:solvify/components/generic_components/styled_modal_button.dart';
import 'package:solvify/styles/app_style.dart';

class StyledModal extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  final String body;

  const StyledModal(
      {super.key,
      required this.backgroundColor,
      required this.title,
      required this.body});

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
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
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
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            StyledModalButton(
                onTap: () {
                  Navigator.pop(context);
                },
                buttonColor: AppStyle.primaryDarkAccent,
                buttonText: "Okay",
                buttonTextColor: Colors.white)
          ]),
        ));
  }
}
