import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_capstone_6/component/colors.dart';
import 'package:flutter_capstone_6/screen/onboarding_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SharedPreferences storageData;

  void initial() async {
    SharedPreferences.setMockInitialValues({});
    storageData = await SharedPreferences.getInstance();
    storageData.setBool('notifEmpty', true);
    storageData.setBool('isEdit', false);
  }

  @override
  void initState() {
    super.initState();
    splashScreenStart();
    initial();
  }

  splashScreenStart() async {
    var duration = const Duration(seconds: 2);
    return Timer(duration, () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const OnBoardingScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteBg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 5,
              fit: FlexFit.tight,
              child: SvgPicture.asset('assets/splash/work_fit.svg'),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: SvgPicture.asset('assets/splash/copyright.svg'),
            ),
          ],
        ),
      ),
    );
  }
}
