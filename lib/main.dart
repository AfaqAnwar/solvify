import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solvify/app_host.dart';
import 'package:solvify/env/env.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    OpenAI.apiKey = Env.apiKey;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return MaterialApp(
      theme: ThemeData(
        fontFamily: GoogleFonts.inconsolata().fontFamily,
      ),
      debugShowCheckedModeBanner: false,
      home: const AppHost(),
    );
  }
}
