import 'dart:convert';
import 'package:ekinerja2020/laporan/bulan_lusa.dart';
import 'package:ekinerja2020/laporan/bulan_lalu.dart';
import 'package:ekinerja2020/laporan/setahun.dart';
import 'package:ekinerja2020/laporan/bulan_ini.dart';
import 'package:ekinerja2020/model/daftar_aktivitas.dart';
import 'package:ekinerja2020/verifikasi/util/show_functions.dart';
import 'package:flutter/material.dart';
import 'package:json_table/json_table.dart';
import 'package:intl/intl.dart';
import 'package:json_table/src/json_table_column.dart';
import 'package:ekinerja2020/service/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ThirdFragment extends StatelessWidget {
  // This widget is the root of your application.
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
  Widget build(BuildContext context) {
    MaterialColor colorCustom = MaterialColor(0xFFFF6C37, color);
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: colorCustom,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => RootPage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
//        '/customData': (context) => CustomDataTable(),
      },
    );
  }
}

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0), // here the desired height
          child: AppBar(
//            actions: [
//              FlatButton(
//                child: Text(
//                  "Pilih Tahun",
//                  style: TextStyle(color: Colors.white,),
//                ),
//                onPressed: () {
//                  //Buat milih tahun saja
//                  ShowFunctions.showToast(msg: "Action Pilih Tahun Belum Aktif");
//                  //Navigator.of(context).pushNamed('/customData');
//                },
//              )
//            ],
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  text: "Bulan ini",
                ),
                Tab(
                  text: "Kemarin",
                ),
                Tab(
                  text: "Lusa",
                ),
                Tab(
                  text: "1 Tahun",
                ),
              ],
            ),
        ),
        ),
        body: TabBarView(
          children: <Widget>[
            BulanIni(),
            BulanLalu(),
            BulanLusa(),
            Setahun(),
          ],
        ),
      ),
    );
  }
}
