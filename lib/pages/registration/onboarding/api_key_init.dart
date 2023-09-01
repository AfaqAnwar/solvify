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
import 'package:solvify/pages/app_pages/main_app_page.dart';
import 'package:solvify/styles/app_style.dart';

class ApiKeyInit extends StatefulWidget {
  const ApiKeyInit({super.key});

  @override
  State<ApiKeyInit> createState() => _ApiKeyInitState();
}

class _ApiKeyInitState extends State<ApiKeyInit> {
  final apiController = TextEditingController();

  void submitKey() async {
    displayLoad();

    dynamic result = await promiseToFuture(
        updateAPIKeyToFirestore(apiController.text.trim().toString()));

    var state = js.JsObject.fromBrowserObject(js.context['userState']);

    if (result == true) {
      if (state['apiKeyUpdated'] == true) {
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
        String errorMessage = state['error'].toString();
        displayError(errorMessage);
      });
    }
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

  void displayError(String errorMessage) {
    switch (errorMessage) {
      default:
        errorMessage = "An error occured: $errorMessage";
    }
    showDialog(
        context: context,
        builder: (context) => StyledModal(
              backgroundColor: AppStyle.secondaryBackground,
              title: 'API Key Error',
              body: errorMessage.toString(),
              onTap: () => Navigator.pop(context),
            ));
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
                  controller: apiController,
                  hintText: "API Key",
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
                  onTap: submitKey,
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
                    Text("Need an API key?",
                        style: TextStyle(color: Colors.grey.shade700)),
                    const SizedBox(width: 4),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          "Find out how to get one!",
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
