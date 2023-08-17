// ignore: avoid_web_libraries_in_flutter
import 'dart:js_util';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solvify/components/app_components/custom_scaffold.dart';
import 'package:solvify/components/generic_components/input_textfield.dart';
import 'package:solvify/components/generic_components/styled_button.dart';
import 'package:solvify/components/generic_components/styled_modal.dart';
import 'package:solvify/firebase_js.dart';
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

  bool checkFieldsEmpty() {
    if (newPasswordController.text.trim().toString().isEmpty ||
        confirmNewPasswordController.text.trim().toString().isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool checkPasswordsMatch() {
    if (newPasswordController.text.trim().toString() ==
        confirmNewPasswordController.text.trim().toString()) {
      return true;
    } else {
      return false;
    }
  }

  void displayError(String errorMessage) {
    switch (errorMessage) {
      case "empty-fields":
        errorMessage = "Please fill out all fields.";
        break;
      case "weak-password":
        errorMessage = "Your password is too weak.";
        break;
      case "passwords-dont-match":
        errorMessage = "Your passwords don't match.";
        break;
      default:
        errorMessage = "An undefined error happened - $errorMessage";
    }
    showDialog(
        context: context,
        builder: (context) => StyledModal(
              backgroundColor: AppStyle.secondaryBackground,
              title: 'Password Error',
              body: errorMessage.toString(),
              onTap: () => Navigator.pop(context),
            ));
  }

  void displayLoad() {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(color: AppStyle.primaryAccent),
          );
        });
  }

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
                  hintText: "Confirm New Password",
                  obscureText: true,
                  textFieldBackgroundColor: AppStyle.secondaryBackground,
                  textFieldHintTextColor: AppStyle.getTextFieldHintColor(),
                  textFieldTextColor: AppStyle.getTextFieldTextColor(),
                  textFieldBorderColor: Colors.grey.shade400,
                  textFieldBorderFocusColor: AppStyle.primaryAccent,
                ),
                const Spacer(),
                StyledButton(
                  onTap: () async {
                    if (checkFieldsEmpty() == false) {
                      displayError("empty-fields");
                    } else if (checkPasswordsMatch() == false) {
                      displayError("passwords-dont-match");
                    } else {
                      displayLoad();

                      dynamic result = await promiseToFuture(updateUserPassword(
                          newPasswordController.text.trim().toString()));

                      var state = js.JsObject.fromBrowserObject(
                          js.context['userState']);

                      if (result == true) {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          String successMessage =
                              "Your password has successfully been changed.";
                          showDialog(
                              context: context,
                              builder: (context) => StyledModal(
                                    backgroundColor: AppStyle.primaryBackground,
                                    title: 'Password Successfully Changed',
                                    body: successMessage.toString(),
                                    onTap: () => Navigator.pop(context),
                                  ));
                        });
                      } else {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          Navigator.pop(context);
                          String errorMessage =
                              state['error'].toString().replaceAll("auth/", "");
                          displayError(errorMessage);
                        });
                      }
                    }
                  },
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
