import 'dart:async';
import 'dart:convert';
import 'package:flutter_capstone_6/screen/login/login_screen.dart';
import 'package:flutter_capstone_6/screen/main/home/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../widget/bottom_navigation.dart';
import 'global_data.dart';

class InitPage extends StatelessWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _InitPage();
  }
}

class _InitPage extends StatefulWidget {
  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<_InitPage> {
  late Timer timer;

  String checkData() {
    if (GlobalData.of(context)?.getData("password") == null &&
        GlobalData.of(context)?.getData("email") == null) {
      return 'false';
    }

    if (GlobalData.of(context)?.getData("password") != null &&
        GlobalData.of(context)?.getData("email") != null) {
      return 'true';
    }
    return 'false';
  }

  Future _direction() async {
    await GlobalData.of(context)?.refreshData();
    if (checkData() == 'true') {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => (HomeScreen(
                token: '',
              ))));
    } else if (checkData() == 'false') {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => (LoginScreen())));
    }
  }

  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 1300), () {
      _direction();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Container()),
    );
  }
}
