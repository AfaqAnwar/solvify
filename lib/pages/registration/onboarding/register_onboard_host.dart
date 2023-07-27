import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solvify/components/generic_components/styled_modal.dart';
import 'package:solvify/pages/registration/onboarding/register_onboard_first_page.dart';
import 'package:solvify/pages/registration/onboarding/register_onboard_second_page.dart';
import 'package:solvify/pages/registration/onboarding/register_onboard_third_page.dart';
import 'package:solvify/pages/signin_signup/login_page.dart';
import 'package:solvify/styles/app_style.dart';

class RegisterOnboardHost extends StatefulWidget {
  const RegisterOnboardHost({super.key});

  @override
  State<RegisterOnboardHost> createState() => _RegisterOnboardHostState();
}

class _RegisterOnboardHostState extends State<RegisterOnboardHost> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int currentIndex = 0;
  int totalIndex = 3;
  String buttonText = "Next";

  void setSharedState() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString("currentPage", "register_onboard_0");
    });
  }

  void parseCurrentIndex() async {
    final SharedPreferences prefs = await _prefs;
    prefs.getString("currentPage");
    List<String> splitString = prefs.getString("currentPage")!.split("_");
    currentIndex = int.parse(splitString[2]);
  }

  @override
  void initState() {
    super.initState();
    setSharedState();
    parseCurrentIndex();
  }

  void updateIndex() {
    if (currentIndex < totalIndex - 1) {
      setState(() {
        currentIndex++;
      });
    }
  }

  void updateIndexBackwards() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    } else {
      showPopUp();
    }
  }

  void showPopUp() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StyledModal(
            backgroundColor: AppStyle.primaryBackground,
            title: "Are you sure?",
            body:
                "You will be logged out of your account and redirected to the login page.",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade, child: const LoginPage()));
            },
          );
        });
  }

  void updateButtonText() {
    if (currentIndex == totalIndex - 1) {
      setState(() {
        buttonText = "Let's Go!";
      });
    } else {
      setState(() {
        buttonText = "Next";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppStyle.primaryBackground,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            splashRadius: 0.1,
            color: AppStyle.primaryAccent,
            onPressed: () {
              updateIndexBackwards();
            },
          ),
        ),
        backgroundColor: AppStyle.primaryBackground,
        body: buildBody());
  }

  Widget buildBottomNavBar() {
    return Center(
      child: GestureDetector(
        onTap: () {
          updateIndex();
        },
        child: Container(
          padding: const EdgeInsets.all(35),
          decoration: BoxDecoration(
            color: AppStyle.primaryAccent,
          ),
          child: Center(
              child: Text(
            buttonText,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          )),
        ),
      ),
    );
  }

  Widget buildBody() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 5),
          buildDotStepper(),
          const SizedBox(height: 15),
          Text("HOW SOLVIFY WORKS",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppStyle.primaryAccent)),
          Expanded(child: Container()),
          updateBodyContent(),
          Expanded(child: Container()),
          buildBottomNavBar(),
        ]);
  }

  Widget updateBodyContent() {
    updateButtonText();
    switch (currentIndex) {
      case 0:
        return const RegisterOnboardFirstPage();
      case 1:
        return const RegisterOnboardSecondPage();
      case 2:
        return const RegisterOnboardThirdPage();
      default:
        return const CircularProgressIndicator();
    }
  }

  Widget buildDotStepper() {
    return Column(
      children: [
        DotStepper(
          tappingEnabled: false,
          dotCount: totalIndex,
          dotRadius: 6,
          activeStep: currentIndex,
          shape: Shape.circle,
          spacing: 8,
          indicator: Indicator.shift,
          fixedDotDecoration: FixedDotDecoration(
              color: Colors.grey.shade400,
              strokeColor: Colors.grey.shade400,
              strokeWidth: 1),
          indicatorDecoration: IndicatorDecoration(
              color: AppStyle.primaryAccent,
              strokeColor: AppStyle.primaryAccent,
              strokeWidth: 1),
        ),
      ],
    );
  }
}
