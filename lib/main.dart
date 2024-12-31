import 'dart:convert';
import 'package:ekinerja2020/UpdateApp.dart';
import 'package:ekinerja2020/pages/maintenancePage.dart';
import 'package:ekinerja2020/pages/page_login.dart';
import 'package:ekinerja2020/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ekinerja2020/pages/home_page.dart';
import 'package:ekinerja2020/service/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: "Aplikasi E-kinerja",
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context,widget) => Navigator(
        onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => UpdateApp(
              child: widget!,
            )
        ),
      ),
      title: 'E-Kinerja',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFFFF6C37), // Atur warna latar belakang header menjadi orange
            foregroundColor: Colors.white, // Atur warna teks header menjadi putih
          ),
          brightness: Brightness.light,
          textTheme: TextTheme(
              bodyLarge: TextStyle(
                  fontSize: 18,
                  fontFamily: 'BreeSerif',
                  height: 1.5
              ),
              bodyMedium: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Nunito',
                  height: 1.5
              ),
              titleMedium: TextStyle(
                fontSize: 14,
                fontFamily: 'Nunito',
                // fontFamily: 'Pasifico',
              )
          ).apply(
            bodyColor: Colors.black,
            displayColor: Colors.blue,
          )
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? statusRun;
  var valueLogin;

  @override
  void initState() {
    super.initState();
    cekPertamaKali();
  }

  void cekStatusRunning() async {
    final response = await http.get(Uri.parse(ApiService.urlUtama + "status/running"));
    final stat = jsonDecode(response.body);
    statusRun = stat['status'];
    if (statusRun == "1") {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      valueLogin = preferences.getBool("is_login");
      // _loginStatus = value == true ? LoginStatus.signIn : LoginStatus.notSignIn;
      if (valueLogin==true) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()),);
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PageLogin()),);
      }
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MaintenancePage()),);
    }
  }

  void cekPertamaKali()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('first_time') ?? true;
    if (isFirstTime) {
      await prefs.setBool('first_time', false);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SplashScreen()),);
    } else {
      cekStatusRunning();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(),
      // Tidak perlu menampilkan halaman awal apa pun di sini
    );
  }
}


