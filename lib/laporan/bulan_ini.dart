import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_table/json_table.dart';
import 'package:json_table/src/json_table_column.dart';
import 'package:ekinerja2020/service/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BulanIni extends StatefulWidget {
//  final String idpns,tokenver;
//  BulanIni({Key key, @required this.idpns,@required this.tokenver}) : super(key: key);
  @override
  _BulanIniState createState() => _BulanIniState();
}

class _BulanIniState extends State<BulanIni> {
  ApiService api = new ApiService();
  late String tokenlogin;

  //DateTime date = new DateTime(now.year, now.month, now.day);
  var json;
//  final String jsonSample =
//      '[{"name":"Ram","email":"ram@gmail.com","age":23,"DOB":"1990-12-01"},'
//      '{"name":"Shyam","email":"shyam23@gmail.com","age":18,"DOB":"1995-07-01"},'
//      '{"name":"John","email":"john@gmail.com","age":10,"DOB":"2000-02-24"},'
//      '{"name":"Ram","age":12,"DOB":"2000-02-01"}]';
  bool toggle = true;
  late List<JsonTableColumn> columns;
  late String getData;

  void setJson() async{
    await getPref();
    DateTime now = new DateTime.now();
    api.laporanInividu(tokenlogin, now.month.toString(), now.year.toString()).then((data){
      setState(() {
        json = data;
      });
    });


  }

  @override
  void initState() {
    super.initState();

    setJson();
    //api.laporanInividu(tokenlogin, "03", "2018");
    //json = api.jsonku;
    //json = api.laporanInividu(tokenlogin, "03", "2018");
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
              onRowSelect: (index, map) {
                print(index);
                print(map);
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

//  String getPrettyJSONString(jsonObject) {
//    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
//    String jsonString = encoder.convert(json.decode(jsonObject));
//    return jsonString;
//  }

  String formatDOB(value) {
    var dateTime = DateFormat("yyyy-MM-dd").parse(value.toString());
    return DateFormat("d MMM yyyy").format(dateTime);
  }

  String eligibleToVote(value) {
    if (value >= 18) {
      return "Yes";
    } else
      return "No";
  }
}
