import 'package:ekinerja2020/service/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutFragment extends StatelessWidget {
  DateTime sekarang = new DateTime.now();
  // ApiService getapi = new ApiService();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      color: Colors.black12,
      height: double.maxFinite,
      child: new Stack(
        //alignment:new Alignment(x, y)
        children: <Widget>[
          new Positioned(
            child: new Center(
              child: new Column(
                children: <Widget>[
                  new Text(ApiService.tahunSekarang+" \u00a9 Dinas Kominfo Kabupaten Kebumen"),
                  new Text("All rights reserved"),
                ],
              ),
            )
          ),
          new Positioned(
            child: new Center(
              child: new Column(
                children: <Widget>[
                  new Image.asset(
                    'assets/kominfo.png',
                    height: 300,
                    width: 250,
                    fit: BoxFit.fitWidth,
                  ),
                  new Text(ApiService.versionBuildSekarang),
                  new Center(
                    child: new ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        onPrimary: Colors.white,
                        animationDuration: Duration(milliseconds: 1000),
                        primary: Colors.orangeAccent,
                        shadowColor: Colors.redAccent,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: _launchURL,
                      child: new Text('Manual E-Kinerja Android'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          new Positioned(
            child: new Align(
                alignment: FractionalOffset.bottomCenter,
                child: new Text("Develop by Imanaji Hari Sayekti"),
            ),
          )
        ],
      ),
    );
//    return new Center(
//      child: new Column(
//        children: <Widget>[
//          new Text("Develop by Imanaji Hari Sayekti"),
//          new Text("Copyright 2020 Dinas Kominfo Kabupaten Kebumen"),
//          new Text("All rights reserved"),
//          new Positioned(
//            child: new Align(
//                alignment: FractionalOffset.bottomCenter,
//              child: new Text("Version 1.0.b.04082020"),
//            ),
//          )
//        ],
//      ),
////      child: new Text("Develop by Imanaji Hari Sayekti \nCopyright 2020 Dinas Kominfo Kabupaten Kebumen \nAll rights reserved \nVersion 1.0.b.04082020"),
//    );
  }

  _launchURL() async {
    const url = 'https://tukin.kebumenkab.go.id/assets/manualBook/ManualBookE-KinerjaAndroid.pdf';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}