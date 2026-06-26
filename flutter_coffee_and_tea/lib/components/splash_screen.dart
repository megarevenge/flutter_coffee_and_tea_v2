import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_coffee_and_tea/components/onboarding_screen.dart';
import 'package:flutter_coffee_and_tea/pages/auth_page.dart';

class SplashScreen extends StatefulWidget {
  final bool showHome;

  const SplashScreen({super.key, required this.showHome});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              widget.showHome ? AuthPage() : OnboardingScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFBF5),
      body: Center(
        child: Image.asset(
          'assets/splash.gif',
          width: 402, // Customize sizes as needed
          height: 874,
          fit: BoxFit.cover,
        ),
      ),
      
    );
  }
}
