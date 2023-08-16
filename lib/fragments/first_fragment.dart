import 'package:ekinerja2020/pages/page_login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ekinerja2020/service/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:json_table/json_table.dart';
import 'package:json_table/src/json_table_column.dart';
ApiService api = new ApiService();

class FirstFragment extends StatefulWidget {
  // FirstFragment({
  //   Key key,
  //   @required this.wgtarikanNamaUser,this.wgtarikanPangkatUser,this.wgtarikanJabatanUser,this.wgtarikanInstansiUser,
  //   this.wgtarikanNamaAtasan,this.wgtarikanNipAtasan,this.wgtarikanJabatanAtasan,this.wgtarikanInstansiAtasan
  // }) : super(key: key);
  // String wgtarikanNamaUser, wgtarikanPangkatUser, wgtarikanJabatanUser, wgtarikanInstansiUser;
  // String wgtarikanNamaAtasan, wgtarikanNipAtasan, wgtarikanJabatanAtasan, wgtarikanInstansiAtasan;
  @override
  _FirstFragmentState createState() => _FirstFragmentState();

}
class _FirstFragmentState extends State<FirstFragment>{
  var tarikanNamaUser, tarikanPangkatUser, tarikanJabatanUser, tarikanInstansiUser;
  var tarikanNamaAtasan, tarikanNipAtasan, tarikanJabatanAtasan, tarikanInstansiAtasan;
  String username="", nama="",tokenlogin="";
  var loading = false;

  List<Map<String, dynamic>> jsonDataPresensi;
  bool toggle = true;
  // List<JsonTableColumn> columns;

  String url;
  bool _customTileExpanded = false;

  Widget buildDataTable(List<dynamic> bulanLaluData) {
    if (bulanLaluData == null || bulanLaluData.isEmpty) {
      // Tampilkan pesan jika data kosong atau null.
      return Center(
        child: Text('Data tidak ditemukan.'),
      );
    } else {
      return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text('Tanggal')),
              DataColumn(label: Text('Datang')),
              DataColumn(label: Text('Pulang')),
              DataColumn(label: Text('Terlambat')),
              DataColumn(label: Text('Mendahului')),
              // DataColumn lainnya...
            ],
            rows: buildRows(bulanLaluData),
          )
      );


    }
  }

  List<DataRow> buildRows(List<dynamic> bulanLaluData) {
    // Fungsi ini mengambil data dari bulanLaluData dan mengembalikan List<DataRow>.
    // Sesuaikan dengan struktur data dan logic Anda.
    // Misalnya, jika bulanLaluData adalah List<Map<String, dynamic>>, maka Anda dapat
    // melakukan iterasi untuk mengambil nilai yang dibutuhkan dan mengembalikan List<DataRow>.
    // Contoh:
    return bulanLaluData.map<DataRow>((data) {
      // Ubah kode ini sesuai dengan struktur data Anda.
      return DataRow(
        cells: [
          DataCell(Text(data['tanggal'])),
          DataCell(Text(data['jam_datang'])),
          DataCell(Text(data['jam_pulang'])),
          DataCell(Text(data['mnt_terlambat'].toString())),
          DataCell(Text(data['mnt_mendahului'].toString())),
          // DataCell lainnya...
        ],
      );
    }).toList();
  }

  Widget buildDataRow(String label, String value) {
    TextStyle styleDashboard = Theme.of(context).textTheme.bodyText2;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 100.0, //untuk mengatur jarak setelah titik dua
              child: Text(label, style: styleDashboard),
            ),
            Flexible(
              child: Text(": $value", overflow: TextOverflow.ellipsis),
            ),
          ],
        );
      },
    );
  }
  // List<Widget> buildRows() {
  //   setJsonPresensi();
  //   // var bulanLaluData = jsonDecode(jsonString)['bulan_lalu'] as List<dynamic>;
  // }

  // void setJsonPresensi() async{
  //   await getPref();
  //   // DateTime now = new DateTime.now();
  //   await api.getDataPresensiBlnLalu(tokenlogin).then((data){
  //     setState(() {
  //       jsonDataPresensi = data;
  //       if (jsonDataPresensi == null || jsonDataPresensi.isEmpty) {
  //         return []; // Mengembalikan list kosong jika bulanLaluData null atau kosong.
  //       } else {
  //         return jsonDataPresensi.map<DataRow>((data) {
  //           // Ubah kode ini sesuai dengan struktur data Anda.
  //           return DataRow(
  //             cells: [
  //               DataCell(Text(data['tanggal'])),
  //               DataCell(Text(data['jam_datang'])),
  //               DataCell(Text(data['jam_pulang'])),
  //               // DataCell lainnya...
  //             ],
  //           );
  //         }).toList();
  //       }
  //     });
  //   });
  //
  //
  // }

  Future<Null> getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      tokenlogin = preferences.getString("tokenlogin");
    });
  }

  Future<Null> _fetchData()async{
    setState(() {
      loading = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();

    if(pref.getString("tarikNamaUser")!=null) {
      tarikanNamaUser = pref.getString("tarikNamaUser");
      tarikanPangkatUser = pref.getString("tarikPangkatUser");
      tarikanJabatanUser = pref.getString("tarikJabatanUser");
      tarikanInstansiUser = pref.getString("tarikInstansiUser");

      tarikanNamaAtasan = pref.getString("tarikNamaAtasan");
      tarikanNipAtasan = pref.getString("tarikNipAtasan");
      tarikanJabatanAtasan = pref.getString("tarikJabatanAtasan");
      tarikanInstansiAtasan = pref.getString("tarikInstansiAtasan");
      loading = false;
    }else{
      setState(() {
        tokenlogin = pref.getString("tokenlogin");
      });
      final response = await http.get(Uri.parse(
          ApiService.urlUtama + "rekam/dataDiri?token=" + tokenlogin));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        //final _daftarPekerjaan = data['data'];
        setState(() {
          tarikanNamaUser = data["data"]["nama_gelar"];
          tarikanPangkatUser = data["data"]["panggol"];
          tarikanJabatanUser = data["data"]["jabatan"];
          tarikanInstansiUser = data["data"]["unit_kerja"];

          tarikanNamaAtasan = data["data"]["nama_gelar_atasan"];
          tarikanNipAtasan = data["data"]["nip_atasan"];
          tarikanJabatanAtasan = data["data"]["jabatan_atasan"];
          tarikanInstansiAtasan = data["data"]["instansi_atas"];
          loading = false;
        });
      } else {
        Text("error bro");
      }
    }
  }

//  getPref() async {
//    SharedPreferences preferences = await SharedPreferences.getInstance();
//    setState(() {
//      tokenlogin = preferences.getString("tokenlogin");
//
//    });
//  }

@override
  void initState() {
    // TODO: implement initState
  _fetchData();
  getPref();

    super.initState();
  // setJsonPresensi();
  // columns = [
  //   JsonTableColumn("tgl_kinerja", label: "Tanggal"),
  //   JsonTableColumn("jam_datang", label: "Datang"),
  //   JsonTableColumn("jam_pulang", label: "Pulang"),
  //   JsonTableColumn("mnt_terlambat", label: "Terlambat"),
  //    JsonTableColumn("mnt_mendahului", label: "Mendahului"),
  //   JsonTableColumn("info", label: "Status", defaultValue: "-"),
  // ];
  }

  logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.remove("is_login");
      // preferences.remove("email");
      preferences.remove("niplogin");
      preferences.remove("tokenlogin");
      preferences.remove("namalogin");
      preferences.remove("fotoLogin");
      preferences.remove("ideselon");
      preferences.remove("jabatan");
      preferences.remove("id_pns");
    });

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const PageLogin(),
      ),
          (route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text(
            "Berhasil logout",
            style: TextStyle(fontSize: 16),
          )),
    );
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    TextStyle styleDashboard = Theme.of(context).textTheme.bodyText2;
    TextStyle styleTitle = Theme.of(context).textTheme.bodyText1;
    // setJsonPresensi();
    // List<DataRow> rows = jsonDataPresensi.map((data) {
    //   // Ubah tipe data dari data ke Map<String, dynamic>
    //   Map<String, dynamic> rowData = data as Map<String, dynamic>;
    //
    //   return DataRow(cells: [
    //     DataCell(Text(rowData['tanggal'] ?? 'Tidak Ada')),
    //     DataCell(Text(rowData['jam_datang'] ?? 'Tidak Ada')),
    //     DataCell(Text(rowData['jam_pulang'] ?? 'Tidak Ada')),
    //   ]);
    // }).toList();
    return new SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child:Center(
        //child: new Text("Hello Fragment 1"),
        child: loading ? Center(child: CircularProgressIndicator())
            : new Column(
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.yellow[100],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Text("Data Pribadi", style: styleTitle),
                      ),
                      buildDataRow("Nama", tarikanNamaUser),
                      buildDataRow("Pangkat/Gol", tarikanPangkatUser),
                      buildDataRow("Jabatan", tarikanJabatanUser),
                      buildDataRow("Instansi", tarikanInstansiUser),
                    ],
                  ),
                ),
                new Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.yellow[100],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Text("Verifikator Kinerja", style: styleTitle),
                      ),
                      buildDataRow("Nama", tarikanNamaAtasan),
                      buildDataRow("NIP", tarikanNipAtasan),
                      buildDataRow("Jabatan", tarikanJabatanAtasan),
                      buildDataRow("Instansi", tarikanInstansiAtasan),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                new Container(
                      padding: new EdgeInsets.all(20.0),
                      color: Colors.yellow[50],
                      child: new Column(
                        children: <Widget>[
                          FutureBuilder(
                            future: ApiService().getDataPresensiBlnLalu(tokenlogin,"0"),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                // Menampilkan indikator loading jika data masih diambil.
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                // Menampilkan pesan error jika terjadi kesalahan saat mengambil data.
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              } else {
                                // Menampilkan data dalam ExpansionTile.
                                return ExpansionTile(
                                  title: Text('Data Bulan Ini'),
                                  children: [
                                    // Menggunakan widget DataTable atau ListView sesuai preferensi Anda.
                                    // Contoh menggunakan DataTable:
                                    buildDataTable(snapshot.data),
                                  ],
                                );
                              }
                            },
                          ),
                          FutureBuilder(
                            future: ApiService().getDataPresensiBlnLalu(tokenlogin,"1"),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                // Menampilkan indikator loading jika data masih diambil.
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                // Menampilkan pesan error jika terjadi kesalahan saat mengambil data.
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              } else {
                                // Menampilkan data dalam ExpansionTile.
                                return ExpansionTile(
                                  title: Text('Data Bulan Lalu'),
                                  children: [
                                    // Menggunakan widget DataTable atau ListView sesuai preferensi Anda.
                                    // Contoh menggunakan DataTable:
                                    buildDataTable(snapshot.data),
                                  ],
                                );
                              }
                            },
                          ),
                          FutureBuilder(
                            future: ApiService().getDataPresensiBlnLalu(tokenlogin,"2"),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                // Menampilkan indikator loading jika data masih diambil.
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                // Menampilkan pesan error jika terjadi kesalahan saat mengambil data.
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              } else {
                                // Menampilkan data dalam ExpansionTile.
                                return ExpansionTile(
                                  title: Text('Data Bulan Lusa'),
                                  children: [
                                    // Menggunakan widget DataTable atau ListView sesuai preferensi Anda.
                                    // Contoh menggunakan DataTable:
                                    buildDataTable(snapshot.data),
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      )
                ),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                    onPressed: () {
                      logOut();
                    },
                    icon: const Icon(Icons.lock_open),
                    label: const Text("Log Out")),
              ],
            ),
      ),
    );

  }
}