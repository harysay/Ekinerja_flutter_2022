import 'dart:convert';

class DaftarListPegawaiVerifikasi{
  int? numb;
  String? idPns;
  String? idNipBaru;
  String? idNipLama;
  String? foto;
  String? namaPgawai;

  DaftarListPegawaiVerifikasi({this.numb,this.idPns,this.idNipBaru,this.idNipLama,this.foto,this.namaPgawai});
  
  factory DaftarListPegawaiVerifikasi.fromJson(Map<String, dynamic> map) {
    return DaftarListPegawaiVerifikasi(
        numb: map["numb"],
        idPns: map["id_pns"],
        idNipBaru: map["nip_baru"],
        idNipLama: map["nip_lama"],
        foto: map["foto"],
        namaPgawai: map["nama"],
    );
  }
  static List<DaftarListPegawaiVerifikasi> daftarAktivitasFromJson(String jsonData){
    final data = json.decode(jsonData);
    return List<DaftarListPegawaiVerifikasi>.from(data.map((item) => DaftarListPegawaiVerifikasi.fromJson(item)));
  }
}