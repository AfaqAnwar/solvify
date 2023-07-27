import 'package:flutter/material.dart';

class RegisterOnboard extends StatefulWidget {
  const RegisterOnboard({super.key});

  @override
  State<RegisterOnboard> createState() => _RegisterOnboardState();
}

class _RegisterOnboardState extends State<RegisterOnboard> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Register Onboard'),
      ),
    );
  }
}
