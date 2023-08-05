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
  String buttonText = "Solve!";
  late Widget bodyContent;

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
    bodyContent = getImage();
  }

  Widget getImage() {
    return SizedBox(
      height: 150,
      child: Image(
        key: ValueKey<AssetImage>(logo),
        image: logo,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget getBody() {
    return Column(children: [
      Text(
        textAlign: TextAlign.center,
        solver.getQuestion(),
        style: TextStyle(
          color: AppStyle.primaryAccent,
          fontSize: 14,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        textAlign: TextAlign.center,
        solver.getAnswer(),
        style: TextStyle(
            color: AppStyle.primaryAccent,
            fontSize: 12,
            fontWeight: FontWeight.bold),
      ),
    ]);
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
                bodyContent = getImage();
                titleText = "Loading...";
                _textOpacity = 1;
                _imageOpacity = 1;
                _loading = true;
              }));
    }
  }

  void finishLoadUpdateBody() {
    setState(() {
      logo = const AssetImage('assets/gifs/idle.gif');
      titleText = "Solvify";
      _textOpacity = 1;
      _imageOpacity = 1;
      _buttonOpacity = 1;
      _loading = false;
      buttonText = "Solve Again!";
      bodyContent = getBody();
    });
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
                "You are a highly capable advanced HTML / text scraping specialist. You specialize in finding questions and any answer choices if present within some given HTML code or the inner text of HTML code. Please provide back the question and the answer choices (if present) ONLY. DO NOT PROVIDE THE ANSWER OR ANYTHING ELSE I SIMPLY ONLY WANT THE QUESTION AND CHOICES IF ANY ARE PRESENT. Please be advised some questions may be fill in the blank and some may be multiple choice. If the question is fill in the blank simply add a '_' where the blank is. If you cannot find the question simply reply with 'ERROR'.",
            role: OpenAIChatMessageRole.system),
        OpenAIChatCompletionChoiceMessageModel(
            content: solver.getBodyText(), role: OpenAIChatMessageRole.user),
      ],
    );
    solver.setQuestion(chatCompletion.choices.first.message.content);
  }

  Future<void> answer() async {
    OpenAIChatCompletionModel chatCompletion =
        await OpenAI.instance.chat.create(
      model: "gpt-4",
      messages: [
        const OpenAIChatCompletionChoiceMessageModel(
            content:
                "You are a highly capable advanced homework helping specialist. You specialize in finding answers to any questions I give you along with a percentage of how confident you are that it is the right answer. Please provide the CORRECT ANSWER(S) ONLY. Do not repeat the question or provide any explanation. In addition, if it is a fill in the blank question do not repeat the entire statement or phrase, just provide the missing word(s). Please also be mindful that some questions may have multiple answers, if this is the case list the answers out line by line otherwise keep the answer on one line. If you cannot find the answer to a question just reply with a question mark. If any errors occur please say ERROR.",
            role: OpenAIChatMessageRole.system),
        OpenAIChatCompletionChoiceMessageModel(
            content: solver.getQuestion(), role: OpenAIChatMessageRole.user),
      ],
    );
    solver.setAnswer(chatCompletion.choices.first.message.content);
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
                  child: bodyContent),
              Expanded(child: Container()),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: _buttonOpacity,
                child: StyledButton(
                    onTap: () async {
                      if (_loading == false) {
                        setLoadingAndChangeAssets();
                        await scrape();
                        await parse();
                        await answer();
                        Future.delayed(
                            const Duration(milliseconds: 100),
                            () => setState(() {
                                  finishLoadUpdateBody();
                                }));
                      }
                    },
                    buttonColor: AppStyle.primaryAccent,
                    buttonText: buttonText,
                    buttonTextColor: Colors.white),
              ),
              const SizedBox(height: 50),
            ],
          )),
        ));
  }
}
