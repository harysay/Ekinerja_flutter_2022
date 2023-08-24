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

  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      toHomePage();
    });

    super.initState();
  }

  toHomePage() {
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const PageLogin()));
    });
  }

  @override
  Widget build(BuildContext context) {
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
              child: Image.asset('assets/ekinerja2020.png'),
            ),
            const SizedBox(height: 25),
            const Text(
              "Selamat datang di\nAplikasi E-kinerja\nKabupaten Kebumen",
              style: TextStyle(fontSize: 16, fontFamily: 'Nunito'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25), // Tambahkan jarak antara Text dan CircularProgressIndicator
            CircularProgressIndicator(
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}