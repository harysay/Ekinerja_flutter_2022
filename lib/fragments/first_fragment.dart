import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ekinerja2020/service/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';
ApiService api = new ApiService();

class FirstFragment extends StatefulWidget {
  @override
  _FirstFragmentState createState() => _FirstFragmentState();

}
class _FirstFragmentState extends State<FirstFragment>{
  var tarikanNamaUser, tarikanPangkatUser, tarikanJabatanUser, tarikanInstansiUser;
  var tarikanNamaAtasan, tarikanNipAtasan, tarikanJabatanAtasan, tarikanInstansiAtasan;
  String username="", nama="",tokenlogin="";
  var loading = false;
  String url;

  Future<Null> _fetchData()async{
    setState(() {
      loading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      tokenlogin = preferences.getString("tokenlogin");

    });
    final response = await http.get(api.urlGetdataPribadi+tokenlogin);
    if(response.statusCode == 200){
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
    }else{
      Text("error bro");
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
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    TextStyle styleDashboard = Theme.of(context).textTheme.body1;
    TextStyle styleTitle = Theme.of(context).textTheme.title;
    return new Center(
      //child: new Text("Hello Fragment 1"),
      child: loading ? Center(child: CircularProgressIndicator())
          : new Column(
            children: <Widget>[
              new Container(
                  padding: new EdgeInsets.all(20.0),
                  child: new Column(
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          new Text("Nama",style: styleDashboard),
                          SizedBox(width: 60.0,),
                          new Text(": "),
                          SizedBox(width: 10.0,),
                          Flexible(child: new Text(tarikanNamaUser,style: styleDashboard,))
                        ],
                      ),
                      new Row(
                        children: <Widget>[
                          new Text("Pangkat/Gol"),
                          SizedBox(width: 15.0,),
                          new Text(": "),
                          SizedBox(width: 15.0,),
                          Flexible(child: new Text(tarikanPangkatUser))
                        ],
                      ),
                      new Row(
                        children: <Widget>[
                          new Text("Jabatan"),
                          SizedBox(width: 42.0,),
                          new Text(": "),
                          SizedBox(width: 10.0,),
                          Flexible(child: new Text(tarikanJabatanUser))
                        ],
                      ),
                      new Row(
                        children: <Widget>[
                          new Text("Instansi"),
                          SizedBox(width: 44.0,),
                          new Text(": "),
                          SizedBox(width: 10.0,),
                          Flexible(child: new Text(tarikanInstansiUser))
                        ],
                      )
                    ],
                  )
              ),
              new Container(
                  padding: new EdgeInsets.all(20.0),
                  color: Colors.yellow[50],
                  child: new Column(
                    children: <Widget>[
                      new Center(
                        child: new Text("Data Atasan",style: styleTitle),
                      ),
                      new Row(
                        children: <Widget>[
                          new Text("Nama",style: styleDashboard),
                          SizedBox(width: 60.0,),
                          new Text(": "),
                          SizedBox(width: 10.0,),
                          Flexible(child: new Text(tarikanNamaAtasan,style: styleDashboard,))
                        ],
                      ),
                      new Row(
                        children: <Widget>[
                          new Text("NIP"),
                          SizedBox(width: 75.0,),
                          new Text(": "),
                          SizedBox(width: 10.0,),
                          Flexible(child: new Text(tarikanNipAtasan))
                        ],
                      ),
                      new Row(
                        children: <Widget>[
                          new Text("Jabatan"),
                          SizedBox(width: 42.0,),
                          new Text(": "),
                          SizedBox(width: 10.0,),
                          Flexible(child: new Text(tarikanJabatanAtasan))
                        ],
                      ),
                      new Row(
                        children: <Widget>[
                          new Text("Instansi"),
                          SizedBox(width: 44.0,),
                          new Text(": "),
                          SizedBox(width: 10.0,),
                          Flexible(child: new Text(tarikanInstansiAtasan))
                        ],
                      )
                    ],
                  )
              )
            ],
          ),
    );
  }
}