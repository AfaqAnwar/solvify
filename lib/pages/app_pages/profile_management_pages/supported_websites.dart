import 'package:flutter/material.dart';
import 'package:solvify/components/app_components/custom_scaffold.dart';
import 'package:solvify/styles/app_style.dart';

class SupportedWebsites extends StatefulWidget {
  const SupportedWebsites({super.key});

  @override
  State<SupportedWebsites> createState() => _SupportedWebsitesState();
}

class _SupportedWebsitesState extends State<SupportedWebsites> {
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
                  "Manage Supported Websites",
                  style: TextStyle(
                      fontFamily: AppStyle.currentMainHeadingFont.fontFamily,
                      color: AppStyle.primaryAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                const SizedBox(
                  height: 25,
                )
              ],
            ),
          ),
        ));
  }
}
