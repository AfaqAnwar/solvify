import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:solvify/styles/app_style.dart';

class RegisterOnboardFirstPage extends StatefulWidget {
  const RegisterOnboardFirstPage({super.key});

  @override
  State<RegisterOnboardFirstPage> createState() =>
      _RegisterOnboardFirstPageState();
}

class _RegisterOnboardFirstPageState extends State<RegisterOnboardFirstPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void setSharedState() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString("currentPage", "register_onboard_0");
    });
  }

  @override
  void initState() {
    super.initState();
    setSharedState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        const SizedBox(
          height: 100,
          child: Image(
            image: AssetImage('/assets/gifs/scan.gif'),
            fit: BoxFit.fill,
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Text("First we scan your assignment to find all questions!",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppStyle.getTextColor())),
      ]),
    );
  }
}
