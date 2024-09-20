import 'package:flutter/material.dart';
import 'dart:async';

import 'package:nezaja_labeik/main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (_) =>
                HomePage()), // Replace with the actual main screen widget
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: Image.asset(
            'assets/images/launch_background_2.png'), // Ensure this matches your asset
      ),
    ));
  }
}
