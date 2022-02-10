import 'package:flutter/material.dart';

class MaintenancePage extends StatelessWidget {
  static var tag;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Dalam Perawatan',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Under Maintenance'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/maintenancepage.png',
              height: 450,
              width: 250,
              fit: BoxFit.fitWidth,
            ),
            Container(
              color: Colors.deepOrange[300],
              child: Text('Mohon Maaf, untuk sementara aplikasi sedang tidak bisa digunakan. Silahkan tunggu beberapa saat lagi',textAlign: TextAlign.center,style: TextStyle(fontSize: 16))
            ),
//            Center(
//                child: DecoratedBox( // here is where I added my DecoratedBox
//                decoration: BoxDecoration(color: Colors.deepOrange[300]),
//                child: Text('Mohon Maaf, untuk sementara aplikasi sedang tidak bisa digunakan. Silahkan tunggu beberapa saat lagi')
//                ),
//            )
          ],
        ),
//        Center(
//          child: DecoratedBox( // here is where I added my DecoratedBox
//            decoration: BoxDecoration(color: Colors.deepOrange[300]),
//            child: Text('Mohon Maaf, untuk sementara aplikasi sedang tidak bisa digunakan. Silahkan tunggu beberapa saat lagi, Atau hubungi Admin'),
//          ),
//        ),
      ),
    );
  }
}