import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

import 'package:switcher_button/switcher_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool switchValue = Options.getMcGrawEnabled();

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
                      fontFamily: GoogleFonts.karla().fontFamily,
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
                                });
                              } else {
                                setState(() {
                                  setSharedStateTheme();
                                  AppStyle.setToLightMode();
                                });
                              }
                            }),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  child: ListTile(
                    title: Text(
                      "McGraw Hill Connect Auto Solver",
                      style: TextStyle(
                          color: AppStyle.getTextColor(),
                          fontSize: 18,
                          fontWeight: FontWeight.w800),
                    ),
                    trailing: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: SizedBox(
                        width: 50,
                        child: SwitcherButton(
                            onColor: AppStyle.primaryAccent,
                            offColor: AppStyle.getIconColor(),
                            value: switchValue,
                            onChange: (value) async {
                              switchValue = value;
                              var result = await checkMcgraw();
                              if (result == true && value == true) {
                                Options.setMcGrawEnabled(value);
                                setSharedStateMode(value);
                              } else if (result == false && value == true) {
                                setState(() {
                                  switchValue = false;
                                });
                                Options.setMcGrawEnabled(false);
                                setSharedStateMode(false);

                                // ignore: use_build_context_synchronously
                                showDialog(
                                    context: context,
                                    builder: (context) => StyledModal(
                                          backgroundColor:
                                              AppStyle.secondaryBackground,
                                          title: 'McGraw Hill Connect',
                                          body:
                                              'You must be on a McGraw Hill Connect assignment to enable this feature. \n These usually start with "https://learning.mheducation.com/"',
                                          onTap: () => Navigator.pop(context),
                                        ));
                              } else {
                                Options.setMcGrawEnabled(value);
                                setSharedStateMode(value);
                              }
                            }),
                      ),
                    ),
                  ),
                ),
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
