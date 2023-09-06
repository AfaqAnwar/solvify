// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
// ignore: avoid_web_libraries_in_flutter
import 'dart:js_util';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:solvify/firebase_js.dart';
import 'package:solvify/options.dart';
import 'package:solvify/pages/app_pages/info_page.dart';
import 'package:solvify/pages/app_pages/main_app_page.dart';
import 'package:solvify/pages/app_pages/profile_page.dart';
import 'package:solvify/pages/app_pages/settings_page.dart';
import 'package:solvify/pages/registration/onboarding/api_key_init.dart';
import 'package:solvify/pages/registration/onboarding/register_onboard_host.dart';
import 'package:solvify/pages/registration/register_page.dart';
import 'package:solvify/pages/signin_signup/login_page.dart';
import 'package:solvify/styles/app_style.dart';

class AppHost extends StatefulWidget {
  const AppHost({super.key});

  @override
  State<AppHost> createState() => _AppHostState();
}

class _AppHostState extends State<AppHost> {
  @override
  void initState() {
    super.initState();
    pushPage();
  }

  Future setSavedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? darkMode = prefs.getString("darkMode");

    if (darkMode == "true" || darkMode == null) {
      AppStyle.isDarkMode = true;
      AppStyle.setToDarkMode();
    } else {
      AppStyle.isDarkMode = false;
      AppStyle.setToLightMode();
    }

    String? mode = prefs.getString("mode");

    if (mode == "mcgraw") {
      Options.setMcGrawEnabled(true);
    } else {
      Options.setMcGrawEnabled(false);
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: setSavedPreferences(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Scaffold(
              backgroundColor: AppStyle.primaryBackground,
              body: Center(
                  child: CircularProgressIndicator(
                color: AppStyle.primaryAccent,
              )));
        });
  }

  Future getSessionResult() async {
    var result = await promiseToFuture(checkSession());
    return result;
  }

  Future getOnboarded() async {
    var result = await promiseToFuture(getOnboardedStatus());
    return result;
  }

  Future getAPIKey() async {
    var result = await promiseToFuture(getAPIKeyFromFirestore());
    return result;
  }

  Future<bool> checkIfAPIKeyIsValid(String key) async {
    OpenAI.apiKey = key;
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

  Future pushPage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? page = prefs.getString("currentPage");

    Widget pageToDisplay = const LoginPage();
    dynamic result = await getSessionResult();

    if (result == false) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context,
          PageTransition(child: pageToDisplay, type: PageTransitionType.fade));
    } else {
      var state = js.JsObject.fromBrowserObject(js.context['userState']);

      dynamic result = await getOnboarded();

      if (result == true &&
          state["onboarded"] == false &&
          page == "register_onboard_api_init") {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: const ApiKeyInit(), type: PageTransitionType.fade));
      } else {
        switch (page) {
          case "login":
            pageToDisplay = const LoginPage();
            break;
          case "register":
            pageToDisplay = const RegisterPage();
            break;
          case "app":
            if (state["sessionActive"] == true) {
              var isValid = false;
              var key = prefs.getString("localKey");

              if (key != null) {
                isValid = await checkIfAPIKeyIsValid(key);
              } else {
                var result = await getAPIKey();

                if (result == true) {
                  key = state["apiKey"];
                } else {
                  key = "";
                }
                isValid = await checkIfAPIKeyIsValid(key!);
              }

              if (isValid == false) {
                pageToDisplay = const ApiKeyInit(retry: true);
              } else {
                prefs.setString("localKey", key);
                OpenAI.apiKey = key;
                String? question = prefs.getString("currentQuestion");
                String? answer = prefs.getString("currentAnswer");
                String? confidence = prefs.getString("currentConfidence");

                if (question != null) {
                  pageToDisplay = MainAppPage(
                    question: question,
                    answer: answer,
                    confidence: confidence,
                  );
                } else {
                  pageToDisplay = const MainAppPage();
                }
              }

              var websites = prefs.getStringList("websites");

              if (websites == null || websites.isEmpty) {
                var result = await promiseToFuture(getWebsitesFromFirestore());

                if (result == true) {
                  if (state["websites"] != null) {
                    prefs.setStringList("websites", state["websites"]);
                  }
                } else if (result == false ||
                    state["websites"] == null ||
                    state["websites"].isEmpty) {
                  prefs.setStringList("websites", []);
                }
              }
            }
            break;
          case "info":
            if (state["sessionActive"] == true) {
              pageToDisplay = const InfoPage();
            }
            break;
          case "profile":
            if (state["sessionActive"] == true) {
              pageToDisplay = const ProfilePage();
            }
            break;
          case "settings":
            if (state["sessionActive"] == true) {
              pageToDisplay = const SettingsPage();
            }
            break;

          case "register_onboard_host":
            if (state["sessionActive"] == true) {
              pageToDisplay = const RegisterOnboardHost(
                currentIndex: 0,
              );
            }
            break;
          case "register_onboard_api":
            if (state["sessionActive"] == true) {
              pageToDisplay = const RegisterOnboardHost(
                currentIndex: 0,
              );
            }
            break;
          case "register_onboard_websites":
            if (state["sessionActive"] == true) {
              pageToDisplay = const RegisterOnboardHost(
                currentIndex: 1,
              );
            }
            break;
          case "register_onboard_1":
            if (state["sessionActive"] == true) {
              pageToDisplay = const RegisterOnboardHost(
                currentIndex: 2,
              );
            }
            break;
          case "register_onboard_2":
            if (state["sessionActive"] == true) {
              pageToDisplay = const RegisterOnboardHost(
                currentIndex: 3,
              );
            }
            break;
          case "register_onboard_3":
            if (state["sessionActive"] == true) {
              pageToDisplay = const RegisterOnboardHost(
                currentIndex: 4,
              );
            }
            break;
          case "register_onboard_api_init":
            if (state["sessionActive"] == true) {
              pageToDisplay = const ApiKeyInit();
            }
            break;
          default:
            pageToDisplay = const LoginPage();
        }
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: pageToDisplay, type: PageTransitionType.fade));
      }
    }
  }
}
