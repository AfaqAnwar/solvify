import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:solvify/components/generic_components/styled_modal.dart';
import 'package:solvify/components/login_components/login_textfield.dart';
import 'package:solvify/components/login_components/styled_button.dart';
import 'package:solvify/pages/app_pages/main_app_page.dart';
import 'package:solvify/pages/registration/register_load.dart';
import 'package:solvify/styles/app_style.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool checkFields() {
    if (emailController.text.trim().toString().isEmpty ||
        passwordController.text.trim().toString().isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void signUserIn() async {
    if (checkFields() == false) {
      showDialog(
          context: context,
          builder: (context) => StyledModal(
              backgroundColor: AppStyle.secondaryBackground,
              title: 'Login Error',
              body: 'Please fill out both your email and password.'));
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: CircularProgressIndicator(color: AppStyle.primaryAccent),
            );
          });
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: const MainAppPage(),
                  type: PageTransitionType.rightToLeftWithFade));
        });
      } on FirebaseAuthException catch (e) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        String errorMessage = "";
        switch (e.code) {
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
          default:
            errorMessage = "An undefined Error happened.";
        }
        // ignore: use_build_context_synchronously
        showDialog(
            context: context,
            builder: (context) => StyledModal(
                backgroundColor: AppStyle.secondaryBackground,
                title: 'Login Error',
                body: errorMessage.toString()));
      }
    }
  }

  void goToRegister() {
    Navigator.push(
        context,
        PageTransition(
            child: const RegisterLoad(),
            childCurrent: const LoginPage(),
            type: PageTransitionType.rightToLeftPop));
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
                  height: 25,
                ),
                const Text(
                  "Welcome back! You've been missed!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                LoginTextField(
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
                LoginTextField(
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text("Forgot Password?",
                        style: TextStyle(color: AppStyle.primaryAccent)),
                  ]),
                ),
                const SizedBox(
                  height: 30,
                ),
                StyledButton(
                  onTap: signUserIn,
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
                    GestureDetector(
                      onTap: goToRegister,
                      child: Text(
                        "Register Now!",
                        style: TextStyle(
                            color: AppStyle.primaryAccent,
                            fontWeight: FontWeight.bold),
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