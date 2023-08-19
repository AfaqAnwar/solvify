import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solvify/components/app_components/custom_scaffold.dart';
import 'package:solvify/styles/app_style.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void setSharedState() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString("currentPage", "info");
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
                  "FAQs",
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
                    child: Theme(
                      data: ThemeData(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      child: ExpansionTileGroup(
                        toggleType: ToggleType.expandOnlyCurrent,
                        children: [
                          ExpansionTileWithoutBorderItem(
                            collapsedIconColor: AppStyle.getIconColor(),
                            title: Text(
                              "How accurate is Solvify?",
                              style: TextStyle(
                                  fontFamily: AppStyle
                                      .currentMainHeadingFont.fontFamily,
                                  color: AppStyle.faqTextHeading,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                            children: [
                              Text(
                                  "While Solvify aims to provide the best answers possible, it's important to note that not all answers are 100% accurate. Like any tool, it's essential to double-check results and use them as a guide rather than a definitive solution.",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w100,
                                      color: AppStyle.getTextColor())),
                            ],
                          ),
                          ExpansionTileWithoutBorderItem(
                            collapsedIconColor: AppStyle.getIconColor(),
                            title: Text(
                              "Does Solvify support all subjects and topics?",
                              style: TextStyle(
                                  fontFamily: AppStyle
                                      .currentMainHeadingFont.fontFamily,
                                  color: AppStyle.faqTextHeading,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                            children: [
                              Text(
                                "Solvify is designed to cover a broad range of subjects and topics. However, its effectiveness might vary depending on the complexity and specificity of the problem. If you find that your topic isn't covered, please provide feedback so we can continue to improve the extension.",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w100,
                                    color: AppStyle.getTextColor()),
                              ),
                            ],
                          ),
                          ExpansionTileWithoutBorderItem(
                            collapsedIconColor: AppStyle.getIconColor(),
                            title: Text(
                              "How does Solvify ensure my data privacy?",
                              style: TextStyle(
                                  fontFamily: AppStyle
                                      .currentMainHeadingFont.fontFamily,
                                  color: AppStyle.faqTextHeading,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                            children: [
                              Text(
                                "We value user privacy. Solvify only scans the content of your current tab and does not store or share your data. All operations are carried out locally without transmitting any personal or sensitive information to external servers.",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w100,
                                    color: AppStyle.getTextColor()),
                              ),
                            ],
                          ),
                          ExpansionTileWithoutBorderItem(
                            collapsedIconColor: AppStyle.getIconColor(),
                            title: Text(
                              "What if Solvify can't solve my problem?",
                              style: TextStyle(
                                  fontFamily: AppStyle
                                      .currentMainHeadingFont.fontFamily,
                                  color: AppStyle.faqTextHeading,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                            children: [
                              Text(
                                "If Solvify can't provide an answer or solution to your problem, we recommend seeking alternative resources or consulting with your educators. Remember, Solvify is a tool to aid in your studies, not a replacement for traditional learning and teaching methods.",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w100,
                                    color: AppStyle.getTextColor()),
                              ),
                            ],
                          ),
                          ExpansionTileWithoutBorderItem(
                            collapsedIconColor: AppStyle.getIconColor(),
                            title: Text(
                              "Can I use Solvify during exams or tests?",
                              style: TextStyle(
                                  fontFamily: AppStyle
                                      .currentMainHeadingFont.fontFamily,
                                  color: AppStyle.faqTextHeading,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                            ),
                            children: [
                              Text(
                                "Using Solvify or any other tool to assist you during exams or tests without permission is considered cheating. Always adhere to your institution's guidelines and rules regarding the use of external tools and resources.",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w100,
                                    color: AppStyle.getTextColor()),
                              ),
                            ],
                          ),
                          ExpansionTileWithoutBorderItem(
                            collapsedIconColor: AppStyle.getIconColor(),
                            title: Text(
                              "How can I provide feedback or report issues with Solvify?",
                              style: TextStyle(
                                  fontFamily: AppStyle
                                      .currentMainHeadingFont.fontFamily,
                                  color: AppStyle.faqTextHeading,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                            ),
                            children: [
                              Text(
                                "We value user feedback and are always looking to improve Solvify. If you have suggestions or encounter any issues, please contact our support team at support@solvify.app",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w100,
                                    color: AppStyle.getTextColor()),
                              ),
                            ],
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ));
  }
}
