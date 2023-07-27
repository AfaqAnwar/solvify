import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:solvify/styles/app_style.dart';

class RegisterOnboardHost extends StatefulWidget {
  const RegisterOnboardHost({super.key});

  @override
  State<RegisterOnboardHost> createState() => _RegisterOnboardHostState();
}

class _RegisterOnboardHostState extends State<RegisterOnboardHost> {
  int currentIndex = 0;
  int totalIndex = 3;

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            splashRadius: 0.1,
            color: AppStyle.primaryAccent,
            onPressed: () {},
          ),
        ),
        bottomNavigationBar: buildBottomNavBar(),
        backgroundColor: Colors.white,
        body: buildBody());
  }

  Widget buildBottomNavBar() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30),
        child: SafeArea(
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RawMaterialButton(
                    elevation: 0,
                    constraints: const BoxConstraints(
                      minWidth: 50,
                      minHeight: 50,
                    ),
                    fillColor: AppStyle.primaryAccent,
                    shape: const CircleBorder(),
                    onPressed: () {},
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildBody() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: SizedBox(
        child: SafeArea(
          child: Column(children: [
            buildDotStepper(),
            updateBodyContent(),
          ]),
        ),
      ),
    );
  }

  Widget updateBodyContent() {
    switch (currentIndex) {
      case 0:
        return const Text('Page 1');
      case 1:
        return const Text('Page 2');
      case 2:
        return const Text('Page 3');
      default:
        return const CircularProgressIndicator();
    }
  }

  Widget buildDotStepper() {
    return Column(
      children: [
        const SizedBox(height: 10),
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
              strokeColor: AppStyle.primaryLightAccent,
              strokeWidth: 1),
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}
