import 'package:ekinerja2020/model/daftar_bulansemuaverifikasi.dart';
class DaftarBulanSemuaVerifikasiResponse{
  String? status;
  //String msg;
  List<DaftarBulanSemuaVerifikasi>? data;

  DaftarBulanSemuaVerifikasiResponse({this.status,
    //this.msg,
    this.data});

  factory DaftarBulanSemuaVerifikasiResponse.fromJson(Map<String,dynamic>map){
    var allAktivitas = map['data'] as List;
    List<DaftarBulanSemuaVerifikasi> aktivitasList = allAktivitas.map((i) => DaftarBulanSemuaVerifikasi.fromJson(i)).toList();
    return DaftarBulanSemuaVerifikasiResponse(
        status: map["status"],
        //msg: map["message"],
        data: aktivitasList
    );
  }
}