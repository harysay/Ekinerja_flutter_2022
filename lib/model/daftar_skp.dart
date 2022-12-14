import 'dart:convert';
import 'package:ekinerja2020/model/daftar_pegawaiverifikasi.dart';

class DaftarSkp{
  int numb;
  String idDataSkp;
  String rkAtasan;
  String rk;
  String jenisKinerja;
  String aspekSAk;
  String aspekSIkiKuant;
  String aspekSIkiKuantTarget;
  String aspekSIkiKuantSatuanOutput;
  String aspekSIkiKual;
  String aspekSIkiKualTarget;
  String aspekSIkiWaktu;
  String aspekSIkiWaktuTarget;
  String aspekSIkiWaktuSatuanOutput;
  bool selected = false;

  DaftarSkp({this.numb,this.idDataSkp,this.rkAtasan,this.rk,this.jenisKinerja,this.aspekSAk,this.aspekSIkiKuant,this.aspekSIkiKuantTarget,this.aspekSIkiKuantSatuanOutput,this.aspekSIkiKual,this.aspekSIkiKualTarget,this.aspekSIkiWaktu,this.aspekSIkiWaktuTarget,this.aspekSIkiWaktuSatuanOutput});
  
  factory DaftarSkp.fromJson(Map<String, dynamic> map) {
    return DaftarSkp(
        numb: map["numb"],
      idDataSkp: map["id"],
      rkAtasan: map["rk_atasan"],
      rk: map["rk"],
      jenisKinerja: map["jenis_kinerja"],
      aspekSAk: map["aspek_s_ak"],
      aspekSIkiKuant: map["aspek_s_iki_kuant"],
      aspekSIkiKuantTarget: map["aspek_s_iki_kuant_target"],
      aspekSIkiKuantSatuanOutput: map["aspek_s_iki_kuant_satuan_output"],
      aspekSIkiKual: map["aspek_s_iki_kual"],
      aspekSIkiKualTarget: map["aspek_s_iki_kual_target"],
      aspekSIkiWaktu: map["aspek_s_iki_waktu"],
      aspekSIkiWaktuTarget: map["aspek_s_iki_waktu_target"],
      aspekSIkiWaktuSatuanOutput: map["aspek_s_iki_waktu_satuan_output"],
    );
  }

  static List<DaftarSkp> daftarAktivitasFromJson(String jsonData){
    final data = json.decode(jsonData);
    return List<DaftarSkp>.from(data.map((item) => DaftarSkp.fromJson(item)));
  }
}
