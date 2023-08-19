// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
// ignore: avoid_web_libraries_in_flutter
import 'dart:js_util';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solvify/firebase_js.dart';
import 'package:solvify/components/generic_components/styled_modal.dart';
import 'package:solvify/components/generic_components/input_textfield.dart';
import 'package:solvify/components/generic_components/styled_button.dart';
import 'package:solvify/pages/app_pages/main_app_page.dart';
import 'package:solvify/pages/registration/register_page.dart';
import 'package:solvify/styles/app_style.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void setSharedState() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString("currentPage", "login");
    });
  }

  @override
  void initState() {
    super.initState();
    setSharedState();
  }

  bool checkFields() {
    if (emailController.text.trim().toString().isEmpty ||
        passwordController.text.trim().toString().isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void signIn() async {
    if (checkFields() == false) {
      displayError("empty-fields");
    } else {
      displayLoad();

      dynamic result = await promiseToFuture(signUserIn(
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
                    child: const MainAppPage(),
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
      case "invalid-email":
        errorMessage = "You entered an invalid email address.";
        break;
      case "wrong-password":
        errorMessage = "Your password is wrong.";
        break;
      case "user-not-found":
        errorMessage = "User with this email doesn't exist.";
        break;
      case "user-disabled":
        errorMessage = "User with this email has been disabled.";
        break;
      case "too-many-requests":
        errorMessage = "Too many requests. Try again later.";
        break;
      case "operation-now-alllowed":
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      case "empty-fields":
        errorMessage = "Please fill out both your email and password.";
        break;
      default:
        errorMessage = "An undefined error happened - $errorMessage";
    }
    showDialog(
        context: context,
        builder: (context) => StyledModal(
              backgroundColor: AppStyle.secondaryBackground,
              title: 'Login Error',
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

  void goToRegister() {
    Navigator.pushReplacement(
        context,
        PageTransition(
            child: const RegisterPage(), type: PageTransitionType.fade));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  height: 10,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {},
                        child: Text("Forgot Password?",
                            style: TextStyle(color: AppStyle.primaryAccent)),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(
                  height: 50,
                ),
                StyledButton(
                  onTap: signIn,
                  buttonColor: AppStyle.primaryAccent,
                  buttonText: 'Sign In',
                  buttonTextColor: Colors.white,
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Not a member?",
                        style: TextStyle(color: Colors.grey.shade700)),
                    const SizedBox(width: 4),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: goToRegister,
                        child: Text(
                          "Register Now!",
                          style: TextStyle(
                              color: AppStyle.primaryAccent,
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
