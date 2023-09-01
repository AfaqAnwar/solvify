// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
// ignore: avoid_web_libraries_in_flutter
import 'dart:js_util';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solvify/components/app_components/custom_scaffold.dart';
import 'package:solvify/components/generic_components/input_textfield.dart';
import 'package:solvify/components/generic_components/styled_button.dart';
import 'package:solvify/components/generic_components/styled_modal.dart';
import 'package:solvify/firebase_js.dart';
import 'package:solvify/pages/app_pages/main_app_page.dart';
import 'package:solvify/styles/app_style.dart';

class ApiKeyModify extends StatefulWidget {
  const ApiKeyModify({
    super.key,
  });

  @override
  State<ApiKeyModify> createState() => _ApiKeyModifyState();
}

class _ApiKeyModifyState extends State<ApiKeyModify> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
  }

  final apiController = TextEditingController();
  String error =
      "There was an error using your API key. Please double check that you have provided a valid Open AI API key. If you are still having issues, please contact us at Support@Solvify.com";

  void submitKey() async {
    displayLoad();

    dynamic result = await promiseToFuture(
        updateAPIKeyToFirestore(apiController.text.trim().toString()));

    var state = js.JsObject.fromBrowserObject(js.context['userState']);

    if (result == true) {
      if (state['apiKeyUpdated'] == true) {
        bool valid = await checkIfAPIKeyIsValid();
        if (valid) {
          dynamic result = await promiseToFuture(updateOnboardedStatus());

          var state = js.JsObject.fromBrowserObject(js.context['userState']);

          if (result == true) {
            if (state['onboarded'] == true) {
              final SharedPreferences prefs = await _prefs;
              setState(() {
                prefs.setString(
                    "localKey", apiController.text.trim().toString());
              });
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
              displayError("An unexpected error occured. Please try again.");
            });
          }
        } else {
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pop(context);
            displayError(error);
          });
        }
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

  Future<bool> checkIfAPIKeyIsValid() async {
    if (apiController.text.trim().toString().isEmpty) {
      return false;
    } else {
      OpenAI.apiKey = apiController.text.trim().toString();
      try {
        OpenAIChatCompletionModel chatCompletion =
            await OpenAI.instance.chat.create(
          model: "gpt-3.5-turbo",
          messages: [
            const OpenAIChatCompletionChoiceMessageModel(
                content:
                    "YOU ARE AN API KEY TESTER. PLEASE TYPE TRUE TO ACKNOWLEDGE THAT YOU CAN SEE THIS MESSAGE.",
                role: OpenAIChatMessageRole.system),
          ],
        );
        if (chatCompletion.choices.isNotEmpty) {
          return true;
        } else {
          return false;
        }
      } catch (e) {
        return false;
      }
    }
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
                "Manage API Key",
                style: TextStyle(
                    fontFamily: AppStyle.currentMainHeadingFont.fontFamily,
                    color: AppStyle.primaryAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.w800),
              ),
              const Spacer(),
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
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an API key?",
                      style: TextStyle(color: Colors.grey.shade700)),
                  const SizedBox(width: 5),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return StyledModal(
                                backgroundColor: AppStyle.secondaryBackground,
                                title: 'API Key',
                                body:
                                    "You can get an API key from OpenAI's website. You will need to sign up for an account and then you will be able to get an API key. Please click the button below to go to OpenAI's website and follow the instructions there.",
                                onTap: () {
                                  js.context.callMethod('open', [
                                    'https://platform.openai.com/account/api-keys'
                                  ]);
                                  Navigator.pop(context);
                                },
                                buttonText: 'Go to OpenAI',
                              );
                            });
                      },
                      child: Text(
                        "Get One!",
                        style: TextStyle(
                            color: AppStyle.faqTextHeading,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              StyledButton(
                onTap: submitKey,
                buttonColor: AppStyle.primaryAccent,
                buttonText: 'Submit',
                buttonTextColor: Colors.white,
              ),
              const SizedBox(
                height: 25,
              )
            ],
          ),
        ),
      ),
    );
  }
}
