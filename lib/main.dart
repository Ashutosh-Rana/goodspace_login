import 'package:flutter/material.dart';
import 'package:goodspace_login/screens/home_screen.dart';
import 'package:goodspace_login/screens/login_screen.dart';
import 'package:goodspace_login/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        "/login_screen_route":(context) => LoginScreen(),
        // "/otp_screen_route":(context) => OTPScreen(phone: "",),
        "/home_screen_route":(context) => HomeScreen(),
      },
    );
  }
}
