import 'dart:convert';

class DaftarBulanSemuaVerifikasi{
  int? numb;
  String? idPns;
  String? belumVerBlnIni;
  String? belumVerBlnLalu;
  String? menitSudah;

  DaftarBulanSemuaVerifikasi({this.numb,this.idPns,this.belumVerBlnIni,this.belumVerBlnLalu,this.menitSudah});
  
  factory DaftarBulanSemuaVerifikasi.fromJson(Map<String, dynamic> map) {
    return DaftarBulanSemuaVerifikasi(
        numb: map["numb"],
        idPns: map["id_pns"],
        belumVerBlnIni: map["bln_ini"],
        belumVerBlnLalu: map["bln_lalu"],
        menitSudah: map["mnt_sdh"],
    );
  }
  static List<DaftarBulanSemuaVerifikasi> daftarAktivitasFromJson(String jsonData){
    final data = json.decode(jsonData);
    return List<DaftarBulanSemuaVerifikasi>.from(data.map((item) => DaftarBulanSemuaVerifikasi.fromJson(item)));
  }
}