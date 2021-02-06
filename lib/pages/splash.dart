import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() {
    Timer(
        Duration(seconds: 1),
        () => Navigator.of(context)
            .pushNamedAndRemoveUntil('login', (r) => false));
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Center(
            child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 98.0, left: 16, right: 16),
                child: Image.asset('assets/logo.png')),
          ),
        ),
      ),
    );
  }
}
