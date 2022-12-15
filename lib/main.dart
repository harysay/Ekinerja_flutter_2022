import 'dart:convert';
import 'package:ekinerja2020/UpdateApp.dart';
import 'package:ekinerja2020/pages/maintenancePage.dart';
import 'package:ekinerja2020/view/splash_screen.dart';
import 'package:flutter/material.dart';
// import 'login_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ekinerja2020/pages/home_page.dart';
//import 'x_home_page.dart';
import 'package:http/http.dart' as http;
import 'package:ekinerja2020/service/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:double_back_to_close/double_back_to_close.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

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
    final response = await http.get(Uri.parse(ApiService.urlUtama+"status/running"));
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
            brightness: Brightness.light,
            textTheme: TextTheme(
                bodyText1: TextStyle(
                    fontSize: 18,
                    fontFamily: 'BreeSerif',
                    height: 1.5
                ),
                bodyText2: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Nunito',
                    height: 1.5
                ),
                subtitle1: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Nunito',
                  // fontFamily: 'Pasifico',
                )
            ).apply(
              bodyColor: Colors.orange,
              displayColor: Colors.blue,
            )
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        home: DoubleBack(
          message:"Tekan sekali lagi untuk keluar",
          child: const SplashScreen(),
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
              brightness: Brightness.light,
              textTheme: TextTheme(
                  bodyText1: TextStyle(
                      fontSize: 18,
                      fontFamily: 'BreeSerif',
                      height: 1.5
                  ),
                  bodyText2: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Nunito',
                      height: 1.5
                  ),
                  subtitle1: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Nunito',
                    // fontFamily: 'Pasifico',
                  )
              ).apply(
                bodyColor: Colors.orange,
                displayColor: Colors.blue,
              )
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