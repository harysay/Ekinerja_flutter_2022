import 'dart:convert';

import 'package:ekinerja2020/pages/home_page.dart';
import 'package:ekinerja2020/service/ApiService.dart';
import 'package:ekinerja2020/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({Key key}) : super(key: key);

  @override
  _PageLoginState createState() => _PageLoginState();
}
enum LoginStatus { notSignIn, signIn }
class HeadClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 4, size.height - 40, size.width / 2, size.height - 20);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _PageLoginState extends State<PageLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var txtEditUsername = TextEditingController();
  var txtEditPwd = TextEditingController();
  LoginStatus _loginStatus;

  // membuat show hide password
  bool _secureText = true;
  showhide() {
    // jika kondisinya true _secureText kan berubah jadi false
    // jika kondisinya false _secureText kan berubah jadi true
    setState(() {
      _secureText = !_secureText;
    });
  }

  Widget inputUsername() {
    return TextFormField(
        cursorColor: Colors.white,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        // validator: (email) => email != null && !EmailValidator.validate(email)
        //     ? 'Masukkan email yang valid'
        //     : null,
        controller: txtEditUsername,
        onSaved: (String val) {
          txtEditUsername.text = val;
        },
        decoration: InputDecoration(
          hintText: 'Masukkan Username',
          hintStyle: const TextStyle(color: Colors.white),
          labelText: "Masukkan Username",
          labelStyle: const TextStyle(color: Colors.white),
          prefixIcon: const Icon(
            Icons.account_circle_rounded,
            color: Colors.white,
          ),
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(
              color: Colors.white,
              width: 2.0,
            ),
          ),
        ),
        style: const TextStyle(fontSize: 16.0, color: Colors.white));
  }

  Widget inputPassword() {
    return TextFormField(
      cursorColor: Colors.white,
      keyboardType: TextInputType.text,
      autofocus: false,
      obscureText: _secureText, //make decript inputan
      validator: (String arg) {
        if (arg == null || arg.isEmpty) {
          return 'Password harus diisi';
        } else {
          return null;
        }
      },
      controller: txtEditPwd,
      onSaved: (String val) {
        txtEditPwd.text = val;
      },
      decoration: InputDecoration(
        hintText: 'Masukkan Password',
        hintStyle: const TextStyle(color: Colors.white),
        labelText: "Masukkan Password",
        labelStyle: const TextStyle(color: Colors.white),
        suffixIcon: IconButton(
          onPressed: showhide,
          icon: Icon(_secureText
              ? Icons.visibility_off
              : Icons.visibility),
        ),
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
      ),
      style: const TextStyle(fontSize: 16.0, color: Colors.white),
    );
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
      //If all data are correct then save data to out variables
      _formKey.currentState.save();
      doLogin(txtEditUsername.text, txtEditPwd.text);
    }
  }

  doLogin(String username, String password) async {
    final GlobalKey<State> _keyLoader = GlobalKey<State>();
    Dialogs.loading(context, _keyLoader, "Proses ...");

    try {
      final response = await http.post(
          Uri.parse(ApiService.urlUtama+"login/proseslogin"),
          // headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: {
            "username": username,
            "passw": password,
          });

      final output = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Navigator.of(_keyLoader.currentContext, rootNavigator: false).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                output['message'],
                style: const TextStyle(fontSize: 16),
              )),
        );

        if (output['status'] == 1) {
          String token = output['token'];
          String nama = output['nama'];
          String foto = output['foto'];
          String idEselon = output['id_eselon'];
          String jabatan = output['unit_kerja'];
          String jenisInstansi = output['jenis_instansi'];
          String namaInstansi = output['nama_instansi'];
          String kecamatan = output['kecamatan'];
          String idPns = output['id_pns'];
          saveSession(token,username,nama,foto,idEselon,jabatan,jenisInstansi,namaInstansi,kecamatan,idPns);
        }
        //debugPrint(output['message']);
      } else {
        Navigator.of(_keyLoader.currentContext, rootNavigator: false).pop();
        //debugPrint(output['message']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                output.toString(),
                style: const TextStyle(fontSize: 16),
              )),
        );
      }
    } catch (e) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: false).pop();
      Dialogs.popUp(context, '$e');
      debugPrint('$e');
    }
  }

  saveSession(String token,username,nama,foto,idEselon,jabatan,jenisInstansi,namaInstansi,kecamatan,idPns) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // await pref.setString("email", username);
    await pref.setString("niplogin", username);
    await pref.setString("tokenlogin", token);
    await pref.setString("namalogin", nama);
    await pref.setString("fotoLogin", foto);
    await pref.setString("ideselon", idEselon);
    await pref.setString("jabatan", jabatan);
    await pref.setString("id_pns", idPns);
    await pref.setBool("is_login", true);
    setState(() {
      _loginStatus = LoginStatus.signIn;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()),);
    });
    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(
    //     builder: (BuildContext context) => const HomePage(),
    //   ),
    //       (route) => false,
    // );
  }

  void ceckLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var islogin = pref.getBool("is_login");
    if (islogin != null && islogin) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const HomePage(),
        ),
            (route) => false,
      );
    }
  }

  @override
  void initState() {
    ceckLogin();
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Container(
        margin: const EdgeInsets.all(0),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blueAccent, Color.fromARGB(255, 21, 236, 229)],
            )),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ClipPath(
                clipper: HeadClipper(),
                child: Container(
                  margin: const EdgeInsets.all(0),
                  width: double.infinity,
                  height: 180,
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    image: DecorationImage(
                      image: AssetImage('assets/ekinerja2020.png'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: const Text(
                  "LOGIN E-Kinerja",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                  padding:
                  const EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      inputUsername(),
                      const SizedBox(height: 20.0),
                      inputPassword(),
                      const SizedBox(height: 5.0),
                    ],
                  )),
              Container(
                padding:
                const EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: const BorderSide(color: Colors.blue),
                        ),
                        elevation: 10,
                        minimumSize: const Size(200, 58)),
                    onPressed: () => _validateInputs(),
                    icon: const Icon(Icons.arrow_right_alt),
                    label: const Text(
                      "LOG IN",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
