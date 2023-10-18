import 'dart:convert';

class DaftarPegawaiVerifikasi{
  int? numb;
  String? idPns;
  String? idNipBaru;
  String? idNipLama;
  String? foto;
  String? namaPgawai;
  String? belumVerBlnLalu;
  String? belumVerBlnIni;
  String? menitSudah;

  DaftarPegawaiVerifikasi({this.numb,this.idPns,this.idNipBaru,this.idNipLama,this.foto,this.namaPgawai,this.belumVerBlnIni,this.belumVerBlnLalu,this.menitSudah});
  
  factory DaftarPegawaiVerifikasi.fromJson(Map<String, dynamic> map) {
    return DaftarPegawaiVerifikasi(
        numb: map["numb"],
        idPns: map["id_pns"],
        idNipBaru: map["nip_baru"],
        idNipLama: map["nip_lama"],
        foto: map["foto"],
        namaPgawai: map["nama"],
        belumVerBlnIni: map["bln_ini"],
        belumVerBlnLalu: map["bln_lalu"],
        menitSudah: map["mnt_sdh"],
    );
  }
  static List<DaftarPegawaiVerifikasi> daftarAktivitasFromJson(String jsonData){
    final data = json.decode(jsonData);
    return List<DaftarPegawaiVerifikasi>.from(data.map((item) => DaftarPegawaiVerifikasi.fromJson(item)));
  }
}