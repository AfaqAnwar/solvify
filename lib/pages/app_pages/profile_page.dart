// ignore: avoid_web_libraries_in_flutter
import 'dart:js_util';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solvify/components/app_components/custom_scaffold.dart';
import 'package:solvify/components/generic_components/confirm_modal.dart';
import 'package:solvify/components/generic_components/input_textfield.dart';
import 'package:solvify/components/generic_components/styled_button.dart';
import 'package:solvify/components/generic_components/styled_modal.dart';
import 'package:solvify/components/generic_components/styled_modal_input.dart';
import 'package:solvify/firebase_js.dart';
import 'package:solvify/pages/app_pages/profile_management_pages/api_key_modify.dart';
import 'package:solvify/pages/app_pages/profile_management_pages/manage_email.dart';
import 'package:solvify/pages/app_pages/profile_management_pages/manage_password.dart';
import 'package:solvify/pages/app_pages/profile_management_pages/supported_websites.dart';
import 'package:solvify/pages/signin_signup/login_page.dart';

import 'package:solvify/styles/app_style.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController passwordController = TextEditingController();

  void setSharedState() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString("currentPage", "profile");
    });
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

  void clearPrefs() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.clear();
    });
  }

  bool checkFields() {
    if (passwordController.text.trim().toString().isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future signIn() async {
    if (checkFields() == false) {
      displayError("empty-fields");
    } else {
      Navigator.pop(context);
      displayLoad();
      var state = js.JsObject.fromBrowserObject(js.context['userState']);
      dynamic result = await promiseToFuture(signUserIn(
          state['email'], passwordController.text.trim().toString()));

      if (result == true) {
        if (state['loggedIn'] == true) {
          return true;
        }
      } else {
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pop(context);
          String errorMessage =
              state['error'].toString().replaceAll("auth/", "");
          displayError(errorMessage);
          return false;
        });
      }
    }
  }

  void reauth() async {
    var state = js.JsObject.fromBrowserObject(js.context['userState']);
    var result = await signIn();
    if (result == true) {
      dynamic result = await promiseToFuture(deleteUserFromCloud());
      if (result && state["loggedIn"] == false) {
        Future.delayed(const Duration(milliseconds: 500), () {
          clearPrefs();
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: const LoginPage(), type: PageTransitionType.fade));
        });
      } else {
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) => StyledModal(
                backgroundColor: AppStyle.secondaryBackground,
                title: 'Deletion Error',
                body: 'An unknown error occurred while deleting your account.',
                onTap: () => Navigator.pop(context)),
          );
        });
      }
    }
  }

  void displayError(String errorMessage) {
    switch (errorMessage) {
      case "invalid-email":
        errorMessage = "You entered an invalid email address.";
        break;
      case "wrong-password":
        errorMessage = "Your password is wrong.";
        break;
      case "user-not-found":
        errorMessage = "User with this email doesn't exist.";
        break;
      case "user-disabled":
        errorMessage = "User with this email has been disabled.";
        break;
      case "too-many-requests":
        errorMessage = "Too many requests. Try again later.";
        break;
      case "operation-now-alllowed":
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      case "empty-fields":
        errorMessage = "Please fill out both your email and password.";
        break;
      default:
        errorMessage = "An undefined error happened - $errorMessage";
    }
    showDialog(
        context: context,
        builder: (context) => StyledModal(
              backgroundColor: AppStyle.secondaryBackground,
              title: 'Reauthentication Error',
              body: errorMessage.toString(),
              onTap: () => Navigator.pop(context),
            ));
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
                  "Your Profile",
                  style: TextStyle(
                      fontFamily: AppStyle.currentMainHeadingFont.fontFamily,
                      color: AppStyle.primaryAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                buildProfileTile(context,
                    iconData: Icons.email_sharp,
                    title: "Manage Email", onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeftWithFade,
                          child: const ManageEmail()));
                }),
                const SizedBox(
                  height: 10,
                ),
                buildProfileTile(context,
                    iconData: Icons.lock_sharp,
                    title: "Manage Password", onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeftWithFade,
                          child: const ManagePassword()));
                }),
                const SizedBox(
                  height: 10,
                ),
                buildProfileTile(context,
                    iconData: Icons.key_sharp,
                    title: "Manage API Key", onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeftWithFade,
                          child: const ApiKeyModify()));
                }),
                const SizedBox(
                  height: 10,
                ),
                buildProfileTile(context,
                    iconData: Icons.web_sharp,
                    title: "Manage Supported Websites", onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeftWithFade,
                          child: const SupportedWebsites()));
                }),
                const Spacer(),
                StyledButton(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => ConfirmModal(
                                backgroundColor: AppStyle.secondaryBackground,
                                title: 'Delete Account',
                                buttonColorYes: AppStyle.primaryError,
                                body:
                                    'Are you sure you want to delete your account? This action cannot be undone. However, you are always welcome to create a account.',
                                onYesTap: () async {
                                  var state = js.JsObject.fromBrowserObject(
                                      js.context['userState']);
                                  displayLoad();
                                  dynamic result = await promiseToFuture(
                                      deleteDocFromCloud(state['uid']));

                                  if (state["dataDeleted"] == true && result) {
                                    dynamic result = await promiseToFuture(
                                        deleteUserFromCloud());

                                    if (state['loggedIn'] == false && result) {
                                      Future.delayed(
                                          const Duration(milliseconds: 500),
                                          () {
                                        clearPrefs();
                                        Navigator.pop(context);
                                        Navigator.pushReplacement(
                                            context,
                                            PageTransition(
                                                child: const LoginPage(),
                                                type: PageTransitionType.fade));
                                      });
                                    } else if (state["error"] ==
                                        "auth/requires-recent-login") {
                                      Future.delayed(
                                          const Duration(milliseconds: 500),
                                          () {
                                        Navigator.pop(context);
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              StyledModalInput(
                                            buttonText: "Delete Account",
                                            backgroundColor:
                                                AppStyle.secondaryBackground,
                                            title: 'Deletion Error',
                                            body:
                                                'You need to reauthenticate to delete your account. Please provide your password to continue.',
                                            onTap: reauth,
                                            inputTextField: InputTextField(
                                              controller: passwordController,
                                              hintText: "Password",
                                              obscureText: true,
                                              textFieldBackgroundColor:
                                                  AppStyle.secondaryBackground,
                                              textFieldHintTextColor: AppStyle
                                                  .getTextFieldHintColor(),
                                              textFieldTextColor: AppStyle
                                                  .getTextFieldTextColor(),
                                              textFieldBorderColor:
                                                  Colors.grey.shade400,
                                              textFieldBorderFocusColor:
                                                  AppStyle.primaryAccent,
                                            ),
                                          ),
                                        );
                                      });
                                    }
                                  }
                                },
                                onNoTap: () {
                                  Navigator.pop(context);
                                },
                              ));
                    },
                    buttonColor: Colors.red,
                    buttonText: "Delete Account",
                    buttonTextColor: Colors.white,
                    margin: 60),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildProfileTile(
    BuildContext context, {
    required IconData iconData,
    required String title,
    required Function? onTap,
  }) {
    return ListTile(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        mouseCursor: SystemMouseCursors.click,
        onTap: () {
          if (onTap != null) {
            onTap();
          }
        },
        leading: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Icon(iconData, color: AppStyle.getIconColor(), size: 20)),
        title: Text(title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppStyle.getTextColor(), fontWeight: FontWeight.w600)),
        trailing: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 20,
            color: AppStyle.getIconColor(),
          ),
        ));
  }
}
