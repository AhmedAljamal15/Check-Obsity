// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:check_obsity/Features/Home/View/home_view.dart';
import 'package:check_obsity/Core/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  bool isVisible = true;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => isVisible = !isVisible);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 60.h),
          Text(
            "Check Obesity",
            style: TextStyle(
              color: AppColors.normalBMIColor,
              fontWeight: FontWeight.bold,
              fontSize: ScreenUtil().setSp(48.0),
              fontFamily: 'RubikBold',
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Text(
              "Check your Obesity and Health Status",
              style: TextStyle(
                color: AppColors.normalBMIColor,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil().setSp(30.0),
                fontFamily: 'RubikRegular',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 60.h),
          AnimatedOpacity(
            opacity: isVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 1000),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(AppColors.normalBMIColor),
                minimumSize: MaterialStatePropertyAll(Size(300, 55)),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool('showHome', true);
                Get.offAll(() => Homepage());
              },
              child: Text(
                "Get Started",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil().setSp(26.0),
                  fontFamily: 'RubikBold',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
