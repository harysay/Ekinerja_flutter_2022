import 'dart:convert';
import 'package:ekinerja2020/model/daftar_pegawaiverifikasi.dart';

class DaftarAktivitas{
  int? numb;
  String? idDataKinerja;
  String? idPekerjaan;
  String? tglKinerja;
  String? namaPekerjaan;
  String? uraianPekerjaan;
  String? waktuMengerjakan;
  String? standarWaktu;
  String? waktuDiakui;
  String? status;
  String? idSubPekerjaan;
  String? honorDiakui;
  String? jamMulai;
  String? jamSelesai;
  String? namaSubPekerjaan;
  bool selected = false;

  DaftarAktivitas({this.numb,this.idDataKinerja,this.idPekerjaan,this.tglKinerja,this.namaPekerjaan,this.uraianPekerjaan,this.waktuMengerjakan,this.standarWaktu,this.waktuDiakui,this.status,this.idSubPekerjaan,this.honorDiakui,this.jamMulai,this.jamSelesai,this.namaSubPekerjaan});
  
  factory DaftarAktivitas.fromJson(Map<String, dynamic> map) {
    return DaftarAktivitas(
        numb: map["numb"],
        idDataKinerja: map["id_data_kinerja"],
        idPekerjaan: map["idpekerjaan"],
        tglKinerja: map["tgl_kinerja"],
        namaPekerjaan: map["nama_pekerjaan"],
        uraianPekerjaan: map["uraian_pekerjaan"],
        waktuMengerjakan: map["waktu_mengerjakan"],
        standarWaktu: map["standar_waktu"],
        waktuDiakui: map["waktu_diakui"],
        status: map["status"],
        idSubPekerjaan: map["idsubpekerjaan"],
        honorDiakui: map["honor_diakui"],
        jamMulai: map["jam_mulai"],
        jamSelesai: map["jam_selesai"],
        namaSubPekerjaan : map["namasubpekerjaan"],
    );
  }

  static List<DaftarAktivitas> daftarAktivitasFromJson(String jsonData){
    final data = json.decode(jsonData);
    return List<DaftarAktivitas>.from(data.map((item) => DaftarAktivitas.fromJson(item)));
  }
}
