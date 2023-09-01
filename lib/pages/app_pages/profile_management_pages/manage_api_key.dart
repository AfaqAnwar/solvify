import 'package:flutter/material.dart';
import 'package:solvify/components/app_components/custom_scaffold.dart';
import 'package:solvify/styles/app_style.dart';

class ManageAPIKey extends StatefulWidget {
  const ManageAPIKey({super.key});

  @override
  State<ManageAPIKey> createState() => _ManageAPIKeyState();
}

class _ManageAPIKeyState extends State<ManageAPIKey> {
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
                  "Manage API Key",
                  style: TextStyle(
                      fontFamily: AppStyle.currentMainHeadingFont.fontFamily,
                      color: AppStyle.primaryAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ));
  }
}
