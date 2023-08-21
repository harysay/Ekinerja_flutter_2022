import 'package:ekinerja2020/pages/page_login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ekinerja2020/service/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // Import untuk date Indonesia
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
              DataColumn(label: Text('Keterangan')),
              // DataColumn lainnya...
            ],
            rows: buildRows(bulanLaluData),
          )
      );


    }
  }

  List<DataRow> buildRows(List<dynamic> bulanLaluData) {

    return bulanLaluData.map<DataRow>((data) {
      if (data['info'] == null || bulanLaluData.isEmpty) {

      }
      return DataRow(
        cells: [
          DataCell(Text(data['tanggal'])),
          DataCell(Text(data['jam_datang'])),
          DataCell(Text(data['jam_pulang'])),
          DataCell(Text(data['mnt_terlambat'].toString())),
          DataCell(Text(data['mnt_mendahului'].toString())),
          DataCell(Text(data['info'] != null && data['info']['info'] != null ? '${data['info']['info']} - ${data['info']['status']}' : '')),
          // DataCell lainnya...
        ],
      );
    }).toList();
  }

  Widget buildDataRow(String label, String value,double jarakTitik) {
    TextStyle styleDashboard = Theme.of(context).textTheme.bodyText2;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: jarakTitik, //untuk mengatur jarak setelah titik dua
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
  initializeDateFormatting('id_ID', null); // Initialize Indonesian locale
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

  String formatCurrency(String amount) {
    var formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',  // Simbol Rupiah
      decimalDigits: 0,  // Jumlah digit desimal
    );

    double parsedAmount = double.tryParse(amount) ?? 0.0;
    return formatter.format(parsedAmount);
  }
  String getMonth(int months) {
    DateTime now = DateTime.now();
    DateTime nameMonths = DateTime(now.year, now.month - months, now.day);
    String namaBulan = DateFormat('MMMM', 'id_ID').format(nameMonths);
    return namaBulan;
  }

  int calculateTotalWaktuDiakui(List<dynamic> kinerjaList) {
    int totalWaktuDiakui = 0;
    for (var kinerja in kinerjaList) {
      if (kinerja['waktu_diakui'] != "-") {
        totalWaktuDiakui += int.parse(kinerja['waktu_diakui']);
      }
    }
    return totalWaktuDiakui;
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
                      buildDataRow("Nama", tarikanNamaUser,120.0),
                      buildDataRow("Pangkat/Gol", tarikanPangkatUser,120.0),
                      buildDataRow("Jabatan", tarikanJabatanUser,120.0),
                      buildDataRow("Instansi", tarikanInstansiUser,120.0),
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
                      buildDataRow("Nama", tarikanNamaAtasan,120.0),
                      buildDataRow("NIP", tarikanNipAtasan,120.0),
                      buildDataRow("Jabatan", tarikanJabatanAtasan,120.0),
                      buildDataRow("Instansi", tarikanInstansiAtasan,120.0),
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
                                  title: Text('Data Bulan '+getMonth(0)+" "+DateTime.now().year.toString()),
                                  children: [
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
                                  title: Text('Data Bulan '+getMonth(1)+" "+DateTime.now().year.toString()),
                                  children: [
                                    new FutureBuilder(future: ApiService().getDataTamsil(tokenlogin,"1"),
                                        builder: (context, datatamsil) {
                                          if (datatamsil.connectionState == ConnectionState.waiting) {
                                            // Menampilkan indikator loading jika data masih diambil.
                                            return Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          } else if (datatamsil.hasError) {
                                            // Menampilkan pesan error jika terjadi kesalahan saat mengambil data.
                                            return Center(
                                              child: Text('Error: ${datatamsil.error}'),
                                            );
                                          } else {
                                            var kinerjaTpp = datatamsil.data['kinerja_tpp'];
                                            int totalWaktuDiakui = calculateTotalWaktuDiakui(kinerjaTpp);
                                            // Menampilkan data pagu di atas ExpansionTile.
                                            return Container(
                                              padding: EdgeInsets.all(20.0),
                                              decoration: BoxDecoration(
                                                color: Colors.lime,
                                                border: Border.all(
                                                  color: Colors.yellow[100],
                                                ),
                                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                              ),
                                              child: Column(
                                                children: <Widget>[
                                                  Center(
                                                    child: Text("Info Tamsil", style: styleTitle),
                                                  ),
                                                  // buildDataRow("Unit Kerja", datatamsil.data['unit_kerja_tpp'],160.0),
                                                  // buildDataRow("Jabatan/Kelas", datatamsil.data['jabatan_tpp'],160.0),
                                                  buildDataRow("Pagu", formatCurrency(datatamsil.data['pagu_tamsilpeg']),160.0),
                                                  buildDataRow("Realisasi", formatCurrency(datatamsil.data['jumlah_tamsil_diterima']),160.0),
                                                  buildDataRow("Capaian", totalWaktuDiakui.toString()+"/6.751 menit",160.0), // Menampilkan total waktu diakui
                                                ],
                                              ),
                                            );
                                          }
                                        }),
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
                                  title: Text('Data Bulan '+getMonth(2)+" "+DateTime.now().year.toString()),
                                  children: [
                                    new FutureBuilder(future: ApiService().getDataTamsil(tokenlogin,"2"),
                                        builder: (context, datatamsil) {
                                          if (datatamsil.connectionState == ConnectionState.waiting) {
                                            // Menampilkan indikator loading jika data masih diambil.
                                            return Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          } else if (datatamsil.hasError) {
                                            // Menampilkan pesan error jika terjadi kesalahan saat mengambil data.
                                            return Center(
                                              child: Text('Error: ${datatamsil.error}'),
                                            );
                                          } else {
                                            var kinerjaTpp = datatamsil.data['kinerja_tpp'];
                                            int totalWaktuDiakui = calculateTotalWaktuDiakui(kinerjaTpp);
                                            // Menampilkan data pagu di atas ExpansionTile.
                                            return Container(
                                              padding: EdgeInsets.all(20.0),
                                              decoration: BoxDecoration(
                                                color: Colors.lime,
                                                border: Border.all(
                                                  color: Colors.yellow[100],
                                                ),
                                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                              ),
                                              child: Column(
                                                children: <Widget>[
                                                  Center(
                                                    child: Text("Info Tamsil", style: styleTitle),
                                                  ),
                                                  // buildDataRow("Unit Kerja", datatamsil.data['unit_kerja_tpp'],160.0),
                                                  // buildDataRow("Jabatan/Kelas", datatamsil.data['jabatan_tpp'],160.0),
                                                  buildDataRow("Pagu", formatCurrency(datatamsil.data['pagu_tamsilpeg']),160.0),
                                                  buildDataRow("Realisasi", formatCurrency(datatamsil.data['jumlah_tamsil_diterima']),160.0),
                                                  buildDataRow("Capaian", totalWaktuDiakui.toString()+"/6.751 menit",160.0), // Menampilkan total waktu diakui
                                                ],
                                              ),
                                            );
                                          }
                                        }),
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