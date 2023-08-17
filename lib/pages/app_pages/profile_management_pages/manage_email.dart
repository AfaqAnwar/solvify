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

class ManageEmail extends StatefulWidget {
  const ManageEmail({super.key});

  @override
  State<ManageEmail> createState() => _ManageEmailState();
}

class _ManageEmailState extends State<ManageEmail> {
  final emailController = TextEditingController();

  bool checkFieldsEmpty() {
    if (emailController.text.trim().toString().isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void displayError(String errorMessage) {
    switch (errorMessage) {
      case "empty-fields":
        errorMessage = "Please fill out both your email and password.";
        break;
      case "email-already-in-use":
        errorMessage = "This email is already in use.";
        break;
      case "invalid-email":
        errorMessage = "This email is invalid.";
        break;
      default:
        errorMessage = "An undefined error happened - $errorMessage";
    }
    showDialog(
        context: context,
        builder: (context) => StyledModal(
              backgroundColor: AppStyle.secondaryBackground,
              title: 'Email Error',
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
                  onTap: () async {
                    if (checkFieldsEmpty() == false) {
                      displayError("empty-fields");
                    } else {
                      displayLoad();

                      dynamic result = await promiseToFuture(updateUserEmail(
                          emailController.text.trim().toString()));

                      var state = js.JsObject.fromBrowserObject(
                          js.context['userState']);

                      if (result == true) {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          String successMessage =
                              "Your email has been changed to ${state['email']}";
                          showDialog(
                              context: context,
                              builder: (context) => StyledModal(
                                    backgroundColor: AppStyle.primaryBackground,
                                    title: 'Email Successfully Changed',
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
