import 'package:ekinerja2020/model/daftar_aktivitas.dart';

class DaftarAktivitasResponseVar{
  String? status;
  //String msg;
  var data;

  DaftarAktivitasResponseVar({this.status,
    //this.msg,
    this.data});

  factory DaftarAktivitasResponseVar.fromJson(Map<String,dynamic>map){
    var allAktivitas = map['data'] as List;
    var aktivitasList = allAktivitas.map((i) => DaftarAktivitas.fromJson(i)).toList();
    return DaftarAktivitasResponseVar(
      status: map["status"],
        //msg: map["message"],
        data: aktivitasList
    );
  }
}