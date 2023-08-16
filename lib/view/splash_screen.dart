import 'dart:async';

import 'package:ekinerja2020/pages/home_page.dart';
import 'package:ekinerja2020/pages/page_login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isVisible = false;

  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      setState(() {
        isVisible = true;
      });

      toHomePage();
    });

    super.initState();
  }

  getStatusLogin(){

  }

  toHomePage() {
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const PageLogin()));
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                  duration: const Duration(seconds: 2),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: isVisible
                      ? Image.asset('assets/ekinerja2020.png')
                      : const SizedBox()),
              const SizedBox(height: 25),
              const Text("Welcome the app..", style: TextStyle(fontSize: 18)),
              isVisible ? const Align(
                //alignment: FractionalOffset.bottomCenter,
                  heightFactor: 5,
                  alignment: Alignment.bottomCenter,
                  child: CircularProgressIndicator(
                    color: Colors.grey,
                  )) :const SizedBox()
            ],
          )),
    );
  }
}