import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double logoSize = 200.0;
  bool showName = false;
  @override
  void initState() {
    super.initState();

    Timer(
      Duration(seconds: 1),
      () {
        setState(() {
          logoSize = 100.0; 
        });
      },
    );
    Timer(
      Duration(seconds: 2),
      () {
        setState(() {
          showName = true;
        });
      },
    );
    Timer(
      Duration(seconds: 3),
      () {
        Navigator.pushReplacementNamed(
          context,
          "/login_screen_route",
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff399ffe),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(seconds: 1),
              width: logoSize,
              height: logoSize,
              child: Image.asset(
                'assets/images/logo.png',
              ),
            ),
            SizedBox(height: 16),
            if (showName) ...{
              Image.asset(
                'assets/images/name.png',
                fit: BoxFit.cover,
              ),
            }
          ],
        ),
      ),
    );
  }
}
