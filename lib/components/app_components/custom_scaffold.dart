import 'package:flutter/material.dart';
import 'package:solvify/components/app_components/custom_drawer.dart';
import 'package:solvify/styles/app_style.dart';

class CustomScaffold extends StatelessWidget {
  final Widget? child;
  final bool hideDrawer;
  final IconData? iconData;
  final bool? disable;
  const CustomScaffold({
    super.key,
    required this.child,
    required this.hideDrawer,
    this.iconData,
    this.disable,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: disable ?? false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: hideDrawer
              ? IconButton(
                  icon: Icon(
                    iconData,
                    color: AppStyle.primaryAccent,
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  })
              : null,
          automaticallyImplyLeading: hideDrawer ? false : true,
          backgroundColor: AppStyle.primaryBackground,
          iconTheme: IconThemeData(color: AppStyle.primaryAccent),
        ),
        drawer:
            const TooltipVisibility(visible: false, child: CustomerDrawer()),
        backgroundColor: AppStyle.primaryBackground,
        body: child,
      ),
    );
  }
}
