import 'package:ekinerja2020/model/daftar_listpegawaiverifikasi.dart';
class DaftarListPegawaiVerifikasiResponse{
  String? status;
  //String msg;
  List<DaftarListPegawaiVerifikasi>? data;

  DaftarListPegawaiVerifikasiResponse({this.status,
    //this.msg,
    this.data});

  factory DaftarListPegawaiVerifikasiResponse.fromJson(Map<String,dynamic>map){
    var allAktivitas = map['data'] as List;
    List<DaftarListPegawaiVerifikasi> aktivitasList = allAktivitas.map((i) => DaftarListPegawaiVerifikasi.fromJson(i)).toList();
    return DaftarListPegawaiVerifikasiResponse(
        status: map["status"],
        //msg: map["message"],
        data: aktivitasList
    );
  }
}