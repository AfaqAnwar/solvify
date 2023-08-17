// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'dart:js_util';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solvify/firebase_js.dart';
import 'package:solvify/pages/app_pages/info_page.dart';
import 'package:solvify/pages/app_pages/main_app_page.dart';
import 'package:solvify/pages/app_pages/profile_page.dart';
import 'package:solvify/pages/app_pages/settings_page.dart';
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
    setDarkMode();
    pushPage();
  }

  Future setDarkMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? darkMode = prefs.getString("darkMode");

    if (darkMode == "true" || darkMode == null) {
      AppStyle.isDarkMode = true;
      AppStyle.setToDarkMode();
    } else {
      AppStyle.isDarkMode = false;
      AppStyle.setToLightMode();
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: setDarkMode(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Scaffold(
              backgroundColor: AppStyle.primaryBackground,
              body: Center(
                  child: CircularProgressIndicator(
                color: AppStyle.primaryAccent,
              )));
        });
  }

  Future pushPage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? page = prefs.getString("currentPage");

    Widget pageToDisplay = const LoginPage();
    dynamic result = await promiseToFuture(updateUserPassword(checkSession()));

    if (result == false) {
      pageToDisplay = const LoginPage();
    }

    var state = js.JsObject.fromBrowserObject(js.context['userState']);
    Future.delayed(const Duration(milliseconds: 500), () {
      switch (page) {
        case "login":
          pageToDisplay = const LoginPage();
          break;
        case "register":
          pageToDisplay = const RegisterPage();
          break;
        case "app":
          if (state["sessionActive"] == true) {
            String? question = prefs.getString("currentQuestion");
            String? answer = prefs.getString("currentAnswer");
            String? confidence = prefs.getString("currentConfidence");
            if (question != null) {
              pageToDisplay = MainAppPage(
                  question: question, answer: answer, confidence: confidence);
            } else {
              pageToDisplay = const MainAppPage();
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
        case "register_onboard_0":
          if (state["sessionActive"] == true) {
            pageToDisplay = const RegisterOnboardHost();
          }
          break;
        default:
          pageToDisplay = const LoginPage();
      }
      Navigator.pushReplacement(context,
          PageTransition(child: pageToDisplay, type: PageTransitionType.fade));
    });
  }
}
