import 'package:flutter/material.dart';

class RegisterLoad extends StatefulWidget {
  const RegisterLoad({super.key});

  @override
  State<RegisterLoad> createState() => _RegisterLoadState();
}

class _RegisterLoadState extends State<RegisterLoad> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Register Load'),
      ),
    );
  }
}
