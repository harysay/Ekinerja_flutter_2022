import 'dart:convert';
import 'package:ekinerja2020/pages/maintenancePage.dart';
import 'package:flutter/material.dart';
import 'package:ekinerja2020/pages/home_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:ekinerja2020/service/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(new MaterialApp(
    title: "Aplikasi E-kinerja",
    home: new LoginPage(),
//    routes: <String, WidgetBuilder>{
//      '/hallogin': (BuildContext context) => new LoginPage(),
//      '/haldashboard': (BuildContext context) => new HomePage(),
//    }
  ));
}

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginPageState extends State<LoginPage> {

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

  // setelah buat enum LoginStatus, buat kondisi default
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String statusRun,tokenStatus;

  String username, password;
  final _key = new GlobalKey<FormState>();

  // membuat show hide password
  bool _secureText = true;
  showhide() {
    // jika kondisinya true _secureText kan berubah jadi false
    // jika kondisinya false _secureText kan berubah jadi true
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;

    // jika formnya valid dan tidak ada yg ksong maka akan di save
    if (form.validate()) {
      form.save();
      login();

      // print("$username, $password");
    }
  }

  // membuat method untuk login ke db
  login() async {
    print("getuser="+username+":"+password);
    // untuk post wajib ada body properti
    final response = await http.post(Uri.parse(ApiService.urlUtama+"login/proseslogin"), body: {
      // sesuaikan dengan key yg sudah dibuat pada api
      "username":
      username, // key username kemudian nilai inputnya dari mana,  dari string username
      "passw":
      password // key password kemudian nilai inputnya dari mana,  dari string password
    });
    // harus ada decode, karena setiap resul yg sudah di encode, wajib kita decode
    final data = jsonDecode(response.body);
    int value = data['status'];
    String message = data['message'];
    String tokenLogin = data['token'];
    String nipLogin = data['nip'];
    String namaLogin = data['nama'];
    String fotoLog = data['foto'];
    String ideselon = data['id_eselon'];
    String jabatanku = data['jabatan'];
    String idPns = data['id_pns'];
    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, nipLogin, tokenLogin,namaLogin,fotoLog,ideselon,jabatanku,idPns);
      });
      Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT);
    } else {
      Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT);
    }
  }

//  void cekStatusRunning() async{
//    await getPref();
//    final response = await http.get(ApiService.baseStatusRunning+tokenStatus);
//    final stat = jsonDecode(response.body);
//    setState(() {
//      statusRun = stat['status'];
//    });
//  }

  savePref(int value, String nip,String tokenlog, String nama, String fotoLogin,String idEselon,String jabatan,String idPNS) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("niplogin", nip);
      preferences.setString("tokenlogin", tokenlog);
      preferences.setString("namalogin", nama);
      preferences.setString("fotoLogin", fotoLogin);
      preferences.setString("ideselon", idEselon);
      preferences.setString("jabatan", jabatan);
      preferences.setString("id_pns", idPNS);
      preferences.commit();
    });
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");
      tokenStatus = preferences.getString("tokenlogin");
      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await kirimStatusLogout(preferences.getString("id_pns"));
    setState(() {
      preferences.setInt("value", null);
      preferences.setString("niplogin", null);
      preferences.setString("tokenlogin", null);
      preferences.setString("namalogin", null);
      preferences.setString("fotoLogin", null);
      preferences.setString("ideselon", null);
      preferences.setString("jabatan", null);
      preferences.setString("id_pns", null);
      preferences.commit();
      // ketika signoutnya berhasil login harus notsignout
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  kirimStatusLogout(String id_pns) async {
    Map<String, dynamic> inputMap = {
      'id_pns': id_pns,
    };
    final response = await http.post(Uri.parse(ApiService.urlUtama+"Login/proses_logout"),
      body: inputMap,
    );
    final data = jsonDecode(response.body);
    //int value = data['status'];
    String message = data['message'];
    if (response.statusCode == 200) {
      //jsonku = dataObjs;
      return message;
    } else{
      return message;
    }
  }

  // init state merpakan method yag pertama kali akan dipanggil saat aplikasi di buka
  @override
  void initState() {
    super.initState();
    getPref();
//    cekStatusRunning();
  }

  @override
  Widget build(BuildContext context) {
    MaterialColor colorCustom = MaterialColor(0xFFFF6C37, color);
    // membuat exception switch
//    if(LoginStatus.notSignIn == true){
//      return Scaffold(
//          backgroundColor: Colors.white,
//          body: Form(
//            key: _key,
//            child: Center(
//              child: ListView(
//                shrinkWrap: true,
//                padding: EdgeInsets.only(left: 24.0, right: 24.0),
//                children: <Widget>[
//                  Hero(tag: 'hero', child: CircleAvatar(
//                    backgroundColor: Colors.transparent,
//                    radius: 48.0,
//                    child: Image.asset('assets/ekinerja2020.png'),
//                  )),
//                  SizedBox(height: 48.0),
//                  TextFormField(
//                    keyboardType: TextInputType.emailAddress,
//                    autofocus: false,
//                    initialValue: '197305241999032004/197008281997031012',//'197008281997031012',
//                    validator: (e) {
//                      if (e.isEmpty) {
//                        return "Pastikan NIP Anda Benar";
//                      }
//                    },
//                    onSaved: (e) => username = e,
//                    decoration: InputDecoration(
//                      hintText: 'NIP',
//                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
//                    ),
//                  ),
//                  SizedBox(height: 8.0),
//                  TextFormField(
//                    autofocus: false,
//                    initialValue: '24-05-1973/28-08-1970',//'28-08-1970',
//                    //obscureText: true,
//                    obscureText: _secureText,
//                    onSaved: (e) => password = e,
//                    decoration: InputDecoration(
//                        hintText: "Password",
//                        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
//                        suffixIcon: IconButton(
//                          onPressed: showhide,
//                          icon: Icon(_secureText
//                              ? Icons.visibility_off
//                              : Icons.visibility),
//                        )),
//                  ),
//                  SizedBox(height: 24.0),
//                  Padding(
//                    padding: EdgeInsets.symmetric(vertical: 16.0),
//                    child: Material(
//                      borderRadius: BorderRadius.circular(30.0),
//                      shadowColor: Colors.lightBlueAccent.shade100,
//                      elevation: 5.0,
//                      color: Colors.lightBlueAccent,
//                      child: MaterialButton(
//                        minWidth: 200.0,
//                        height: 42.0,
//                        onPressed: () {
//                          // Navigator.of(context).pushNamed(HomePage.tag);
//                          //Navigator.pushNamed(context, '/haldashboard');
////                        Navigator.pushReplacement(context,
////                            new MaterialPageRoute(builder: (context) => new HomePage(signIn)));
//                          check();
//                        },
//                        child: Text('Log In', style: TextStyle(color: Colors.white)),
//                      ),
//                    ),
//                  ),
//                  FlatButton(
//                    child: Text(
//                      'Forgot password?',
//                      style: TextStyle(color: Colors.black54),
//                    ),
//                    onPressed: () {},
//                  )
//                ],
//              ),
//            ),
//          )
//      );
//    }else{
//      return HomePage(signOut);
//    }

    //kalau mau setiap kali masuk ke halaman login dulu aktifkan script di bawah ini
//    if(ststusRun=="true") {
      switch (_loginStatus) {
        case LoginStatus.notSignIn: // case saat tidak sign in akan masuk ke hal login
          return Scaffold(
              backgroundColor: Colors.white,
              body: Form(
                key: _key,
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 24.0, right: 24.0),
                    children: <Widget>[
                      Hero(tag: 'hero', child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 48.0,
                        child: Image.asset('assets/ekinerja2020.png'),
                      )),
                      SizedBox(height: 48.0),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        autofocus: true,
//                        initialValue: '197305241999032004/197008281997031012',
                        //'197008281997031012',
                        validator: (e) {
                          if (e.isEmpty) {
                            return "Pastikan NIP Anda Benar";
                          }
                        },
                        onSaved: (e) => username = e,
                        decoration: InputDecoration(
                          hintText: 'NIP',
                          contentPadding: EdgeInsets.fromLTRB(
                              20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      TextFormField(
                        enableSuggestions: false,
                        autocorrect: false,
                        autofocus: false,
//                        initialValue: '24-05-1973/28-08-1970',
                        //'28-08-1970',
                        //obscureText: true,
                        obscureText: _secureText,
                        onSaved: (e) => password = e,
                        decoration: InputDecoration(
                            hintText: "Password",
                            contentPadding: EdgeInsets.fromLTRB(
                                20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                            suffixIcon: IconButton(
                              onPressed: showhide,
                              icon: Icon(_secureText
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            )),
                      ),
                      SizedBox(height: 24.0),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(30.0),
                          shadowColor: Colors.lightBlueAccent.shade100,
                          elevation: 5.0,
                          color: colorCustom,//Colors.lightBlueAccent,
                          child: MaterialButton(
                            minWidth: 200.0,
                            height: 42.0,
                            onPressed: () {
                              // Navigator.of(context).pushNamed(HomePage.tag);
                              //Navigator.pushNamed(context, '/haldashboard');
                              //                        Navigator.pushReplacement(context,
                              //                            new MaterialPageRoute(builder: (context) => new HomePage(signIn)));
                              check();
                            },
                            child: Text('Log In', style: TextStyle(color: Colors
                                .white)),
                          ),
                        ),
                      ),
                      TextButton(
                        child: Text(
                          'Lupa password?',
                          style: TextStyle(color: Colors.black54),
                        ),
                        onPressed: () {
                          Fluttertoast.showToast(msg: "Silahkan hubungi Admin!", toastLength: Toast.LENGTH_SHORT);
                        },
                      )
                    ],
                  ),
                ),
              )
          );
          break;
        case LoginStatus.signIn: // jika sudah login akan masuk ke main menu
          return HomePage(signOut);//(statusRun=="true") ? HomePage(signOut): MaintenancePage();
          break;

//        case statusRun=="true":
//          return MaintenancePage();
//          break;
      }
//    }else{
//      return MaintenancePage();
//    }


//    final logo = Hero(
//      tag: 'hero',
//      child: CircleAvatar(
//        backgroundColor: Colors.transparent,
//        radius: 48.0,
//        child: Image.asset('assets/ekinerja2020.png'),
//      ),
//    );
  }
}
