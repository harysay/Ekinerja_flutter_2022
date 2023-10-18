import 'package:ekinerja2020/model/daftar_pegawaiverifikasi.dart';
class DaftarPegawaiVerifikasiResponse{
  String? status;
  //String msg;
  List<DaftarPegawaiVerifikasi>? data;

  DaftarPegawaiVerifikasiResponse({this.status,
    //this.msg,
    this.data});

  factory DaftarPegawaiVerifikasiResponse.fromJson(Map<String,dynamic>map){
    var allAktivitas = map['data'] as List;
    List<DaftarPegawaiVerifikasi> aktivitasList = allAktivitas.map((i) => DaftarPegawaiVerifikasi.fromJson(i)).toList();
    return DaftarPegawaiVerifikasiResponse(
        status: map["status"],
        //msg: map["message"],
        data: aktivitasList
    );
  }
}