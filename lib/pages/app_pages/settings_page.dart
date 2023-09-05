import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:solvify/components/app_components/custom_scaffold.dart';
import 'package:solvify/functions_js.dart';
import 'package:solvify/options.dart';
import 'package:solvify/styles/app_style.dart';
import 'package:solvify/components/generic_components/confirm_modal.dart';
import 'package:solvify/components/generic_components/styled_button.dart';
import 'package:solvify/components/generic_components/styled_modal.dart';
import 'package:solvify/firebase_js.dart';
import 'package:solvify/pages/signin_signup/login_page.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js_util';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool switchValue = Options.getMcGrawEnabled();
  Color textColor = AppStyle.getTextColor();

  void setSharedState() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString("currentPage", "settings");
    });
  }

  void setSharedStateTheme() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString("darkMode", AppStyle.isDarkMode.toString());
    });
  }

  void setSharedStateMode(bool isEnabled) async {
    final SharedPreferences prefs = await _prefs;
    if (isEnabled) {
      setState(() {
        prefs.setString("mode", "mcgraw");
      });
    } else {
      setState(() {
        prefs.setString("mode", "normal");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setSharedState();
  }

  void displayLoad() {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(color: AppStyle.primaryAccent),
          );
        });
  }

  Future checkMcgraw() async {
    var result = await promiseToFuture(checkForMcGraw());
    return result;
  }

  void setTextColorHighlight() {
    setState(() {
      textColor = AppStyle.getAccent();
    });
  }

  void setTextColorNormal() {
    setState(() {
      textColor = AppStyle.getTextColor();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        hideDrawer: false,
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                Text(
                  "Settings",
                  style: TextStyle(
                      fontFamily: AppStyle.currentMainHeadingFont.fontFamily,
                      color: AppStyle.primaryAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  child: ListTile(
                    title: Text(
                      "Dark Mode",
                      style: TextStyle(
                          color: AppStyle.getTextColor(),
                          fontSize: 18,
                          fontWeight: FontWeight.w800),
                    ),
                    trailing: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: SizedBox(
                        width: 50,
                        child: DayNightSwitcher(
                            isDarkModeEnabled: AppStyle.isDarkMode,
                            onStateChanged: (isDarkModeEnabled) {
                              if (isDarkModeEnabled) {
                                setState(() {
                                  setSharedStateTheme();
                                  AppStyle.setToDarkMode();
                                  textColor = AppStyle.getTextColor();
                                });
                              } else {
                                setState(() {
                                  setSharedStateTheme();
                                  AppStyle.setToLightMode();
                                  textColor = AppStyle.getTextColor();
                                });
                              }
                            }),
                      ),
                    ),
                  ),
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                // Container(
                //   margin: const EdgeInsets.only(left: 15, right: 15),
                //   child: ListTile(
                //     title: MouseRegion(
                //       onEnter: (event) => setTextColorHighlight(),
                //       onExit: (event) => setTextColorNormal(),
                //       cursor: SystemMouseCursors.click,
                //       child: GestureDetector(
                //         onTap: () {
                //           setState(() {
                //             showDialog(
                //                 context: context,
                //                 builder: (context) => StyledModal(
                //                       backgroundColor:
                //                           AppStyle.secondaryBackground,
                //                       title:
                //                           'What Is McGraw Hill Connect SmartBook Auto Solver?',
                //                       body:
                //                           'McGraw Hill Connect SmartBook Auto Solver is a feature that attempts automatically solve McGraw Hill Connect SmartBook assignments. This feature learns as you go, it may select the wrong answer for the first few questions. This feature is currently in beta and may not work properly on all assignments. If you encounter any issues, please report them to us. We are working hard to improve this feature and make it more reliable.',
                //                       onTap: () => Navigator.pop(context),
                //                     ));
                //           });
                //         },
                //         child: Text(
                //           "McGraw Hill Connect SmartBook Auto Solver",
                //           style: TextStyle(
                //               color: textColor,
                //               fontSize: 18,
                //               fontWeight: FontWeight.w800),
                //         ),
                //       ),
                //     ),
                //     trailing: MouseRegion(
                //       cursor: SystemMouseCursors.click,
                //       child: SizedBox(
                //         width: 50,
                //         child: SwitchButton(
                //           backgroundColor: AppStyle.getTextColor(),
                //           activeColor: AppStyle.getAccent(),
                //           value: switchValue,
                //           onToggle: (value) async {
                //             switchValue = value;
                //             var result = await checkMcgraw();
                //             if (result == true && value == true) {
                //               setState(() {
                //                 Options.setMcGrawEnabled(value);
                //                 setSharedStateMode(value);
                //               });
                //             } else if (result == false && value == true) {
                //               setState(() {
                //                 switchValue = false;
                //                 Options.setMcGrawEnabled(false);
                //                 setSharedStateMode(false);
                //               });

                //               // ignore: use_build_context_synchronously
                //               showDialog(
                //                   context: context,
                //                   builder: (context) => StyledModal(
                //                         backgroundColor:
                //                             AppStyle.secondaryBackground,
                //                         title:
                //                             'McGraw Hill Connect SmartBook Error',
                //                         body:
                //                             'You must be on a McGraw Hill Connect SmartBook assignment to enable this feature.',
                //                         onTap: () => Navigator.pop(context),
                //                       ));
                //             } else {
                //               setState(() {
                //                 Options.setMcGrawEnabled(value);
                //                 setSharedStateMode(value);
                //               });
                //             }
                //           },
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                const Spacer(),
                StyledButton(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => ConfirmModal(
                                backgroundColor: AppStyle.secondaryBackground,
                                title: 'Sign Out',
                                body: 'Are you sure you want to sign out?',
                                onYesTap: () async {
                                  displayLoad();
                                  dynamic result =
                                      await promiseToFuture(signUserOut());

                                  var state = js.JsObject.fromBrowserObject(
                                      js.context['userState']);

                                  if (result == true) {
                                    if (state['loggedIn'] == false) {
                                      Future.delayed(
                                          const Duration(milliseconds: 500),
                                          () {
                                        Navigator.pop(context);
                                        Navigator.pushReplacement(
                                            context,
                                            PageTransition(
                                                child: const LoginPage(),
                                                type: PageTransitionType.fade));
                                      });
                                    }
                                  } else {
                                    Future.delayed(
                                        const Duration(milliseconds: 500), () {
                                      Navigator.pop(context);
                                      showDialog(
                                        context: context,
                                        builder: (context) => StyledModal(
                                            backgroundColor:
                                                AppStyle.secondaryBackground,
                                            title: 'Sign Out Error',
                                            body:
                                                'An error occurred while signing you out. Please try again later.',
                                            onTap: () =>
                                                Navigator.pop(context)),
                                      );
                                    });
                                  }
                                },
                                onNoTap: () {
                                  Navigator.pop(context);
                                },
                              ));
                    },
                    buttonColor: AppStyle.primaryAccent,
                    buttonText: "Sign Out",
                    buttonTextColor: Colors.white,
                    margin: 60),
                const SizedBox(
                  height: 25,
                )
              ],
            ),
          ),
        ));
  }
}
