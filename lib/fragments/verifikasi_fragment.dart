import 'package:ekinerja2020/verifikasi/halVerifikasi.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ekinerja2020/model/daftar_pegawaiverifikasi.dart';
import 'package:ekinerja2020/service/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

ApiService api = new ApiService();
//void main() => runApp(VerifikasiFragment());

//class VerifikasiFragment extends StatelessWidget {
//
////  final String title;
////  final String description;
//
//  //VerifikasiFragment(this.title, this.description);
//  //VerifikasiFragment({Key key, @required this.todos}) : super(key: key);
//
//
//
//  @override
//  Widget build(BuildContext context) {
//
//    return JsonImageList();
////    return MaterialApp(
//  //    debugShowCheckedModeBanner: false,
////      home: Scaffold(
////        body: JsonImageList(),
////      ),
////    );
//
//  }
//}


class VerifikasiFragment extends StatefulWidget {

  JsonImageListWidget createState() => JsonImageListWidget();

}

class JsonImageListWidget extends State<VerifikasiFragment> {
  String tokenlistaktivitas;

  @override
  void initState() {
    // TODO: implement initState
    getPref();
    super.initState();
  }
  Future<Null> getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      tokenlistaktivitas = preferences.getString("tokenlogin");
    });
  }
  selectedItem(BuildContext context, String holder) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(holder),
          actions: <Widget>[
            FlatButton(
              child: new Text("OK"),
        onPressed: () {
        Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DaftarPegawaiVerifikasi>>(
      future: api.getAllPegawaiVer(tokenlistaktivitas),
      builder: (context, snapshot) {

        if (!snapshot.hasData) return Center(
            child: CircularProgressIndicator()
        );

        return ListView(
          padding: EdgeInsets.only(top: 15.0),
          children: snapshot.data
              .map((data) => Column(children: <Widget>[
            GestureDetector(
              onTap: (){Navigator.push(
                //selectedItem(context, data.idNipBaru);
                context,
                MaterialPageRoute(
//                  builder: (context) => HalamanVerifikasi(todo: data.idPns),
                    builder: (context) => HalVerif(idpns: data.idPns,tokenver: tokenlistaktivitas,),
                ),
              );},
              child: Container(
                height: 140,
                child: Card( child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    child: ListTile(
                      leading:
                      CircleAvatar(
                        radius: 30.0,
                        backgroundImage:
                        NetworkImage(data.foto),
                        backgroundColor: Colors.transparent,
                      ),
//                leading: Column(
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                Image.network(data.foto, width: 100, height: 100, fit: BoxFit.cover,)
//                  ],
//                ),
                      title: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(child: new Text(data.namaPgawai,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)))
                          ]
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(" "+data.idNipBaru,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                          Text(" Sudah diakui: "+data.menitSudah+" jam",style: TextStyle(fontSize: 16)),
                          Text(" Bulan ini belum: "+data.belumVerBlnIni,style: TextStyle(fontSize: 16)),
                          Text(" Bulan kemarin belum: "+data.belumVerBlnLalu,style: TextStyle(fontSize: 16)),

                        ],
                      ),
//                    subtitle: Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: <Widget>[
//                        Flexible(child: new Text(" "+data.idNipBaru,style: TextStyle(fontSize: 16))),
//                        Flexible(child: new Text(" Waktu diakui: "+data.menitSudah,style: TextStyle(fontSize: 16))),
////                          Visibility(
////                            child: Text(data.idPns,style: TextStyle(fontSize: 10)),
////                            maintainSize: true,
////                            maintainAnimation: true,
////                            maintainState: true,
////                            visible: false,
////                          ),
//                        //Text(aktivitas.uraianPekerjaan)
//                      ]
//                    ),


                    ),
                  ),
                ),
                ),
              )

                //Jika ingin pakain custom listview gunakan source berikut
//              child: Row(
//                  children: [
//                    Container(
//                        width: 100,
//                        height: 100,
//                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
//                        child: ClipRRect(
//                            borderRadius: BorderRadius.circular(8.0),
//                            child:
//                            Image.network(data.foto,
//                              width: 100, height: 100, fit: BoxFit.cover,))),
//                    Column(
//                      children: [
//                        Text(data.namaPgawai,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold)),
//                        Text(data.idNipBaru,style: TextStyle(fontSize: 16)),
//                      ],
//                    ),
//                  ]),
            ),

            //Divider(color: Colors.black),

          ],))
              .toList(),
        );
      },
    );
  }
}