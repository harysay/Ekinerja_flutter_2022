import 'package:ekinerja2020/model/daftar_aktivitas.dart';

class DaftarAktivitasResponse{
  String status;
  String info;
  List<DaftarAktivitas> data;

  DaftarAktivitasResponse({this.status,
    this.info,
    this.data});

  factory DaftarAktivitasResponse.fromJson(Map<String,dynamic>map){
    var allAktivitas = map['data'] as List;
    List<DaftarAktivitas> aktivitasList = allAktivitas.map((i) => DaftarAktivitas.fromJson(i)).toList();
    return DaftarAktivitasResponse(
      status: map["status"],
        info: map["info"],
        data: aktivitasList
    );
  }
}