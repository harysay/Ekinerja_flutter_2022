import 'package:ekinerja2020/model/daftar_aktivitas.dart';
import 'package:ekinerja2020/model/daftar_skp.dart';

class DaftarSkpResponse{
  String status;
  String info;
  List<DaftarSkp> data;

  DaftarSkpResponse({this.status,
    this.info,
    this.data});

  factory DaftarSkpResponse.fromJson(Map<String,dynamic>map){
    var allSkp = map['data'] as List;
    List<DaftarSkp> skpList = allSkp.map((i) => DaftarSkp.fromJson(i)).toList();
    return DaftarSkpResponse(
      status: map["status"],
        info: map["info"],
        data: skpList
    );
  }
}