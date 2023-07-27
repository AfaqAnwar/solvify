// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:solvify/components/generic_components/styled_button.dart';
import 'package:solvify/components/generic_components/styled_modal.dart';
import 'package:solvify/components/generic_components/input_textfield.dart';
import 'package:solvify/firebase_js.dart';
import 'package:solvify/pages/registration/register_onboard.dart';
import 'package:solvify/pages/signin_signup/login_page.dart';
import 'package:solvify/styles/app_style.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  bool checkFieldsEmpty() {
    if (emailController.text.trim().toString().isEmpty ||
        passwordController.text.trim().toString().isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool checkPasswordsMatch() {
    if (passwordController.text.trim().toString() ==
        passwordConfirmController.text.trim().toString()) {
      return true;
    } else {
      return false;
    }
  }

  void register() async {
    if (checkFieldsEmpty() == false) {
      displayError("empty-fields");
    } else if (checkPasswordsMatch() == false) {
      displayError("passwords-dont-match");
    } else {
      displayLoad();

      registerUser(emailController.text.trim().toString(),
          passwordController.text.trim().toString());

      var state = js.JsObject.fromBrowserObject(js.context['userState']);

      Future.delayed(const Duration(milliseconds: 1000), () {
        if (state['loggedIn'] == true) {
          Navigator.pop(context);
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: const RegisterOnboard(),
                    type: PageTransitionType.rightToLeftWithFade));
          });
        } else {
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pop(context);
            String errorMessage =
                state['error'].toString().replaceAll("auth/", "");
            displayError(errorMessage);
          });
        }
      });
    }
  }

  void displayError(String errorMessage) {
    switch (errorMessage) {
      case "empty-fields":
        errorMessage = "Please fill out both your email and password.";
        break;
      case "passwords-dont-match":
        errorMessage = "Your passwords don't match.";
        break;
      case "email-already-in-use":
        errorMessage = "This email is already in use.";
        break;
      case "invalid-email":
        errorMessage = "This email is invalid.";
        break;
      case "weak-password":
        errorMessage = "Your password is too weak.";
        break;
      default:
        errorMessage = "An undefined error happened - $errorMessage";
    }
    showDialog(
        context: context,
        builder: (context) => StyledModal(
            backgroundColor: AppStyle.secondaryBackground,
            title: 'Registration Error',
            body: errorMessage.toString()));
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
    Navigator.push(
        context,
        PageTransition(
            child: const LoginPage(),
            childCurrent: const RegisterPage(),
            type: PageTransitionType.leftToRightPop));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          splashRadius: 0.1,
          color: AppStyle.primaryAccent,
          onPressed: goBackToLogin,
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
                  textFieldHintTextColor: Colors.grey.shade400,
                  textFieldTextColor: Colors.black,
                  textFieldBorderColor: Colors.grey.shade400,
                  textFieldBorderFocusColor: AppStyle.primaryAccent,
                ),
                const SizedBox(
                  height: 10,
                ),
                InputTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                  textFieldBackgroundColor: AppStyle.secondaryBackground,
                  textFieldHintTextColor: Colors.grey.shade400,
                  textFieldTextColor: Colors.black,
                  textFieldBorderColor: Colors.grey.shade400,
                  textFieldBorderFocusColor: AppStyle.primaryAccent,
                ),
                const SizedBox(
                  height: 10,
                ),
                InputTextField(
                  controller: passwordConfirmController,
                  hintText: "Confirm Password",
                  obscureText: true,
                  textFieldBackgroundColor: AppStyle.secondaryBackground,
                  textFieldHintTextColor: Colors.grey.shade400,
                  textFieldTextColor: Colors.black,
                  textFieldBorderColor: Colors.grey.shade400,
                  textFieldBorderFocusColor: AppStyle.primaryAccent,
                ),
                const SizedBox(
                  height: 50,
                ),
                StyledButton(
                  onTap: register,
                  buttonColor: AppStyle.primaryAccent,
                  buttonText: 'Register',
                  buttonTextColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
