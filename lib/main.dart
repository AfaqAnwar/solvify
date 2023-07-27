// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solvify/app_host.dart';
import 'package:solvify/firebase_js.dart';
import 'package:solvify/functions_js.dart';
import 'package:solvify/pages/app_pages/main_app_page.dart';
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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppHost(),
    );
  }
}
