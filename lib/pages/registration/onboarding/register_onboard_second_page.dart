import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class RegisterOnboardSecondPage extends StatefulWidget {
  const RegisterOnboardSecondPage({super.key});

  @override
  State<RegisterOnboardSecondPage> createState() =>
      _RegisterOnboardSecondPageState();
}

class _RegisterOnboardSecondPageState extends State<RegisterOnboardSecondPage> {
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
    return const Center(
      child: SafeArea(
        child: Column(children: [
          SizedBox(
            height: 100,
            child: Image(
              image: AssetImage('/assets/gifs/ai.gif'),
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Text("Then we hand them off to our intelligent robot to solve!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ]),
      ),
    );
  }
}
