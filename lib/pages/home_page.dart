import 'package:ekinerja2020/fragments/dashboard_fragment.dart';
import 'package:ekinerja2020/fragments/rekamaktivitas_fragment.dart';
import 'package:ekinerja2020/fragments/laporan_fragment.dart';
import 'package:ekinerja2020/fragments/about_fragment.dart';
import 'package:ekinerja2020/fragments/skp_fragment.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ekinerja2020/fragments/verifikasi_fragment.dart';
import 'package:ekinerja2020/pages/page_login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ekinerja2020/service/ApiService.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String tarikanToken="",tarikanLamaAktivitas="",tarikanGrade="";
  ApiService api = new ApiService();
  int _selectedDrawerIndex = 0;
  String username = "", nama = "", linkfoto = "", ideselon="",jabat="";
  // var loadingGrade = false;
  var loading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<Null> _getLamaAktivitas()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      loading = true;
      tarikanToken = preferences.getString("tokenlogin")!;
    });
    final response = await http.get(Uri.parse(ApiService.urlUtama+"rekam/dataDiri?token="+tarikanToken));
    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      //final _daftarPekerjaan = data['data'];
      setState(() {
        String tarikNamaUser, tarikPangkatUser, tarikJabatanUser, tarikInstansiUser,tarikNamaAtasan, tarikNipAtasan, tarikJabatanAtasan, tarikInstansiAtasan;
        tarikanLamaAktivitas = data["data"]["lama_aktivitas"];
        tarikanGrade = data["data"]["grade"];
        // loadingGrade = false;

        tarikNamaUser = data["data"]["nama"];
        tarikPangkatUser = data["data"]["panggol"];
        tarikJabatanUser = data["data"]["jabatan"];
        tarikInstansiUser = data["data"]["unit_kerja"];
        tarikNamaAtasan = data["data"]["nama_atasan"]?? "Data atasan tidak ditemukan";
        tarikNipAtasan = data["data"]["nip_atasan"]?? "Data atasan tidak ditemukan";
        tarikJabatanAtasan = data["data"]["jabatan_atasan"]?? "Data atasan tidak ditemukan";
        tarikInstansiAtasan = data["data"]["instansi_atas"]?? "Data atasan tidak ditemukan";

        preferences.setString("tarikNamaUser", tarikNamaUser);
        preferences.setString("tarikPangkatUser", tarikPangkatUser);
        preferences.setString("tarikJabatanUser", tarikJabatanUser);
        preferences.setString("tarikInstansiUser", tarikInstansiUser);
        preferences.setString("tarikNamaAtasan", tarikNamaAtasan);
        preferences.setString("tarikNipAtasan", tarikNipAtasan);
        preferences.setString("tarikJabatanAtasan", tarikJabatanAtasan);
        preferences.setString("tarikInstansiAtasan", tarikInstansiAtasan);
        loading = false;
      });
    }else{
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch data')),
      );
    }
  }

  final drawerItems = [
    new DrawerItem("Dashboard", Icons.home),
    new DrawerItem("Rekam Aktivitas", Icons.add_alarm),
    new DrawerItem("Verifikasi Aktivitas", Icons.check_circle_outline),
    new DrawerItem("Laporan", Icons.calendar_today),
    // new DrawerItem("SKP", Icons.account_circle_rounded),
    new DrawerItem("Tentang Aplikasi", Icons.help_outline),
    // new DrawerItem("Keluar", Icons.call_missed_outgoing)
  ];


  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var islogin = pref.getBool("is_login");
    if (islogin != null && islogin == true) {
      await _getLamaAktivitas();
      setState(() {
        username = pref.getString("niplogin")!;
        nama = pref.getString("namalogin")!;
        linkfoto = pref.getString("fotoLogin")!;
        ideselon = pref.getString("ideselon")!;
        jabat = pref.getString("jabatan")!;
        if(ideselon=="21"||ideselon=="22"||ideselon=="31"||jabat.contains('Camat')||ideselon=="32"||ideselon=="41"||ideselon=="42"){
        }else{
          drawerItems.removeAt(2);
        }
      });

    } else {
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const PageLogin(),
        ),
            (route) => false,
      );
    }
  }

  logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // setState(() {
      preferences.remove("is_login");
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
    // });

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
  void initState() {
    getPref();
    super.initState();

  }
  @override
  dispose() {
    super.dispose();
  }

  _getDrawerItemWidget(int pos) {
    if(ideselon=="21"||ideselon=="22"||ideselon=="31"||jabat.contains('Camat')||ideselon=="32"||ideselon=="41"||ideselon=="42"){
      switch (pos) {
        case 0:
          return new FirstFragment();
        case 1:
          return new SecondFragment();
        case 2:
          return new VerifikasiFragment(tokenLogin: tarikanToken);
        case 3:
          return new ThirdFragment();
        // case 4:
        //   return new SkpFragment(); //aktifkan jika menu SKP siap
        case 4:
          return new AboutFragment();
        default:
          return new Text("Error");
      }
    }else{
      switch (pos) {
        case 0:
          return new FirstFragment();
        case 1:
          return new SecondFragment();
        case 2:
          return new ThirdFragment();
        // case 3:
        //   return new SkpFragment(); //aktifkan jika menu SKP siap
        case 3:
          return new AboutFragment();
        default:
          return new Text("Error");
      }
    }

  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < drawerItems.length; i++) {
      var d = drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }
    drawerOptions.add(Divider());
    drawerOptions.add(ListTile(
      leading: Icon(Icons.call_missed_outgoing),
      title: Text("Keluar"),
      onTap: () {
        Navigator.of(context).pop();
        logOut();
      },
    ));

    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(drawerItems[_selectedDrawerIndex].title),
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(nama),
//              accountEmail: new Text(username),
              accountEmail: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(username,style: TextStyle(fontSize: 11, fontFamily: 'Nunito'),),
                      // Expanded(child: child)
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Text('Telah bekerja: ',style: TextStyle(fontSize: 11, fontFamily: 'Nunito')),
                            loading
                                ? SpinKitThreeBounce(
                              color: Colors.white,
                              size: 10.0,
                            ) :
                            Text(tarikanLamaAktivitas,style: TextStyle(fontSize: 11, fontFamily: 'Nunito')),
                            Text(' menit',style: TextStyle(fontSize: 11, fontFamily: 'Nunito')),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Text('Grade: ', style: TextStyle(fontSize: 11, fontFamily: 'Nunito')),
                            loading
                                ? SpinKitThreeBounce(
                              color: Colors.white,
                              size: 10.0,
                            )
                                :  Text(tarikanGrade, style: TextStyle(fontSize: 11, fontFamily: 'Nunito')),
                          ],
                        ),
                      ),
                    ],
                  ),

                ],
              ),

              currentAccountPicture:
              new CircleAvatar(
                backgroundImage: new NetworkImage(linkfoto),
              ),decoration: new BoxDecoration(
                  color: Colors.deepOrange[300]
            ),
              otherAccountsPictures: <Widget>[

              ],
            ),
            new Column(children: drawerOptions)

          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
      onDrawerChanged: (isOpen) {
        if (isOpen) {
          _getLamaAktivitas();
        }
      },
    );
  }
}
