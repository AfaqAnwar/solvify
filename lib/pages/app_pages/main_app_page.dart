// ignore: avoid_web_libraries_in_flutter
import 'dart:js_util';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solvify/components/generic_components/styled_button.dart';
import 'package:solvify/functions_js.dart';
import 'package:solvify/helpers/Solver.dart';
import 'package:solvify/styles/app_style.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

class MainAppPage extends StatefulWidget {
  const MainAppPage({super.key});

  @override
  State<MainAppPage> createState() => _MainAppPageState();
}

class _MainAppPageState extends State<MainAppPage> {
  Solver solver = Solver();
  AssetImage logo = const AssetImage('assets/gifs/idle.gif');
  String titleText = "Solvify";
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  double _textOpacity = 1;
  double _imageOpacity = 1;
  double _buttonOpacity = 1;
  bool _loading = false;

  void setSharedState() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString("currentPage", "app");
    });
  }

  @override
  void initState() {
    super.initState();
    setSharedState();
  }

  void setLoadingAndChangeAssets() {
    if (_loading == false) {
      setState(() => _textOpacity = 0);
      setState(() => _imageOpacity = 0);
      setState(() => _buttonOpacity = 0);

      Future.delayed(
          const Duration(milliseconds: 500),
          () => setState(() {
                logo = const AssetImage('assets/gifs/load.gif');
                titleText = "Loading...";
                _textOpacity = 1;
                _imageOpacity = 1;
                _loading = true;
              }));
    }
  }

  Future<void> scrape() async {
    dynamic result = await promiseToFuture(scrapeHTML());
    if (result == true) {
      var clientVariables =
          js.JsObject.fromBrowserObject(js.context['clientVariables']);
      solver.setBodyText(clientVariables['html']);
    }
  }

  Future<void> parse() async {
    OpenAIChatCompletionModel chatCompletion =
        await OpenAI.instance.chat.create(
      model: "gpt-3.5-turbo",
      messages: [
        const OpenAIChatCompletionChoiceMessageModel(
            content:
                "You are a highly capable advanced HTML / text scraping specialist. You specialize in finding questions and any answer choices if present within some given HTML code or the inner text of HTML code. Please provide back the question and the answer choices (if present) ONLY. Do not provide anything else. Please be advised some questions may be fill in the blank and some may be multiple choice. If you cannot find the question simply reply with 'ERROR'.",
            role: OpenAIChatMessageRole.system),
        OpenAIChatCompletionChoiceMessageModel(
            content: solver.getBodyText(), role: OpenAIChatMessageRole.user),
      ],
    );
    solver.setQuestion(chatCompletion.choices[0].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppStyle.primaryBackground,
        body: SafeArea(
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: _textOpacity,
                child: Text(
                  titleText,
                  style: TextStyle(
                      color: AppStyle.primaryAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(child: Container()),
              AnimatedOpacity(
                opacity: _imageOpacity,
                duration: const Duration(milliseconds: 250),
                child: SizedBox(
                  height: 150,
                  child: Image(
                    key: ValueKey<AssetImage>(logo),
                    image: logo,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Expanded(child: Container()),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: _buttonOpacity,
                child: StyledButton(
                    onTap: () async {
                      if (_loading == false) {
                        setLoadingAndChangeAssets();
                        await scrape();
                        parse();
                      }
                    },
                    buttonColor: AppStyle.primaryAccent,
                    buttonText: "Solve!",
                    buttonTextColor: Colors.white),
              ),
              const SizedBox(height: 50),
            ],
          )),
        ));
  }
}
