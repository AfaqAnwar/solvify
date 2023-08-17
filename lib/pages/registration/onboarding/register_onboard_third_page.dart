import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:solvify/styles/app_style.dart';

class RegisterOnboardThirdPage extends StatefulWidget {
  const RegisterOnboardThirdPage({super.key});

  @override
  State<RegisterOnboardThirdPage> createState() =>
      _RegisterOnboardThirdPageState();
}

class _RegisterOnboardThirdPageState extends State<RegisterOnboardThirdPage> {
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
            image: AssetImage('/assets/gifs/answer.gif'),
            fit: BoxFit.fill,
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Text("Finally we send you the solutions!",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppStyle.getTextColor())),
      ]),
    );
  }
}
