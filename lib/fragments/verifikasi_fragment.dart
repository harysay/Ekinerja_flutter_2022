import 'package:ekinerja2020/verifikasi/halVerifikasi.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ekinerja2020/model/daftar_pegawaiverifikasi.dart';
import 'package:ekinerja2020/service/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

ApiService api = new ApiService();
//void main() => runApp(VerifikasiFragment());

class VerifikasiFragment extends StatefulWidget {

  JsonImageListWidget createState() => JsonImageListWidget();

}

class JsonImageListWidget extends State<VerifikasiFragment> {
  late Future<List<DaftarPegawaiVerifikasi>?> futureData;
  final ApiService api = ApiService();
  String tokenlistaktivitas="";
  _getRequests()async{
    setState(() {});
    _refreshData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  Future<void> _refreshData() async {
    setState(() {
      futureData = api.getAllPegawaiVer(tokenlistaktivitas);
    });
  }

  Future<Null> getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      tokenlistaktivitas = preferences.getString("tokenlogin")!;
      futureData = api.getAllPegawaiVer(tokenlistaktivitas);
    });
  }
  selectedItem(BuildContext context, String holder) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(holder),
          actions: <Widget>[
            TextButton(
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
    return FutureBuilder<List<DaftarPegawaiVerifikasi>?>(
      future: futureData, //api.getAllPegawaiVer(tokenlistaktivitas),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(
            child: CircularProgressIndicator()
        );

        return RefreshIndicator(
          onRefresh: _refreshData,
          child: ListView(
            padding: EdgeInsets.only(top: 15.0),
            children: snapshot.data!
                .map((data) => Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    // Navigate to HalVerif page and wait for result
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HalVerif(idpns: data.idPns!, tokenver: tokenlistaktivitas)),
                    );
                    if (result == true) {
                      // If result is true, refresh data
                      _getRequests();
                    }
                  },
                  //     () {
                  //   Navigator.of(context).push(MaterialPageRoute(builder: (_) => HalVerif(
                  //     idpns: data.idPns!,
                  //     tokenver: tokenlistaktivitas,
                  //   ))).then((val) {
                  //     if (val != null && val) {
                  //       _getRequests();
                  //     }
                  //   });
                  //   // Navigator.push(
                  //   //   context,
                  //   //   MaterialPageRoute(
                  //   //     builder: (context) => HalVerif(
                  //   //       idpns: data.idPns!,
                  //   //       tokenver: tokenlistaktivitas,
                  //   //     ),
                  //   //   ),
                  //   // );
                  // },
                  child: Container(
                    height: 140,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30.0,
                              backgroundImage: NetworkImage(data.foto!),
                              backgroundColor: Colors.transparent,
                            ),
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    data.namaPgawai!,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  " " + data.idNipBaru!,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  " Sudah diakui: " + data.menitSudah! + " menit",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  " Bulan ini belum: " + data.belumVerBlnIni!,
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  " Bulan kemarin belum: " + data.belumVerBlnLalu!,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ))
                .toList(),
          ),
        );
      },
    );
  }
}