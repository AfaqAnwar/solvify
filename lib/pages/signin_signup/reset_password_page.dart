// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
// ignore: avoid_web_libraries_in_flutter
import 'dart:js_util';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'package:solvify/components/generic_components/input_textfield.dart';
import 'package:solvify/components/generic_components/styled_button.dart';
import 'package:solvify/components/generic_components/styled_modal.dart';
import 'package:solvify/firebase_js.dart';
import 'package:solvify/pages/registration/register_page.dart';
import 'package:solvify/pages/signin_signup/login_page.dart';
import 'package:solvify/styles/app_style.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final emailController = TextEditingController();

  void goToRegister() {
    Navigator.pushReplacement(
        context,
        PageTransition(
            child: const RegisterPage(
              isReset: true,
            ),
            type: PageTransitionType.fade));
  }

  bool checkFields() {
    if (emailController.text.trim().toString().isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void displayError(String errorMessage) {
    switch (errorMessage) {
      case "user-not-found":
        errorMessage = "No user found with that email.";
        break;
      case "empty-fields":
        errorMessage = "Please fill in all fields.";
        break;
      default:
        errorMessage = "An undefined error happened - $errorMessage";
    }
    showDialog(
        context: context,
        builder: (context) => StyledModal(
              backgroundColor: AppStyle.secondaryBackground,
              title: 'Passwrord Reset Failed',
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

  void goBackToLogin() {
    Navigator.pushReplacement(
        context,
        PageTransition(
            child: const LoginPage(), type: PageTransitionType.fade));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              goBackToLogin();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: AppStyle.primaryAccent,
            ),
          ),
        ),
      ),
      backgroundColor: AppStyle.primaryBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Image.asset(
                    "assets/icons/Solvify.png",
                    height: 75,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                InputTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                  textFieldBackgroundColor: AppStyle.secondaryBackground,
                  textFieldHintTextColor: AppStyle.getTextFieldHintColor(),
                  textFieldTextColor: AppStyle.getTextFieldTextColor(),
                  textFieldBorderColor: Colors.grey.shade400,
                  textFieldBorderFocusColor: AppStyle.primaryAccent,
                ),
                const SizedBox(
                  height: 50,
                ),
                StyledButton(
                  onTap: () async {
                    if (checkFields() == false) {
                      displayError("empty-fields");
                    } else {
                      displayLoad();

                      dynamic result = await promiseToFuture(
                          sendPasswordResetEmail(
                              emailController.text.trim().toString()));

                      var state = js.JsObject.fromBrowserObject(
                          js.context['userState']);

                      if (result == true) {
                        if (state['resetSent'] == true) {
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          await Future.delayed(
                              const Duration(milliseconds: 500), () {
                            showDialog(
                                context: context,
                                builder: (context) => StyledModal(
                                      backgroundColor:
                                          AppStyle.secondaryBackground,
                                      title: 'Password Reset Sent',
                                      body:
                                          'A password reset email has been sent to ${emailController.text.trim().toString()}.',
                                      onTap: () => Navigator.pop(context),
                                    ));
                          });
                        }
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
                  buttonText: 'Submit',
                  buttonTextColor: Colors.white,
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?",
                        style: TextStyle(color: Colors.grey.shade700)),
                    const SizedBox(width: 5),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: goToRegister,
                        child: Text(
                          "Register!",
                          style: TextStyle(
                              color: AppStyle.faqTextHeading,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
