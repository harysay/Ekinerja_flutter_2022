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
  @override
  _FirstFragmentState createState() => _FirstFragmentState();

}
class _FirstFragmentState extends State<FirstFragment>{
  String? tarikanNamaUser="",tarikanNIPUser="", tarikanPangkatUser="", tarikanJabatanUser="", tarikanInstansiUser="";
  String? tarikanNamaAtasan, tarikanNipAtasan, tarikanJabatanAtasan, tarikanInstansiAtasan, tarikanPanggolAtasan;
  String username="", nama="",tokenlogin="";
  var loading = false;
  String? dataJson;

  late List<Map<String, dynamic>> jsonDataPresensi;
  bool toggle = true;
  late String url;

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
    TextStyle? styleDashboard = Theme.of(context).textTheme.bodyText2;
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
  Widget buildDataRowInfo(String label, String value,double jarakTitik) {
    TextStyle? styleDashboard = Theme.of(context).textTheme.bodyText2;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: jarakTitik, //untuk mengatur jarak setelah titik dua
              child: Text(label, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black87)),
            ),
            Flexible(
              child: Text(": $value", overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black87),),
            ),
          ],
        );
      },
    );
  }

  _loadInitialData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("tarikNamaUser") != null) {
      setState(() {
        tarikanNamaUser = pref.getString("tarikNamaUser");
        tarikanNIPUser = pref.getString("niploginterakhir");
        tarikanPangkatUser = pref.getString("tarikPangkatUser");
        tarikanJabatanUser = pref.getString("tarikJabatanUser");
        tarikanInstansiUser = pref.getString("tarikInstansiUser");

        tarikanNamaAtasan = pref.getString("tarikNamaAtasan");
        tarikanNipAtasan = pref.getString("tarikNipAtasan");
        tarikanJabatanAtasan = pref.getString("tarikJabatanAtasan");
        tarikanInstansiAtasan = pref.getString("tarikInstansiAtasan");
        loading = false;
      });

      // Fetch the latest data while displaying the current data
      tokenlogin = pref.getString("tokenlogin")!;
      _fetchLatestData(tokenlogin);
    } else {
      // Directly fetch the latest data if SharedPreferences data is not available
      tokenlogin = pref.getString("tokenlogin")!;
      _fetchLatestData(tokenlogin);
    }
  }

  _fetchLatestData(String token) async {
    final response = await http.get(Uri.parse(ApiService.urlUtama + "rekam/dataDiri?token=" + token));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      SharedPreferences pref = await SharedPreferences.getInstance();
      setState(() {
        tarikanNamaUser = data["data"]["nama_gelar"];
        tarikanNIPUser = data["data"]["nip_baru"];
        tarikanPangkatUser = data["data"]["panggol"];
        tarikanJabatanUser = data["data"]["jabatan"];
        tarikanInstansiUser = data["data"]["unit_kerja"];

        String? latestNamaAtasan = data["data"]["nama_gelar_atasan"]?? "Atasan tidak ditemukan";
        String? latestNipAtasan = data["data"]["nip_atasan"]?? "Atasan tidak ditemukan";
        String? latestJabatanAtasan = data["data"]["jabatan_atasan"]?? "Atasan tidak ditemukan";
        String? latestInstansiAtasan = data["data"]["instansi_atas"]?? "Atasan tidak ditemukan";
        String? pangkatAtasan = data["data"]["pangkat_atas"]?? "pangkat tidak ditemukan";
        String? golonganAtasan = data["data"]["golongan_atas"]?? "golongan tidak ditemukan";
        String? latestPanggolAtasan = pangkatAtasan! +" "+ golonganAtasan!;

        // Check if the data is different and update if necessary
        // if (tarikanNipAtasan != latestNipAtasan) {
          tarikanNamaAtasan = latestNamaAtasan;
          tarikanNipAtasan = latestNipAtasan;
          tarikanJabatanAtasan = latestJabatanAtasan;
          tarikanInstansiAtasan = latestInstansiAtasan;
          tarikanPanggolAtasan = latestPanggolAtasan;

          // Update SharedPreferences with the latest data

          pref.setString("tarikNamaAtasan", tarikanNamaAtasan!);
          pref.setString("tarikNipAtasan", tarikanNipAtasan!);
          pref.setString("tarikJabatanAtasan", tarikanJabatanAtasan!);
          pref.setString("tarikInstansiAtasan", tarikanInstansiAtasan!);
          pref.setString("tarikPanggolAtasan", tarikanPanggolAtasan!);
        // }
      });
    } else {
      // Handle error
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to fetch data")));
    }
  }

@override
  void initState() {
    // TODO: implement initState
  // _fetchData();
  // getPref();
  _loadInitialData();
  initializeDateFormatting('id_ID', null); // Initialize Indonesian locale
    super.initState();
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
      // preferences.remove("is_login");
      preferences.setBool('is_login', false);
      // preferences.remove("email");
      // preferences.setString("niploginterakhir", tarikanNIPUser);
      preferences.remove("niplogin");
      preferences.remove("tokenlogin");
      preferences.remove("namalogin");
      preferences.remove("fotoLogin");
      preferences.remove("ideselon");
      preferences.remove("jabatan");
      preferences.remove("id_pns");

      preferences.remove("tarikNamaUser");
      preferences.remove("tarikPangkatUser");
      preferences.remove("tarikJabatanUser");
      preferences.remove("tarikInstansiUser");
      preferences.remove("tarikNamaAtasan");
      preferences.remove("tarikNipAtasan");
      preferences.remove("tarikJabatanAtasan");
      preferences.remove("tarikInstansiAtasan");
      preferences.remove("tarikPanggolAtasan");
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
    TextStyle? styleDashboard = Theme.of(context).textTheme.bodyText2;
    TextStyle? styleTitle = Theme.of(context).textTheme.bodyText1;
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
                      color: Colors.yellow.shade100,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Text("Data Pribadi", style: styleTitle),
                      ),
                      buildDataRow("Nama", tarikanNamaUser ?? "Loading...",120.0),
                      buildDataRow("NIP", tarikanNIPUser ?? "Loading...",120.0),
                      buildDataRow("Pangkat/Gol", tarikanPangkatUser ?? "Loading...",120.0),
                      buildDataRow("Jabatan", tarikanJabatanUser ?? "Loading...",120.0),
                      buildDataRow("Instansi", tarikanInstansiUser ?? "Loading...",120.0),
                    ],
                  ),
                ),
                new Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.yellow.shade100,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Text("Verifikator Kinerja", style: styleTitle),
                      ),
                      buildDataRow("Nama", tarikanNamaAtasan ?? "Loading...",120.0),
                      buildDataRow("NIP", tarikanNipAtasan ?? "Loading...",120.0),
                      buildDataRow("Jabatan", tarikanJabatanAtasan ?? "Loading...",120.0),
                      buildDataRow("Pangkat/Gol", tarikanPanggolAtasan ?? "Loading...",120.0),
                      buildDataRow("Instansi", tarikanInstansiAtasan ?? "Loading...",120.0),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                new Container(
                      padding: new EdgeInsets.all(20.0),
                      // color: Colors.yellow[50],
                      child: new Column(
                        children: <Widget>[
                          FutureBuilder(
                            future: ApiService().getAbsenBerjalan(tokenlogin),//ApiService().getDataPresensiBlnLalu(tokenlogin,"0"),
                            builder: (context, snapshot) {
                              return ExpansionTile(
                                title: Text('Data Bulan ' + getMonth(0) + " " + DateTime.now().year.toString()),
                                children: [
                                  if (snapshot.connectionState == ConnectionState.waiting)
                                    Center(child: CircularProgressIndicator()),
                                  if (snapshot.hasError)
                                    Center(child: Text('Error: ${snapshot.error}')),
                                  if (snapshot.hasData)
                                    buildDataTable(snapshot.data as List),
                                ],
                              );
                            },
                          ),
                          FutureBuilder(
                            future: ApiService().getAbsenLalu(tokenlogin),//ApiService().getDataPresensiBlnLalu(tokenlogin,"1"),
                            builder: (context, snapshot) {
                              return ExpansionTile(
                                title: Text('Data Bulan ' + getMonth(1) + " " + DateTime.now().year.toString()),
                                children: [
                                  if (snapshot.connectionState == ConnectionState.waiting)
                                    Center(child: CircularProgressIndicator()),
                                  if (snapshot.hasError)
                                    Center(child: Text('Error: ${snapshot.error}')),
                                  if (snapshot.hasData) ...[
                                    FutureBuilder(
                                      future: ApiService().getDataPaguCapaianLalu(tokenlogin),
                                      builder: (context, datatamsil) {
                                        if (datatamsil.connectionState == ConnectionState.waiting) {
                                          return Center(child: CircularProgressIndicator());
                                        } else if (datatamsil.hasError) {
                                          return Center(child: Text('Error: ${datatamsil.error}'));
                                        } else {
                                          Map<String, dynamic>? datatam = datatamsil.data as Map<String, dynamic>?;
                                          var kinerjaTpp = datatam!['kinerja_tpp'];
                                          int totalWaktuDiakui = calculateTotalWaktuDiakui(kinerjaTpp);
                                          return Container(
                                            padding: EdgeInsets.all(20.0),
                                            decoration: BoxDecoration(
                                              color: Colors.lime[200],
                                              border: Border.all(color: Colors.yellow.shade100),
                                              borderRadius: BorderRadius.all(Radius.circular(20)),
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                Center(
                                                  child: Text("Info Tamsil", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                                                ),
                                                buildDataRowInfo("Pagu", formatCurrency(datatam!['pagu_tamsilpeg']), 120.0),
                                                buildDataRowInfo("Realisasi", formatCurrency(datatam!['jumlah_tamsil_diterima']), 120.0),
                                                buildDataRowInfo("Capaian", totalWaktuDiakui.toString() + "/6.751 menit", 120.0),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    buildDataTable(snapshot.data as List),
                                  ],
                                ],
                              );
                            },
                          ),
                          FutureBuilder(
                            future: ApiService().getAbsenLusa(tokenlogin),//ApiService().getDataPresensiBlnLalu(tokenlogin,"2"),
                            builder: (context, snapshot) {
                              return ExpansionTile(
                                title: Text('Data Bulan ' + getMonth(2) + " " + DateTime.now().year.toString()),
                                children: [
                                  if (snapshot.connectionState == ConnectionState.waiting)
                                    Center(child: CircularProgressIndicator()),
                                  if (snapshot.hasError)
                                    Center(child: Text('Error: ${snapshot.error}')),
                                  if (snapshot.hasData) ...[
                                    FutureBuilder(
                                      future: ApiService().getDataPaguCapaianLusa(tokenlogin),
                                      builder: (context, datatamsil) {
                                        if (datatamsil.connectionState == ConnectionState.waiting) {
                                          return Center(child: CircularProgressIndicator());
                                        } else if (datatamsil.hasError) {
                                          return Center(child: Text('Error: ${datatamsil.error}'));
                                        } else {
                                          Map<String, dynamic>? datatam = datatamsil.data as Map<String, dynamic>?;
                                          var kinerjaTpp = datatam!['kinerja_tpp'];
                                          int totalWaktuDiakui = calculateTotalWaktuDiakui(kinerjaTpp);
                                          return Container(
                                            padding: EdgeInsets.all(20.0),
                                            decoration: BoxDecoration(
                                              color: Colors.lime[200],
                                              border: Border.all(color: Colors.yellow.shade100),
                                              borderRadius: BorderRadius.all(Radius.circular(20)),
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                Center(
                                                  child: Text("Info Tamsil", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                                                ),
                                                buildDataRowInfo("Pagu", formatCurrency(datatam!['pagu_tamsilpeg']), 120.0),
                                                buildDataRowInfo("Realisasi", formatCurrency(datatam!['jumlah_tamsil_diterima']), 120.0),
                                                buildDataRowInfo("Capaian", totalWaktuDiakui.toString() + "/6.751 menit", 120.0),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    buildDataTable(snapshot.data as List),
                                  ],
                                ],
                              );
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