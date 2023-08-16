import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solvify/components/app_components/custom_scaffold.dart';
import 'package:solvify/styles/app_style.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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

  @override
  void initState() {
    super.initState();
    setSharedState();
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
                      fontSize: 36,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  child: ListTile(
                    title: Text(
                      "Dark Mode",
                      style: TextStyle(
                          fontFamily: GoogleFonts.karla().fontFamily,
                          color: AppStyle.getTextColor(),
                          fontSize: 18,
                          fontWeight: FontWeight.w800),
                    ),
                    trailing: SizedBox(
                      width: 60,
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
              ],
            ),
          ),
        ));
  }
}
