import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_table/json_table.dart';
import 'package:json_table/src/json_table_column.dart';
import 'package:ekinerja2020/service/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BulanLusa extends StatefulWidget {
  @override
  _BulanLusaState createState() => _BulanLusaState();
}

class _BulanLusaState extends State<BulanLusa> {
  ApiService api = new ApiService();
  late String tokenlogin;
  var json;
  bool toggle = true;
  late List<JsonTableColumn> columns;
  late String getData;

  void setJson() async{
    await getPref();
    DateTime now = new DateTime.now();
    var bulanLusa = now.month-2;
    var bulanKemarin = now.month-1;
    var tahunIni = now.year;
    if(bulanKemarin.toString()=="0"){
      bulanLusa = 11;
      tahunIni = now.year-1;
    }
    api.laporanInividu(tokenlogin, bulanLusa.toString(), tahunIni.toString()).then((data){
      setState(() {
        json = data;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setJson();
    columns = [
      JsonTableColumn("tgl_kinerja", label: "Tanggal"),
      JsonTableColumn("waktu_mengerjakan", label: "Menit Mengerjakan"),
      JsonTableColumn("waktu_diakui", label: "Menit Diakui"),
//      JsonTableColumn("honor_diakui", label: "Kinerja Diakui", defaultValue: "-"),
      JsonTableColumn("status_kinerja", label: "Status"),
    ];
  }

  Future<Null> getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      tokenlogin = preferences.getString("tokenlogin")!;
    });
  }

  @override
  Widget build(BuildContext context) {
//    var json = jsonDecode(jsonSample);
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: json == null ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Mohon tunggu sebentar..')
            ],
          ),
        ) : Column(
          children: <Widget>[
            JsonTable(
              json,
              columns: columns,
              showColumnToggle: true,
              allowRowHighlight: true,
              rowHighlightColor: Colors.yellow[500]!.withOpacity(0.7),
            ),
            SizedBox(
              height: 16.0,
            ),
//            Text(
//              getPrettyJSONString(jsonSample),
//              style: TextStyle(fontSize: 13.0),
//            ),
          ],
        ),
      ),
    );
  }
}
