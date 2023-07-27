// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solvify/firebase_js.dart';
import 'package:solvify/pages/app_pages/main_app_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppStyle.primaryBackground,
        body: Center(
            child: CircularProgressIndicator(
          color: AppStyle.primaryAccent,
        )));
  }

  Future pushPage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? page = prefs.getString("currentPage");
    Widget pageToDisplay = const LoginPage();
    checkSession();
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
            pageToDisplay = const MainAppPage();
          }
          break;
        case "register_onboard_0":
          if (state["sessionActive"] == true) {
            pageToDisplay = const RegisterOnboardHost();
          }
          break;
      }
      Navigator.pushReplacement(context,
          PageTransition(child: pageToDisplay, type: PageTransitionType.fade));
    });
  }
}
