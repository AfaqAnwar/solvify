import 'package:flutter/material.dart';
import 'package:solvify/components/app_components/custom_drawer.dart';
import 'package:solvify/styles/app_style.dart';

class CustomScaffold extends StatelessWidget {
  final Widget? child;
  final bool hideDrawer;
  const CustomScaffold(
      {super.key, required this.child, required this.hideDrawer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: hideDrawer ? false : true,
        backgroundColor: AppStyle.primaryBackground,
        iconTheme: IconThemeData(color: AppStyle.primaryAccent),
      ),
      drawer: const TooltipVisibility(visible: false, child: CustomerDrawer()),
      backgroundColor: AppStyle.primaryBackground,
      body: child,
    );
  }
}
