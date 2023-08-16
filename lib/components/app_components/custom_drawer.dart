import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solvify/pages/app_pages/info_page.dart';
import 'package:solvify/pages/app_pages/profile_page.dart';
import 'package:solvify/pages/app_pages/main_app_page.dart';
import 'package:solvify/pages/app_pages/settings_page.dart';
import 'package:solvify/styles/app_style.dart';

class CustomerDrawer extends StatelessWidget {
  const CustomerDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Drawer(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        elevation: 0,
        backgroundColor: AppStyle.primaryBackground,
        child: Column(
          children: [
            ListTile(
              minVerticalPadding: 50,
              title: const Icon(Icons.home, size: 20),
              iconColor: AppStyle.getIconColor(),
              onTap: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();

                if (prefs.getString("currentPage") == "app") {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                } else {
                  String? question = prefs.getString("currentQuestion");
                  String? answer = prefs.getString("currentAnswer");
                  String? confidence = prefs.getString("currentConfidence");

                  if (question != null) {
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: MainAppPage(
                                question: question,
                                answer: answer,
                                confidence: confidence),
                            type: PageTransitionType.fade));
                  } else {
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: const MainAppPage(),
                            type: PageTransitionType.fade));
                  }
                }
              },
              splashColor: Colors.transparent,
              hoverColor: AppStyle.primaryAccent,
            ),
            ListTile(
              minVerticalPadding: 50,
              title: const Icon(Icons.account_circle, size: 20),
              iconColor: AppStyle.getIconColor(),
              onTap: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();

                if (prefs.getString("currentPage") == "profile") {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                } else {
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: const ProfilePage(),
                          type: PageTransitionType.fade));
                }
              },
              splashColor: Colors.transparent,
              hoverColor: AppStyle.primaryAccent,
            ),
            ListTile(
              minVerticalPadding: 50,
              title: const Icon(Icons.info, size: 20),
              iconColor: AppStyle.getIconColor(),
              onTap: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();

                if (prefs.getString("currentPage") == "info") {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                } else {
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: const InfoPage(),
                          type: PageTransitionType.fade));
                }
              },
              splashColor: Colors.transparent,
              hoverColor: AppStyle.primaryAccent,
            ),
            const Spacer(),
            ListTile(
              minVerticalPadding: 50,
              title: const Icon(Icons.settings, size: 20),
              iconColor: AppStyle.getIconColor(),
              onTap: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();

                if (prefs.getString("currentPage") == "settings") {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                } else {
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: const SettingsPage(),
                          type: PageTransitionType.fade));
                }
              },
              splashColor: Colors.transparent,
              hoverColor: AppStyle.primaryAccent,
            ),
          ],
        ),
      ),
    );
  }
}
