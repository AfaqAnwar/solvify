import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solvify/components/app_components/custom_scaffold.dart';
import 'package:solvify/components/generic_components/confirm_modal.dart';
import 'package:solvify/components/generic_components/styled_button.dart';
import 'package:solvify/firebase_js.dart';
import 'package:solvify/pages/app_pages/profile_management_pages/manage_email.dart';
import 'package:solvify/pages/app_pages/profile_management_pages/manage_password.dart';
import 'package:solvify/pages/app_pages/profile_management_pages/manage_subscription.dart';
import 'package:solvify/pages/signin_signup/login_page.dart';
import 'package:solvify/styles/app_style.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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
                      fontFamily: GoogleFonts.karla().fontFamily,
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
                    iconData: Icons.payment_sharp,
                    title: "Manage Subscription", onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeftWithFade,
                          child: const ManageSubscription()));
                }),
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
                                  await signUserOut();
                                  Future.delayed(
                                      const Duration(milliseconds: 500), () {
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                            child: const LoginPage(),
                                            type: PageTransitionType.fade));
                                  });
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
