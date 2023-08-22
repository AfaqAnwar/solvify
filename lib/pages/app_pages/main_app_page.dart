// ignore: avoid_web_libraries_in_flutter
import 'dart:js_util';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solvify/chrome_api.dart';

import 'package:solvify/components/app_components/custom_scaffold.dart';
import 'package:solvify/components/generic_components/styled_button.dart';
import 'package:solvify/components/generic_components/styled_modal.dart';
import 'package:solvify/functions_js.dart';
import 'package:solvify/helpers/Solver.dart';
import 'package:solvify/options.dart';

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
  AssetImage logo = AssetImage(AppStyle.getIdleGif());
  String titleText = "SOLVIFY";
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  double _textOpacity = 1;
  double _bodyOpacity = 1;
  double _buttonOpacity = 1;
  double _subtitleOpacity = 0;
  bool _loading = false;
  String buttonText = "Solve";
  Widget bodyContent = const SizedBox();
  bool disabled = false;
  bool hideDrawer = false;
  Color currentButtonColor = AppStyle.primaryAccent;
  bool isValid = false;
  int milli = 250;

  void setSharedState() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString("currentPage", "app");
    });
  }

  @override
  void initState() async {
    super.initState();
    setSharedState();

    isValid = await promiseToFuture(checkCurrentTabURL());

    if (isValid == true) {
      if (widget.question == null) {
        bodyContent = getImage();
      } else {
        if (Options.mcGrawEnabled == false) {
          setState(() {
            solver.setQuestion(widget.question!);
            solver.setAnswer(widget.answer!);
            solver.setConfidence(widget.confidence!);
            _subtitleOpacity = 1;
            buttonText = "Solve Again";
            bodyContent = getBody();
          });
        } else {
          bodyContent = getImage();
        }
      }
      checkMcGraw();
    } else {
      milli = 0;
      setState(() {
        disabled = true;
        _buttonOpacity = 0;
        bodyContent = getInvalidBody();
      });
    }
  }

  Widget getInvalidBody() {
    return Column(
      children: [
        Text(
          "This page is not supported by Solvify. \n Please open a supported page.",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: AppStyle.getTextColor(),
              fontSize: 14,
              fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 125,
          child: Image(
            key: ValueKey<AssetImage>(logo),
            image: AssetImage(AppStyle.getErrorGif()),
            fit: BoxFit.fill,
          ),
        )
      ],
    );
  }

  void checkMcGraw() {
    if (Options.getMcGrawEnabled() == true) {
      setState(() {
        buttonText = "Auto Solve";
      });
    } else {
      setState(() {
        buttonText = "Solve";
      });
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

  Color getConfidenceColor() {
    if (solver.getConfidenceAsDouble() > 0.8) {
      return AppStyle.primarySuccess;
    } else if (solver.getConfidenceAsDouble() > 0.5) {
      return AppStyle.tertiaryColor;
    } else {
      return AppStyle.primaryError;
    }
  }

  Widget getBody() {
    return Column(children: [
      AutoSizeText(
        maxLines: 4,
        overflow: TextOverflow.clip,
        textAlign: TextAlign.center,
        solver.getAnswer(),
        style: TextStyle(
            color: AppStyle.getTextColor(),
            fontSize: 22,
            fontWeight: FontWeight.w900),
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
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16.0,
            color: AppStyle.getTextColor(),
          ),
        ),
        footer: Column(
          children: [
            const SizedBox(height: 20),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
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
            ),
          ],
        ),
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: getConfidenceColor(),
      ),
    ]);
  }

  Widget getErrorBody() {
    String text;
    if (solver.getAnswer() == "ERROR") {
      text = "Sorry, we could not find an answer to your question.";
    } else {
      text = "Sorry, we could not find a question on the current page.";
    }
    return Column(
      children: [
        Text(
          textAlign: TextAlign.center,
          text,
          style: TextStyle(
              color: AppStyle.getTextColor(),
              fontSize: 14,
              fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 125,
          child: Image(
            key: ValueKey<AssetImage>(logo),
            image: AssetImage(AppStyle.getErrorGif()),
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
      setState(() => _subtitleOpacity = 0);

      Future.delayed(
          const Duration(milliseconds: 500),
          () => setState(() {
                hideDrawer = true;
                logo = AssetImage(AppStyle.getLoadingGif());
                bodyContent = getImage();
                titleText = "LOADING";
                _textOpacity = 1;
                _bodyOpacity = 1;
                _subtitleOpacity = 0;
                _loading = true;
              }));
    }
  }

  void setLoadingAndChangeAssetsMcGraw() async {
    if (_loading == false) {
      setState(() => _textOpacity = 0);
      setState(() => _bodyOpacity = 0);
      setState(() => _subtitleOpacity = 0);
      setState(() => _buttonOpacity = 0);
      setState(() => _loading = true);

      Future.delayed(
          const Duration(milliseconds: 500),
          () => setState(() {
                hideDrawer = true;
                logo = AssetImage(AppStyle.getLoadingGif());
                bodyContent = getImage();
                titleText = "AUTO SOLVING...";
                _textOpacity = 1;
                _bodyOpacity = 1;
                _subtitleOpacity = 0;
                setState(() => _buttonOpacity = 1);
                setState(() => _loading = false);
                currentButtonColor = AppStyle.primaryError;
                buttonText = "Stop";
              }));
    }
  }

  void finishLoadUpdateBodyMcGraw() async {
    setState(() => _textOpacity = 0);
    setState(() => _bodyOpacity = 0);
    setState(() => _subtitleOpacity = 0);
    setState(() => _buttonOpacity = 0);
    setState(() => _loading = true);

    Future.delayed(
        const Duration(milliseconds: 500),
        () => setState(() {
              hideDrawer = false;
              logo = AssetImage(AppStyle.getIdleGif());
              titleText = "SOLVIFY";
              _textOpacity = 1;
              _bodyOpacity = 1;
              _buttonOpacity = 1;
              _subtitleOpacity = 1;
              _loading = false;
              bodyContent = getImage();
              currentButtonColor = AppStyle.primaryAccent;
              buttonText = "Auto Solve";
            }));
  }

  void finishLoadUpdateBody() async {
    setState(() => _textOpacity = 0);
    setState(() => _bodyOpacity = 0);
    setState(() => _subtitleOpacity = 0);
    setState(() => _loading = true);
    final SharedPreferences prefs = await _prefs;
    Future.delayed(
        const Duration(milliseconds: 500),
        () => setState(() {
              hideDrawer = false;
              logo = AssetImage(AppStyle.getIdleGif());
              titleText = "SOLVIFY";
              _textOpacity = 1;
              _bodyOpacity = 1;
              _buttonOpacity = 1;
              _subtitleOpacity = 1;
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
            }));
  }

  void updateBodyToError() {
    setState(() => _loading = false);
    Future.delayed(
        const Duration(milliseconds: 500),
        () => setState(() {
              hideDrawer = false;
              logo = AssetImage(AppStyle.getIdleGif());
              titleText = "SOLVIFY";
              _textOpacity = 1;
              _bodyOpacity = 1;
              _buttonOpacity = 1;
              _subtitleOpacity = 0;
              _loading = false;
              buttonText = "Try Again";
              bodyContent = getErrorBody();
            }));
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
                "We are seeking a highly skilled advanced HTML / text scraping specialist who excels in extracting questions and answer choices from given HTML code or the inner text of HTML code. Your task is to provide only the question and answer choices (if available), excluding the answer or any other information. It is important to note that some questions may be fill in the blank, while others may be multiple choice. In the case of a fill in the blank question, please replace the blank with a '_'. If you are unable to locate the question, please respond with 'ERROR'.",
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
      model: "gpt-3.5-turbo",
      messages: [
        const OpenAIChatCompletionChoiceMessageModel(
            content:
                "As a highly skilled advanced homework helping specialist, your task is to find accurate answers to any questions provided. After providing the answer, please include a confidence rating in the format \"Confidence: [percentage].\" Avoid using a constant 100% confidence rating and ensure that the rating is an actual reflection of your confidence level. Only provide the correct answer(s) without rephrasing or explaining the question. For fill in the blank questions, only provide the missing word(s) without repeating the entire statement. If a question has multiple answers, list them line by line. If you are unable to find an answer, reply with a question mark. In case of any errors, indicate ERROR.",
            role: OpenAIChatMessageRole.system),
        const OpenAIChatCompletionChoiceMessageModel(
            content:
                "To ensure accuracy, please refrain from providing an answer unless you have thoroughly verified that it is completely correct. Only when you are certain, share the final answer exclusively. In case you lack confidence in the answer, kindly indicate ERROR. Additionally, if any errors arise during the process, please also state ERROR",
            role: OpenAIChatMessageRole.system),
        OpenAIChatCompletionChoiceMessageModel(
            content: solver.getQuestion(), role: OpenAIChatMessageRole.user),
      ],
    );
    solver.setAnswer(chatCompletion.choices.first.message.content.trim());
    solver.setConfidenceFromAnswer();
    solver.parseAnswer();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        hideDrawer: hideDrawer,
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: _textOpacity,
                    child: Text(
                      titleText,
                      style: TextStyle(
                        fontFamily: AppStyle.currentMainHeadingFont.fontFamily,
                        letterSpacing: 4,
                        color: AppStyle.primaryAccent,
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: _subtitleOpacity,
                    child: Text(
                      "Answers",
                      style: TextStyle(
                          fontFamily:
                              AppStyle.currentMainHeadingFont.fontFamily,
                          color: AppStyle.primaryAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                  Expanded(child: Container()),
                  AnimatedOpacity(
                      opacity: _bodyOpacity,
                      duration: const Duration(milliseconds: 250),
                      child: bodyContent),
                  Expanded(child: Container()),
                  AnimatedOpacity(
                    duration: Duration(milliseconds: milli),
                    opacity: _buttonOpacity,
                    child: StyledButton(
                        disable: disabled,
                        onTap: () async {
                          var mcGrawTabActive =
                              await promiseToFuture(checkForMcGraw());

                          if (Options.getMcGrawEnabled() &&
                              _loading == false &&
                              disabled == false &&
                              mcGrawTabActive == true) {
                            if (Options.getMcGrawRunning() == false) {
                              sendMessage(ParameterSendMessage(
                                  type: "bot", data: "start"));
                              Options.setMcGrawRunning(true);
                              setLoadingAndChangeAssetsMcGraw();
                            } else {
                              sendMessage(ParameterSendMessage(
                                  type: "bot", data: "stop"));
                              Options.setMcGrawRunning(false);
                              finishLoadUpdateBodyMcGraw();
                            }
                          } else if (mcGrawTabActive == false &&
                              _loading == false &&
                              disabled == false &&
                              Options.getMcGrawEnabled()) {
                            // ignore: use_build_context_synchronously
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StyledModal(
                                    backgroundColor:
                                        AppStyle.secondaryBackground,
                                    title: "McGraw Hill Tab Not Found",
                                    body:
                                        "Please open a McGraw Hill Connect SmartBook assignment and try again or disable McGraw Hill Connect SmartBook Auto Solver in the settings page.",
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  );
                                });
                          } else {
                            if (_loading == false && disabled == false) {
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
                          }
                        },
                        buttonColor: currentButtonColor,
                        buttonText: buttonText,
                        buttonTextColor: Colors.white),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ));
  }
}
