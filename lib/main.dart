import 'dart:convert';
import 'package:ekinerja2020/UpdateApp.dart';
import 'package:ekinerja2020/pages/maintenancePage.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ekinerja2020/pages/home_page.dart';
//import 'x_home_page.dart';
import 'package:http/http.dart' as http;
import 'package:ekinerja2020/service/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:double_back_to_close/double_back_to_close.dart';

void main() => runApp(MyApp(

));

class MyApp extends StatefulWidget {
//  final routes = <String, WidgetBuilder>{
//    LoginPage.tag: (context) => LoginPage(),
//    //MaintenancePage.tag: (context) => MaintenancePage(),
//  };
  @override
  _MyApp createState() => new _MyApp();
}

class _MyApp extends State<MyApp> {
  String statusRun="1",tokenStatus;
  Map<int, Color> color =
  {
    50:Color.fromRGBO(136,14,79, .1),
    100:Color.fromRGBO(136,14,79, .2),
    200:Color.fromRGBO(136,14,79, .3),
    300:Color.fromRGBO(136,14,79, .4),
    400:Color.fromRGBO(136,14,79, .5),
    500:Color.fromRGBO(136,14,79, .6),
    600:Color.fromRGBO(136,14,79, .7),
    700:Color.fromRGBO(136,14,79, .8),
    800:Color.fromRGBO(136,14,79, .9),
    900:Color.fromRGBO(136,14,79, 1),
  };

  @override
  void initState() {
    super.initState();
    cekStatusRunning();
  }

  void cekStatusRunning() async{
    final response = await http.get(ApiService.baseStatusRunning);
    final stat = jsonDecode(response.body);
    setState(() {
      statusRun = stat['status'];
    });
  }


  @override
  Widget build(BuildContext context) {
    MaterialColor colorCustom;
    if(statusRun=="1"){
      colorCustom = MaterialColor(0xFFFF6C37, color);
      return MaterialApp(
        builder: (context,widget) => Navigator(
          onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => UpdateApp(
              child: widget,
            )
          ),
        ),
        title: 'E-Kinerja',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: colorCustom,
          fontFamily: 'Nunito',
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            title: TextStyle(fontSize: 20.0,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline),
            body1: TextStyle(fontSize: 18.0, fontFamily: 'Hind', height: 1.5),
          ),
        ),
        home: DoubleBack(
          message:"Tekan sekali lagi untuk keluar",
          child: LoginPage(),
        ),
//        home: LoginPage(),
//        routes: widget.routes,
      );
    }else{
      colorCustom = MaterialColor(0xFFFF6C37, color);
      return MaterialApp(
        title: 'E-Kinerja',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
//          primarySwatch: Colors.deepOrange,
          primarySwatch: colorCustom,
          fontFamily: 'Nunito',
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            title: TextStyle(fontSize: 20.0,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline),
            body1: TextStyle(fontSize: 18.0, fontFamily: 'Hind', height: 1.5),
          ),
        ),
        home: DoubleBack(
          message:"Tekan sekali lagi untuk keluar",
          child: MaintenancePage(),
        )
//        home: MaintenancePage(),//LoginPage(),
//        routes: widget.routes,
      );
    }

  }
}