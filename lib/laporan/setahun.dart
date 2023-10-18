import 'dart:convert';

import 'package:ekinerja2020/verifikasi/util/show_functions.dart';
import 'package:flutter/material.dart';
import 'package:json_table/json_table.dart';
import 'package:json_table/src/json_table_column.dart';
import 'package:ekinerja2020/service/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setahun extends StatefulWidget {
  @override
  _SetahunState createState() => _SetahunState();
}

class _SetahunState extends State<Setahun> {
  ApiService api = new ApiService();
  late String tokenlogin;
  var json;
  bool toggle = true;
  late List<JsonTableColumn> columns;
  late String getData;

  void setJson() async{
    //await getPref();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    tokenlogin = preferences.getString("tokenlogin")!;
    DateTime now = new DateTime.now();
    api.laporanInividuTahunan(tokenlogin, now.year.toString()).then((data){
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
      JsonTableColumn("bulan", label: "Bulan"),
      JsonTableColumn("tahun", label: "Tahun"),
      JsonTableColumn("waktu_mengerjakan", label: "Waktu Mengerjakan"),
      JsonTableColumn("waktu_diakui", label: "Waktu Diakui"),
      JsonTableColumn("honor_diakui", label: "Honor Diakui"),
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
              Text('Mungkin membutuhkan waktu lebih untuk ini..')
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
              onRowSelect: (index, map) {
                ShowFunctions.showToast(msg: map.toString()+"Telah diklik");
              },
              // tableHeaderBuilder: (String header) {
              //   return Container(
              //     padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              //     decoration: BoxDecoration(border: Border.all(width: 0.5),color: Colors.grey[300]),
              //     child: Text(
              //       header,
              //       textAlign: TextAlign.center,
              //       style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.0,color: Colors.black87),
              //     ),
              //   );
              // },
              tableCellBuilder: (value) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                  decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.grey.withOpacity(0.5))),
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.0, color: Colors.grey[900]),
                  ),
                );
              },
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
