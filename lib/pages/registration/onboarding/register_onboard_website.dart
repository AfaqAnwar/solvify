import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:solvify/styles/app_style.dart';

class RegisterOnboardWebsites extends StatefulWidget {
  const RegisterOnboardWebsites({super.key});

  @override
  State<RegisterOnboardWebsites> createState() =>
      _RegisterOnboardWebsitesState();
}

class _RegisterOnboardWebsitesState extends State<RegisterOnboardWebsites> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void setSharedState() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString("currentPage", "register_onboard_website");
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
            image: AssetImage('/assets/gifs/websites.gif'),
            fit: BoxFit.fill,
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Text("Add your desired websites to your account to get started!",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppStyle.getTextColor())),
      ]),
    );
  }
}
