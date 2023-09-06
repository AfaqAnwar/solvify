// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
// ignore: avoid_web_libraries_in_flutter
import 'dart:js_util';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solvify/components/app_components/custom_scaffold.dart';
import 'package:solvify/components/generic_components/input_textfield.dart';
import 'package:solvify/components/generic_components/styled_modal.dart';
import 'package:solvify/components/generic_components/styled_modal_input.dart';
import 'package:solvify/firebase_js.dart';
import 'package:solvify/styles/app_style.dart';
import 'package:validator_regex/validator_regex.dart';

class SupportedWebsites extends StatefulWidget {
  const SupportedWebsites({super.key});

  @override
  State<SupportedWebsites> createState() => _SupportedWebsitesState();
}

class _SupportedWebsitesState extends State<SupportedWebsites> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<String> websites = [];
  final websiteController = TextEditingController();
  String websiteLink = "";
  List<Widget> websiteTiles = [];

  void getSharedState() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      websites = prefs.getStringList("websites") ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    getSharedState();
  }

  bool validateWebsite(String website) {
    if (website.isEmpty) return false;

    return Validator.url(website);
  }

  void modifyWebsiteLink(String website) {
    // Adding "https://"
    if (!website.startsWith('https://')) {
      website = 'https://$website';
    }

    // Adding "www."
    if (!website.startsWith('https://www.')) {
      website = website.replaceFirst('https://', 'https://www.');
    }

    // Adding trailing "/"
    if (!website.endsWith('/')) {
      website += '/';
    }

    websiteLink = website;
  }

  Future addWebsiteToLocalLists(String website) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      websites.insert(0, website);
      prefs.setStringList("websites", websites);
    });
  }

  Future removeWebsiteFromLocalLists(String website) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      websites.remove(website);
      prefs.setStringList("websites", websites);
    });
  }

  Future updateWebsiteListToFirebase(List<String> sites) async {
    var result = await promiseToFuture(updateWebsites(sites));
    return result;
  }

  void displayError(String errorMessage) {
    switch (errorMessage) {
      case "invalid-website":
        errorMessage = "You entered an invalid website. Please try again.";
        break;
      default:
        errorMessage =
            "An unknown error occurred while updating your website list please try again.";
    }
    showDialog(
        context: context,
        builder: (context) => StyledModal(
              backgroundColor: AppStyle.secondaryBackground,
              title: 'Update Error',
              body: errorMessage.toString(),
              onTap: () => Navigator.pop(context),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        hideDrawer: true,
        iconData: Icons.arrow_back_ios_new_sharp,
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                Text(
                  "Supported Websites",
                  style: TextStyle(
                      fontFamily: AppStyle.currentMainHeadingFont.fontFamily,
                      color: AppStyle.primaryAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.w800),
                ),
                ListTile(
                  trailing: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return StyledModalInput(
                                  backgroundColor: AppStyle.secondaryBackground,
                                  title: "Add Website",
                                  body: "Enter the website you want to add.",
                                  buttonText: "Add",
                                  inputTextField: InputTextField(
                                    controller: websiteController,
                                    hintText: "https://www.website.com/",
                                    obscureText: false,
                                    textFieldBackgroundColor:
                                        AppStyle.secondaryBackground,
                                    textFieldHintTextColor:
                                        AppStyle.getTextFieldHintColor(),
                                    textFieldTextColor:
                                        AppStyle.getTextFieldTextColor(),
                                    textFieldBorderColor: Colors.grey.shade400,
                                    textFieldBorderFocusColor:
                                        AppStyle.primaryAccent,
                                  ),
                                  onTap: () async {
                                    modifyWebsiteLink(
                                        websiteController.text.trim());

                                    if (validateWebsite(websiteLink)) {
                                      await addWebsiteToLocalLists(websiteLink);

                                      var result =
                                          await updateWebsiteListToFirebase(
                                              websites);

                                      if (result == true) {
                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);
                                      } else {
                                        displayError("unknown-error");
                                      }
                                    } else {
                                      displayError("invalid-website");
                                    }
                                  });
                            });
                      },
                      child: Icon(
                        Icons.add_sharp,
                        color: AppStyle.primaryAccent,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: buildListOfTiles(websites),
                  ),
                ),
                const SizedBox(
                  height: 25,
                )
              ],
            ),
          ),
        ));
  }

  List<Widget> buildListOfTiles(List<String> websites) {
    List<Widget> tiles = [];

    for (String website in websites) {
      tiles.add(
        ListTile(
          title: AutoSizeText(
            maxLines: 1,
            overflow: TextOverflow.clip,
            website,
            style: TextStyle(
                color: AppStyle.getTextColor(),
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          trailing: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () async {
                await removeWebsiteFromLocalLists(website);

                var result = await updateWebsiteListToFirebase(websites);

                if (result == false) {
                  displayError("unknown-error");
                }
              },
              child: Icon(
                Icons.remove_sharp,
                color: AppStyle.primaryAccent,
              ),
            ),
          ),
        ),
      );
    }

    return tiles;
  }
}
