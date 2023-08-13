// ignore: avoid_web_libraries_in_flutter
import 'dart:js_util';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solvify/components/app_components/custom_scaffold.dart';
import 'package:solvify/components/generic_components/styled_button.dart';
import 'package:solvify/components/generic_components/styled_modal.dart';
import 'package:solvify/functions_js.dart';
import 'package:solvify/helpers/Solver.dart';
import 'package:solvify/styles/app_style.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

class MainAppPage extends StatefulWidget {
  final String? question;
  final String? answer;
  final String? confidence;
  const MainAppPage({super.key, this.question, this.answer, this.confidence});

  @override
  State<MainAppPage> createState() => _MainAppPageState();
}

class _MainAppPageState extends State<MainAppPage> {
  Solver solver = Solver();
  AssetImage logo = const AssetImage('assets/gifs/idle.gif');
  String titleText = "SOLVIFY";
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  double _textOpacity = 1;
  double _bodyOpacity = 1;
  double _buttonOpacity = 1;
  bool _loading = false;
  String buttonText = "Solve";
  late Widget bodyContent;
  bool disabled = false;
  bool hideDrawer = false;

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
    if (widget.question == null) {
      bodyContent = getImage();
    } else {
      setState(() {
        solver.setQuestion(widget.question!);
        solver.setAnswer(widget.answer!);
        solver.setConfidence(widget.confidence!);
        buttonText = "Solve Again";
      });

      bodyContent = getBody();
    }
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
        solver.getAnswer(),
        style: const TextStyle(
            color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
      ),
      const SizedBox(height: 20),
      CircularPercentIndicator(
        backgroundColor: AppStyle.primaryBackground,
        radius: 80.0,
        lineWidth: 8.0,
        animation: true,
        percent: solver.getConfidenceAsDouble(),
        center: Text(
          solver.getConfidence(),
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18.0,
            color: Colors.white,
          ),
        ),
        footer: Column(
          children: [
            const SizedBox(height: 20),
            InkResponse(
              highlightColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StyledModal(
                        backgroundColor: AppStyle.secondaryBackground,
                        title: "What is Confidence?",
                        body:
                            "Confidence is a percentage that represents how confident the AI is in its answer. The higher the percentage, the more confident the AI is in its answer. Please note that the AI is not always correct, so please use your best judgement when using the answer provided.",
                        onTap: () {
                          Navigator.pop(context);
                        },
                      );
                    });
              },
              child: Text(
                "Confidence",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 10.0,
                    color: AppStyle.tertiaryColor),
              ),
            ),
          ],
        ),
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: AppStyle.primarySuccess,
      ),
    ]);
  }

  Widget getErrorBody() {
    String text;
    if (solver.getAnswer() == "ERROR") {
      text =
          "Sorry we could not find an answer to your question. Please try a different question.";
    } else {
      text =
          "Sorry we could not find a question in the current page. Please try a different question.";
    }
    return Column(
      children: [
        Text(
          textAlign: TextAlign.center,
          text,
          style: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 125,
          child: Image(
            key: ValueKey<AssetImage>(logo),
            image: const AssetImage('assets/gifs/error.gif'),
            fit: BoxFit.fill,
          ),
        )
      ],
    );
  }

  void setLoadingAndChangeAssets() async {
    if (_loading == false) {
      setState(() => _textOpacity = 0);
      setState(() => _bodyOpacity = 0);
      setState(() => _buttonOpacity = 0);

      Future.delayed(
          const Duration(milliseconds: 500),
          () => setState(() {
                hideDrawer = true;
                logo = const AssetImage('assets/gifs/load.gif');
                bodyContent = getImage();
                titleText = "LOADING";
                _textOpacity = 1;
                _bodyOpacity = 1;
                _loading = true;
              }));
    }
  }

  void finishLoadUpdateBody() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      hideDrawer = false;
      logo = const AssetImage('assets/gifs/idle.gif');
      titleText = "SOLVIFY";
      _textOpacity = 1;
      _bodyOpacity = 1;
      _buttonOpacity = 1;
      _loading = false;
      buttonText = "Solve Again";
      if (solver.getAnswer() == "ERROR") {
        bodyContent = getErrorBody();
      } else {
        bodyContent = getBody();

        prefs.setString("currentQuestion", solver.getQuestion());
        prefs.setString("currentAnswer", solver.getAnswer());
        prefs.setString("currentConfidence", solver.getConfidence());
      }
    });
  }

  void updateBodyToError() {
    setState(() {
      logo = const AssetImage('assets/gifs/idle.gif');
      titleText = "SOLVIFY";
      _textOpacity = 1;
      _bodyOpacity = 1;
      _buttonOpacity = 1;
      _loading = false;
      buttonText = "Try Again";
      bodyContent = getErrorBody();
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
                "You are a highly capable advanced homework helping specialist. You specialize in finding answers to any questions I give you. I also need a confidence rating so on a new line just put a percentage of how confident you are in your answer. Please format it as 'Confidence: ' with the rating followed afterwards so I can parse it easily. Please provide the CORRECT ANSWER(S) ONLY and the confidence percentage. Do not repeat the question or provide any explanation. In addition, if it is a fill in the blank question do not repeat the entire statement or phrase, just provide the missing word(s). Please also be mindful that some questions may have multiple answers, if this is the case list the answers out line by line otherwise keep the answer on one line. If you cannot find the answer to a question just reply with a question mark. If any errors occur please say ERROR.",
            role: OpenAIChatMessageRole.system),
        OpenAIChatCompletionChoiceMessageModel(
            content: solver.getQuestion(), role: OpenAIChatMessageRole.user),
      ],
    );
    solver.setAnswer(chatCompletion.choices.first.message.content);
    solver.setConfidenceFromAnswer();
    solver.parseAnswer();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        hideDrawer: hideDrawer,
        child: SafeArea(
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: _textOpacity,
                child: Text(
                  titleText,
                  style: TextStyle(
                      fontFamily: GoogleFonts.karla().fontFamily,
                      color: AppStyle.primaryAccent,
                      fontSize: 36,
                      fontWeight: FontWeight.w800),
                ),
              ),
              Expanded(child: Container()),
              AnimatedOpacity(
                  opacity: _bodyOpacity,
                  duration: const Duration(milliseconds: 250),
                  child: bodyContent),
              Expanded(child: Container()),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: _buttonOpacity,
                child: StyledButton(
                    onTap: () async {
                      if (_loading == false || disabled == true) {
                        // NEEDS CHANGING DELAY IS RUINING FLOW.
                        setLoadingAndChangeAssets();
                        await scrape();
                        await parse();
                        if (solver.getQuestion() == "ERROR") {
                          updateBodyToError();
                        } else {
                          await answer();
                          Future.delayed(
                              const Duration(milliseconds: 100),
                              () => setState(() {
                                    finishLoadUpdateBody();
                                  }));
                        }
                      }
                    },
                    buttonColor: AppStyle.primaryAccent,
                    buttonText: buttonText,
                    buttonTextColor: Colors.white),
              ),
              const SizedBox(height: 25),
            ],
          )),
        ));
  }
}
