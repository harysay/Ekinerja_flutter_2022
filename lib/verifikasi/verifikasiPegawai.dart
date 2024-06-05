import 'dart:async';
import 'dart:convert';
import 'package:ekinerja2020/service/ApiService.dart';
import 'package:ekinerja2020/verifikasi/player/content.dart';
import 'package:ekinerja2020/verifikasi/player/playlist.dart';
import 'package:ekinerja2020/verifikasi/splash/list_tile_splash.dart';
import 'package:ekinerja2020/verifikasi/ui/buttons.dart';
import 'package:ekinerja2020/verifikasi/ui/tabs.dart';
import 'package:ekinerja2020/verifikasi/util/show_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:ekinerja2020/model/daftar_aktivitas.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ekinerja2020/verifikasi/ui/icon_button.dart';
import 'package:http/http.dart' as http;
import 'package:ekinerja2020/response/daftar_aktivitas_response.dart';
import 'package:catcher/catcher.dart';

import 'animations.dart';
import 'selection_widgets.dart';
import 'selection.dart';
import 'switcher.dart';

export 'animations.dart';
export 'selection_widgets.dart';
export 'selection.dart';
export 'switcher.dart';

class VerifikasiPegawai extends StatefulWidget {
  final String idpns, tokenver;
  VerifikasiPegawai({Key? key, required this.idpns, required this.tokenver}) : super(key: key);

  @override
  _HalVerifState createState() => _HalVerifState();
}

class _HalVerifState extends State<VerifikasiPegawai> with TickerProviderStateMixin {
  List<DaftarAktivitas> semuaAktivitas = [];
  Set<String> selectedAktivitas = Set();
  bool isLoading = true;
  bool inSelectionMode = false;

  ApiService api = ApiService();
  TextEditingController alasanKembaliCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    List<DaftarAktivitas>? aktivitas = await api.getAllActivityVer(widget.tokenver, widget.idpns);
    if (aktivitas != null) {
      setState(() {
        semuaAktivitas = aktivitas;
        isLoading = false;
      });
    }
  }

  void _handleSetujuiSemua() async {
    for (var aktivitas in semuaAktivitas) {
      print('Menyetujui aktivitas: ${aktivitas.idDataKinerja}'); // Debug statement
      await api.setujuiAktivitas(widget.tokenver, aktivitas.idDataKinerja!, aktivitas.waktuDiakui!, aktivitas.tglKinerja!);
    }
    ShowFunctions.showToast(msg: "Semua aktivitas berhasil disetujui!");
    _fetchData();
  }

  void _handleSetuju() async {
    for (var id in selectedAktivitas) {
      var aktivitas = semuaAktivitas.firstWhere((element) => element.idDataKinerja == id);
      await api.setujuiAktivitas(widget.tokenver, aktivitas.idDataKinerja!, aktivitas.waktuDiakui!, aktivitas.tglKinerja!);
    }
    ShowFunctions.showToast(msg: "Aktivitas berhasil disetujui!");
    setState(() {
      selectedAktivitas.clear();
      inSelectionMode = false;
    });
    _fetchData();
  }

  void _handleTolak() async {
    for (var id in selectedAktivitas) {
      await api.kembalikanAktivitas(widget.tokenver, id, "Ditolak", alasanKembaliCont.text);
    }
    ShowFunctions.showToast(msg: "Aktivitas berhasil ditolak!");
    setState(() {
      selectedAktivitas.clear();
      inSelectionMode = false;
    });
    _fetchData();
  }

  void _handleKembalikan() async {
    for (var id in selectedAktivitas) {
      await api.kembalikanAktivitas(widget.tokenver, id, "Dikembalikan", alasanKembaliCont.text);
    }
    ShowFunctions.showToast(msg: "Aktivitas berhasil dikembalikan!");
    setState(() {
      selectedAktivitas.clear();
      inSelectionMode = false;
    });
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verifikasi Aktivitas"),
        actions: [
          if (!inSelectionMode)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: _handleSetujuiSemua,
            )
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _fetchData,
        child: ListView.builder(
          itemCount: semuaAktivitas.length,
          itemBuilder: (context, index) {
            var aktivitas = semuaAktivitas[index];
            return ListTile(
              title: Text(aktivitas.namaPekerjaan ?? ''),
              subtitle: Text(aktivitas.uraianPekerjaan?? ''),
              selected: selectedAktivitas.contains(aktivitas.idDataKinerja),
              onLongPress: () {
                setState(() {
                  inSelectionMode = true;
                  selectedAktivitas.add(aktivitas.idDataKinerja!);
                });
              },
              onTap: () {
                if (inSelectionMode) {
                  setState(() {
                    if (selectedAktivitas.contains(aktivitas.idDataKinerja)) {
                      selectedAktivitas.remove(aktivitas.idDataKinerja);
                      if (selectedAktivitas.isEmpty) {
                        inSelectionMode = false;
                      }
                    } else {
                      selectedAktivitas.add(aktivitas.idDataKinerja!);
                    }
                  });
                }
              },
            );
          },
        ),
      ),
      bottomNavigationBar: inSelectionMode
          ? BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.check, color: Colors.green),
              onPressed: _handleSetuju,
            ),
            IconButton(
              icon: Icon(Icons.clear, color: Colors.red),
              onPressed: () {
                _showDialog(
                  title: "Tolak Aktivitas",
                  onAccept: _handleTolak,
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.replay, color: Colors.orange),
              onPressed: () {
                _showDialog(
                  title: "Kembalikan Aktivitas",
                  onAccept: _handleKembalikan,
                );
              },
            ),
          ],
        ),
      )
          : null,
    );
  }

  void _showDialog({required String title, required VoidCallback onAccept}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: alasanKembaliCont,
            decoration: InputDecoration(hintText: "Masukkan alasan"),
          ),
          actions: [
            TextButton(
              child: Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                onAccept();
              },
            ),
          ],
        );
      },
    );
  }
}