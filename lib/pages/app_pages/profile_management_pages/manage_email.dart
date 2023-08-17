import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solvify/components/app_components/custom_scaffold.dart';
import 'package:solvify/components/generic_components/input_textfield.dart';
import 'package:solvify/components/generic_components/styled_button.dart';
import 'package:solvify/styles/app_style.dart';

class ManageEmail extends StatefulWidget {
  const ManageEmail({super.key});

  @override
  State<ManageEmail> createState() => _ManageEmailState();
}

class _ManageEmailState extends State<ManageEmail> {
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        hideDrawer: true,
        iconData: Icons.arrow_back_ios_new_sharp,
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                Text(
                  "Manage Email",
                  style: TextStyle(
                      fontFamily: GoogleFonts.karla().fontFamily,
                      color: AppStyle.primaryAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                InputTextField(
                  controller: emailController,
                  hintText: "New Email",
                  obscureText: false,
                  textFieldBackgroundColor: AppStyle.secondaryBackground,
                  textFieldHintTextColor: AppStyle.getTextFieldHintColor(),
                  textFieldTextColor: AppStyle.getTextFieldTextColor(),
                  textFieldBorderColor: Colors.grey.shade400,
                  textFieldBorderFocusColor: AppStyle.primaryAccent,
                ),
                const Spacer(),
                StyledButton(
                  onTap: () {},
                  buttonColor: AppStyle.primaryAccent,
                  buttonText: "Change Email",
                  buttonTextColor: Colors.white,
                ),
                const SizedBox(
                  height: 25,
                )
              ],
            ),
          ),
        ));
  }
}
