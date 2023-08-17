import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solvify/components/app_components/custom_scaffold.dart';
import 'package:solvify/components/generic_components/input_textfield.dart';
import 'package:solvify/components/generic_components/styled_button.dart';
import 'package:solvify/styles/app_style.dart';

class ManagePassword extends StatefulWidget {
  const ManagePassword({super.key});

  @override
  State<ManagePassword> createState() => _ManagePasswordState();
}

class _ManagePasswordState extends State<ManagePassword> {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

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
                  "Manage Password",
                  style: TextStyle(
                      fontFamily: GoogleFonts.karla().fontFamily,
                      color: AppStyle.primaryAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                InputTextField(
                  controller: currentPasswordController,
                  hintText: "Current Password",
                  obscureText: true,
                  textFieldBackgroundColor: AppStyle.secondaryBackground,
                  textFieldHintTextColor: AppStyle.getTextFieldHintColor(),
                  textFieldTextColor: AppStyle.getTextFieldTextColor(),
                  textFieldBorderColor: Colors.grey.shade400,
                  textFieldBorderFocusColor: AppStyle.primaryAccent,
                ),
                const SizedBox(
                  height: 20,
                ),
                InputTextField(
                  controller: newPasswordController,
                  hintText: "New Password",
                  obscureText: true,
                  textFieldBackgroundColor: AppStyle.secondaryBackground,
                  textFieldHintTextColor: AppStyle.getTextFieldHintColor(),
                  textFieldTextColor: AppStyle.getTextFieldTextColor(),
                  textFieldBorderColor: Colors.grey.shade400,
                  textFieldBorderFocusColor: AppStyle.primaryAccent,
                ),
                const SizedBox(
                  height: 10,
                ),
                InputTextField(
                  controller: confirmNewPasswordController,
                  hintText: "New Password",
                  obscureText: true,
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
                  buttonText: "Change Password",
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
