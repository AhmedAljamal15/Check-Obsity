import 'dart:async';
import 'package:check_obsity/Features/Home/View/home_view.dart';
import 'package:check_obsity/Features/onBoarding/view/onboarding_view.dart';
import 'package:check_obsity/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Call your timer function to navigate after 3 seconds
    startTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void startTimer() {
    Timer(const Duration(seconds: 3), () {
      // Navigate to the main screen after 3 seconds
      if (onboardingShown) {
        Get.offAll(() => const Homepage());
      } else {
        Get.offAll(() => const OnBoardingScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              fit: BoxFit.scaleDown,
              image: AssetImage("assets/persons/logo_splash.jpg"),
            ),
          ),
        ),
      ),
    );
  }
}
