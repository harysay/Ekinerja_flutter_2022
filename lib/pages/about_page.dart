import 'package:flutter/material.dart';
import 'package:ekinerja2020/service/ApiService.dart';

class AboutPage extends StatelessWidget {
  final List<VersionInfo> versionInfoList = [
    // Tambahkan item perbaikan untuk versi-versi lain di atas sini
    VersionInfo(version: "6.2.pb.14052024", author: "Imanaji Hari Sayekti", changes: "Perbaikan jumlah diakui verifikasi, peringatan input, delete tidak bisa,selesai edit tidak refresh"),
    VersionInfo(version: "6.1.pb.23042024", author: "Imanaji Hari Sayekti", changes: "Perubahan logo pemkab kebumen yang benar"),
    VersionInfo(version: "5.2.pb.21112023", author: "Imanaji Hari Sayekti", changes: "Perbaikan tampilan form tambah, perbaikan tampilan saat dark mode"),
    VersionInfo(version: "5.1.pb.02112023", author: "Imanaji Hari Sayekti", changes: "Perubahan Login, tampilan presensi dan tamsil di home, beberapa perbaikan lainnya"),
    VersionInfo(version: "2.0.pb.30112021", author: "Imanaji Hari Sayekti", changes: "Perbaikan, tidak bisa menampilkan data aktivitas"),
    VersionInfo(version: "2.0.b.27082021", author: "Imanaji Hari Sayekti", changes: "Perbaikan, tidak bisa menampilkan data aktivitas"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Version Info List"),
      ),
      body: ListView.builder(
        itemCount: versionInfoList.length,
        itemBuilder: (context, index) {
          return VersionItem(versionInfo: versionInfoList[index]);
        },
      ),
    );
  }
}

class VersionInfo {
  final String version;
  final String author;
  final String changes;

  VersionInfo({required this.version, required this.author, required this.changes});
}

class VersionItem extends StatelessWidget {
  final VersionInfo versionInfo;

  VersionItem({required this.versionInfo});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                text: "Versi ${versionInfo.version}\n",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16, // Ukuran font versi
                ),
              ),
              TextSpan(
                text: "By: ${versionInfo.author}\n",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              TextSpan(
                text: versionInfo.changes,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
