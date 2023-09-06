import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:solvify/styles/app_style.dart';

class RegisterOnboardAPIPage extends StatefulWidget {
  const RegisterOnboardAPIPage({super.key});

  @override
  State<RegisterOnboardAPIPage> createState() => _RegisterOnBoardAPIPageState();
}

class _RegisterOnBoardAPIPageState extends State<RegisterOnboardAPIPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void setSharedState() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString("currentPage", "register_onboard_api");
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
            image: AssetImage('/assets/gifs/api.gif'),
            fit: BoxFit.fill,
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Text("First, you'll need to provide us your Open AI API key.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppStyle.getTextColor())),
        ),
        const SizedBox(
          height: 14,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Text("Don't worry, we'll help you get one & keep it safe!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppStyle.getTextColor())),
        )
      ]),
    );
  }
}
