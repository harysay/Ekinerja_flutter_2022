import 'package:ekinerja2020/service/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:ekinerja2020/pages/about_page.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io';

class AboutFragment extends StatelessWidget {
  Future<Map<String, String>> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    return {
      'versionName': info.version,
      'versionCode': info.buildNumber,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: _initPackageInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final versionName = snapshot.data?['versionName'] ?? 'Unknown';
          final versionCode = snapshot.data?['versionCode'] ?? 'Unknown';

          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Bagian Atas
                Container(
                  padding: EdgeInsets.all(20.0),
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      Text(" \u00a9 Dinas Kominfo Kabupaten Kebumen ${DateTime.now().year}"),
                      Text("All rights reserved"),
                      // Tambahan teks lainnya di bagian atas jika diperlukan
                    ],
                  ),
                ),
                // Bagian Tengah
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/kominfo.png',
                          height: 200, // Sesuaikan tinggi gambar
                          width: 200, // Sesuaikan lebar gambar
                          fit: BoxFit.contain,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _launchPDF(context);
                          },
                          child: Text('Manual E-Kinerja Android'),
                        ),
                      ],
                    ),
                  ),
                ),
                // Bagian Bawah
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    alignment: Alignment.center,
                    child: Text(
                      '$versionName (Build $versionCode)',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  _launchPDF(BuildContext context) async {
    const pdfUrl = 'https://tukin.kebumenkab.go.id/assets/manualBook/manualekinerja.pdf';

    try {
      // Get the default CacheManager
      var cacheManager = DefaultCacheManager();

      // Download the PDF file and store it in the cache
      File file = await cacheManager.getSingleFile(pdfUrl);

      // Navigate to PdfViewerPage with the downloaded file
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewerPage(filePath: file.path),
        ),
      );
    } catch (e) {
      print('Error: $e');
      // Handle errors as needed
    }
  }
}

class PdfViewerPage extends StatelessWidget {
  final String filePath;

  PdfViewerPage({required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manual Book E-Kinerja'),
      ),
      body: PDFView(
        filePath: filePath,
        enableSwipe: true,
        swipeHorizontal: false,
      ),
    );
  }
}