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

//class ThirdFragment extends StatefulWidget {
//  @override
//  _ThirdFragmentState createState() => _ThirdFragmentState();
//}
//
//class _ThirdFragmentState extends State<ThirdFragment> {
//  ApiService api = new ApiService();
//  String tokenlogin;
//  var json;
////  final String jsonSample =
////      '[{"name":"Ram","email":"ram@gmail.com","age":23,"DOB":"1990-12-01"},'
////      '{"name":"Shyam","email":"shyam23@gmail.com","age":18,"DOB":"1995-07-01"},'
////      '{"name":"John","email":"john@gmail.com","age":10,"DOB":"2000-02-24"},'
////      '{"name":"Ram","age":12,"DOB":"2000-02-01"}]';
//  bool toggle = true;
//  List<JsonTableColumn> columns;
//  String getData;
//
//  void setJson()  {
//
//    api.laporanInividu(tokenlogin, "03", "2018").then((data){
//      setState(() {
//        json = data;
//      });
//    });
//
//
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    setJson();
//    getPref();
//    //api.laporanInividu(tokenlogin, "03", "2018");
//    //json = api.jsonku;
//    //json = api.laporanInividu(tokenlogin, "03", "2018");
//    columns = [
//      JsonTableColumn("tgl_kinerja", label: "Tanggal"),
//      JsonTableColumn("waktu_mengerjakan", label: "Menit Mengerjakan"),
//      JsonTableColumn("waktu_diakui", label: "Menit Diakui"),
//      JsonTableColumn("honor_diakui", label: "Kinerja Diakui", defaultValue: "0"),
//      JsonTableColumn("status_kinerja", label: "Status"),
//    ];
////    columns = [
////      JsonTableColumn("name", label: "Name"),
////      JsonTableColumn("age", label: "Age"),
////      JsonTableColumn("DOB", label: "Date of Birth", valueBuilder: formatDOB),
////      JsonTableColumn("age",
////          label: "Eligible to Vote", valueBuilder: eligibleToVote),
////      JsonTableColumn("email", label: "E-mail", defaultValue: "NA"),
////    ];
//
//  }
//
//  Future<Null> getPref() async {
//    SharedPreferences preferences = await SharedPreferences.getInstance();
//    setState(() {
//      tokenlogin = preferences.getString("tokenlogin");
//    });
//  }
//
//
//
//
//  @override
//  Widget build(BuildContext context) {
////    var json = jsonDecode(jsonSample);
//    return Scaffold(
//      body: SingleChildScrollView(
//        padding: EdgeInsets.all(16.0),
//        child: json == null ? Center(
//          child: CircularProgressIndicator(),
//        ) : Column(
//          children: <Widget>[
//            JsonTable(
//              json,
//              columns: columns,
//              showColumnToggle: true,
//              allowRowHighlight: true,
//              rowHighlightColor: Colors.yellow[500].withOpacity(0.7),
//            ),
//            SizedBox(
//              height: 16.0,
//            ),
////            Text(
////              getPrettyJSONString(jsonSample),
////              style: TextStyle(fontSize: 13.0),
////            ),
//          ],
//        ),
//      ),
//    );
//  }
//
////  String getPrettyJSONString(jsonObject) {
////    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
////    String jsonString = encoder.convert(json.decode(jsonObject));
////    return jsonString;
////  }
//
//  String formatDOB(value) {
//    var dateTime = DateFormat("yyyy-MM-dd").parse(value.toString());
//    return DateFormat("d MMM yyyy").format(dateTime);
//  }
//
//  String eligibleToVote(value) {
//    if (value >= 18) {
//      return "Yes";
//    } else
//      return "No";
//  }
//}