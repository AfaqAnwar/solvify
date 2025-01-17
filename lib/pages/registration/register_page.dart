// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
// ignore: avoid_web_libraries_in_flutter
import 'dart:js_util';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solvify/components/generic_components/styled_button.dart';
import 'package:solvify/components/generic_components/styled_modal.dart';
import 'package:solvify/components/generic_components/input_textfield.dart';
import 'package:solvify/firebase_js.dart';
import 'package:solvify/pages/registration/onboarding/register_onboard_host.dart';
import 'package:solvify/pages/signin_signup/login_page.dart';
import 'package:solvify/pages/signin_signup/reset_password_page.dart';
import 'package:solvify/styles/app_style.dart';

class RegisterPage extends StatefulWidget {
  final bool? isReset;

  const RegisterPage({super.key, this.isReset});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  void setSharedState() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString("currentPage", "register");
    });
  }

  @override
  void initState() {
    super.initState();
    setSharedState();
  }

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

      dynamic result = await promiseToFuture(registerUser(
          emailController.text.trim().toString(),
          passwordController.text.trim().toString()));

      var state = js.JsObject.fromBrowserObject(js.context['userState']);

      if (result == true) {
        if (state['loggedIn'] == true) {
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: const RegisterOnboardHost(),
                    type: PageTransitionType.rightToLeftWithFade));
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

  void goBackToResetPage() {
    Navigator.pushReplacement(
        context,
        PageTransition(
            child: const ResetPasswordPage(), type: PageTransitionType.fade));
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
              if (widget.isReset!) {
                goBackToResetPage();
              } else {
                goBackToLogin();
              }
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
                  height: 20,
                ),
                InputTextField(
                  controller: passwordController,
                  hintText: "Password",
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
                  controller: passwordConfirmController,
                  hintText: "Confirm Password",
                  obscureText: true,
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
