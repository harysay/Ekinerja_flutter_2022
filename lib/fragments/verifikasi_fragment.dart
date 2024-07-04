import 'package:ekinerja2020/model/daftar_bulansemuaverifikasi.dart';
import 'package:ekinerja2020/model/daftar_listpegawaiverifikasi.dart';
import 'package:ekinerja2020/verifikasi/halVerifikasi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ekinerja2020/model/daftar_pegawaiverifikasi.dart';
import 'package:ekinerja2020/service/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ApiService api = new ApiService();
//void main() => runApp(VerifikasiFragment());

class VerifikasiFragment extends StatefulWidget {
  final String tokenLogin;
  VerifikasiFragment({required this.tokenLogin});
  @override
  JsonImageListWidget createState() => JsonImageListWidget();

}

class JsonImageListWidget extends State<VerifikasiFragment> {
  // late Future<List<DaftarPegawaiVerifikasi>?> futureData;
  late Future<List<DaftarListPegawaiVerifikasi>?> getDataPegawaiVerifikasi;
  late Future<Map<String, List<DaftarBulanSemuaVerifikasi>>> getBulanSemuaPegawaiVerifikasi;
  final ApiService api = ApiService();
  // String tokenlistaktivitas="";

  _getRequests()async{
    setState(() {});
    _refreshData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataPegawaiVerifikasi = api.getDetailPegawaiDiVer(widget.tokenLogin);
    getBulanSemuaPegawaiVerifikasi = _fetchAllBulanMenitData();
    // futureData = api.getAllPegawaiVer(widget.tokenLogin);
    // getPref();
  }

  Future<Map<String, List<DaftarBulanSemuaVerifikasi>>> _fetchAllBulanMenitData() async {
    final pegawaiList = await getDataPegawaiVerifikasi;
    final Map<String, List<DaftarBulanSemuaVerifikasi>> allBulanData = {};

    for (var pegawai in pegawaiList!) {
      final bulanData = await api.getBulanMenitPegawaiDiVer(widget.tokenLogin, pegawai.idPns!);
      if (bulanData != null) {
        allBulanData[pegawai.idPns!] = bulanData;
      }
    }
    return allBulanData;
  }

  Future<void> _refreshData() async {
    setState(() {
      getDataPegawaiVerifikasi = api.getDetailPegawaiDiVer(widget.tokenLogin);
      getBulanSemuaPegawaiVerifikasi = _fetchAllBulanMenitData();
      // futureData = api.getAllPegawaiVer(widget.tokenLogin);
    });
  }

  // Future<Null> getPref() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     tokenlistaktivitas = preferences.getString("tokenlogin")!;
  //     getDataPegawaiVerifikasi = api.getDetailPegawaiDiVer(tokenlistaktivitas);
  //     // futureData = api.getAllPegawaiVer(tokenlistaktivitas);
  //   });
  // }
  // selectedItem(BuildContext context, String holder) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: new Text(holder),
  //         actions: <Widget>[
  //           TextButton(
  //             child: new Text("OK"),
  //       onPressed: () {
  //       Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DaftarListPegawaiVerifikasi>?>(
      future: getDataPegawaiVerifikasi,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data found'));
        } else {
          final pegawaiList = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView(
              padding: EdgeInsets.only(top: 15.0),
              children: pegawaiList.map((data) {
                return Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        // Ensure idPns is not null
                        if (data.idPns != null) {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HalVerif(idpns: data.idPns!, tokenver: widget.tokenLogin),
                            ),
                          );
                          if (result == true) {
                            _refreshData();
                          }
                        } else {
                          // Show error message if idPns is null
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid ID PNS')));
                        }
                      },
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
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        data.namaPgawai!,
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: FutureBuilder<List<DaftarBulanSemuaVerifikasi>?>(
                                  future: api.getBulanMenitPegawaiDiVer(widget.tokenLogin, data.idPns!),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return SpinKitThreeBounce(
                                        color: Colors.black,
                                        size: 20.0,
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                      return Text('No data available');
                                    } else {
                                      final bulanData = snapshot.data!;
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: bulanData.map((bulanData) {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                " Sudah diakui: " + bulanData.menitSudah! + " menit",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              Text(
                                                " Bulan ini belum: " + bulanData.belumVerBlnIni!,
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              Text(
                                                " Bulan kemarin belum: " + bulanData.belumVerBlnLalu!,
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}