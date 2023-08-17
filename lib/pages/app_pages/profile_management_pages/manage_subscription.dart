import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solvify/components/app_components/custom_scaffold.dart';
import 'package:solvify/styles/app_style.dart';

class ManageSubscription extends StatefulWidget {
  const ManageSubscription({super.key});

  @override
  State<ManageSubscription> createState() => _ManageSubscription();
}

class _ManageSubscription extends State<ManageSubscription> {
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
                  "Manage Subscription",
                  style: TextStyle(
                      fontFamily: GoogleFonts.karla().fontFamily,
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
