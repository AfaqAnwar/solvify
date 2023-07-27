import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solvify/pages/registration/register_page.dart';
import 'package:solvify/pages/signin_signup/login_page.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
            future: buildBody(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data as Widget;
              } else {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }));
  }

  Future<Widget> buildBody() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Widget pageToDisplay = const LoginPage();
    switch (prefs.getString("currentPage")) {
      case "login":
        pageToDisplay = const LoginPage();
        break;
      case "register":
        pageToDisplay = const RegisterPage();
        break;
    }

    return pageToDisplay;
  }
}
