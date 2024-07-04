import 'dart:convert';
import 'package:ekinerja2020/model/daftar_bulansemuaverifikasi.dart';
import 'package:ekinerja2020/model/daftar_listpegawaiverifikasi.dart';
import 'package:ekinerja2020/model/daftar_pegawaiverifikasi.dart';
import 'package:ekinerja2020/model/daftar_skp.dart';
import 'package:ekinerja2020/response/daftar_bulansemuaverifikasi_response.dart';
import 'package:ekinerja2020/response/daftar_listpegawaiverifikasi_response.dart';
import 'package:ekinerja2020/response/daftar_skp_response.dart';
import 'package:http/http.dart' as http;
import 'package:ekinerja2020/model/daftar_aktivitas.dart';
import 'package:ekinerja2020/response/daftar_aktivitas_response.dart';
import 'package:ekinerja2020/response/daftar_pegawaiverifikasi_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  String username="", nama=""; //,tokenlogin="";
  List? jsonku;

  // static String urlUtama = "https://development.kebumenkab.go.id/siltapkin/index.php/api/";
  static String urlUtama = "https://tukin.kebumenkab.go.id/api/";
  // static String urlUtama = "https://tukin.kebumenkab.go.id/2020/index.php/api/";
  // static String versionCodeSekarang = "15"; //harus sama dengan version di build.gradle app-nya
  // static String tahunSekarang = DateTime.now().year.toString();//"2024";
  // static String versionBuildSekarang = "Version 6.3.pb.20062024";

  // getPrefFromApi() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   tokenlogin = preferences.getString("tokenlogin")!;
  // }


  DaftarPegawaiVerifikasiResponse pegawairesponse = new DaftarPegawaiVerifikasiResponse();
  Future<List<DaftarPegawaiVerifikasi>?> getAllPegawaiVer(String tokenDafAktiv) async {
    //Map<String, dynamic> inputMap = {'DEMO-API-KEY': '$key'};
    // getPrefFromApi();
    final response = await http.post(Uri.parse(
      ApiService.urlUtama+"verifikasi/tampilpegawai?token="+tokenDafAktiv),
//      headers: {
//        "Accept": "application/json",
//        "Content-Type": "application/x-www-form-urlencoded",
//        "authorization": basicAuth
//      },
//      body: inputMap,
    );

    pegawairesponse = DaftarPegawaiVerifikasiResponse.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {
      List<DaftarPegawaiVerifikasi> data = pegawairesponse.data!;
      return data;
    } else {
      return null;
    }
  }

  //get data detail pegawai yang mau diverifikasi oleh verifikator saja
  DaftarListPegawaiVerifikasiResponse listpegawairesponse = new DaftarListPegawaiVerifikasiResponse();
  Future<List<DaftarListPegawaiVerifikasi>?> getDetailPegawaiDiVer(String tokenDafAktiv) async {
    // getPrefFromApi();
    final response = await http.post(Uri.parse(
        ApiService.urlUtama+"verifikasi/list_Pegawai_staf?token="+tokenDafAktiv),
    );
    listpegawairesponse = DaftarListPegawaiVerifikasiResponse.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {
      List<DaftarListPegawaiVerifikasi> data = listpegawairesponse.data!;
      return data;
    } else {
      return null;
    }
  }

  //get data bulan ini bulan lalu menit sudah dari pegawai yang mau diverifikasi oleh verifikator by id pns
  DaftarBulanSemuaVerifikasiResponse listBulanMenitresponse = new DaftarBulanSemuaVerifikasiResponse();
  Future<List<DaftarBulanSemuaVerifikasi>?> getBulanMenitPegawaiDiVer(String tokenDafAktiv,String idPns) async {
    // getPrefFromApi();
    final response = await http.post(Uri.parse(
        ApiService.urlUtama+"verifikasi/bulan_semua?token="+tokenDafAktiv+"&id_pns="+idPns),
    );
    listBulanMenitresponse = DaftarBulanSemuaVerifikasiResponse.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {
      List<DaftarBulanSemuaVerifikasi> data = listBulanMenitresponse.data!;
      return data;
    } else {
      return null;
    }
  }

  DaftarAktivitasResponse rAlActivity = new DaftarAktivitasResponse();
  getSemuaAktivitas(String tokenListAktivitas)async{
    final response = await http.get(Uri.parse(ApiService.urlUtama+"rekam/tampildaftar?token="+tokenListAktivitas));
    rAlActivity = DaftarAktivitasResponse.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {
      var data = rAlActivity.data;
      return data;
    } else {
      return null;
    }
  }

  DaftarSkpResponse allSkp = new DaftarSkpResponse();
  Future<List<DaftarSkp>?> getSemuaSkp( String tokenLemparan)async{
    // await getPrefFromApi();
    final response = await http.get(Uri.parse(ApiService.urlUtama+"skp/daftar_skp?token="+tokenLemparan));
    allSkp = DaftarSkpResponse.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {
      List<DaftarSkp> data = allSkp.data!;
      return data;
    } else {
      return null;
    }
  }

  DaftarAktivitasResponse rSudahverfiPribadi = new DaftarAktivitasResponse();
  Future<List<DaftarAktivitas>?> getSudahverfiPribadi(String tokenverfi)async{
    DateTime now = new DateTime.now();
    var bulan;
    if(now.day<2){
      bulan = now.month-1;
    }else{
      bulan = now.month;
    }
    final response = await http.get(Uri.parse(ApiService.urlUtama+"rekam/verif_individu_bulanan?token="+tokenverfi+"&bulan="+bulan.toString()+"&tahun="+now.year.toString()),
//      headers: {
//        "Accept": "application/json",
//        "Content-Type": "application/x-www-form-urlencoded",
//        "authorization": basicAuth
//      },
//      body: inputMap,
    );

    rSudahverfiPribadi = DaftarAktivitasResponse.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {
      List<DaftarAktivitas> data = rSudahverfiPribadi.data!;
      return data;
    } else {
      return null;
    }
  }

  DaftarAktivitasResponse rverfi = new DaftarAktivitasResponse();
  Future<List<DaftarAktivitas>?> getAllActivityVer(String tokenverfi, String idPns) async {
    //Map<String, dynamic> inputMap = {'DEMO-API-KEY': '$key'};
    final response = await http.get(Uri.parse(ApiService.urlUtama+"verifikasi/tampilpegawaidetail?token="+tokenverfi+"&id_pns="+idPns),
//      headers: {
//        "Accept": "application/json",
//        "Content-Type": "application/x-www-form-urlencoded",
//        "authorization": basicAuth
//      },
//      body: inputMap,
    );

    rverfi = DaftarAktivitasResponse.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {
      List<DaftarAktivitas> dat = rverfi.data!;
      return dat;
    } else {
      return null;
    }
  }
//  static String username = 'user';
//  static String password = 'demo';
//  final String key = 'r4h4514';
//  final String basicAuth =
//      'Basic ' + base64Encode(utf8.encode('$username:$password'));
  DaftarAktivitasResponse aktivitasBelum = new DaftarAktivitasResponse();
  Future<List<DaftarAktivitas>?> getAllAktivitas(String tokenListAktivitas) async {
    //Map<String, dynamic> inputMap = {'DEMO-API-KEY': '$key'};
    //getPrefFromApi();
    final response = await http.get(Uri.parse(ApiService.urlUtama+"rekam/tampildaftar?token="+tokenListAktivitas)//      headers: {
//        "Accept": "application/json",
//        "Content-Type": "application/x-www-form-urlencoded",
//        "authorization": basicAuth
//      },
//      body: inputMap,
    );

    aktivitasBelum = DaftarAktivitasResponse.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {
      List<DaftarAktivitas> data = aktivitasBelum.data!;
      return data;
    } else {
      return null;
    }
  }

  DaftarAktivitasResponse aktivitasByID = new DaftarAktivitasResponse();
  Future<List<DaftarAktivitas>?> aktivitasById(String tokenByID, String idDataKinerja) async {
    //getPrefFromApi();
    Map<String, dynamic> inputMap = {
//      'DEMO-API-KEY': '$key',
      //'numb': aktivitas.numb,
      'id_data_kinerja': idDataKinerja,
    };
    final response = await http.post(Uri.parse(ApiService.urlUtama+"rekam/tampildetail?token="+tokenByID),
//      headers: {
//        "Accept": "application/json",
//        "Content-Type": "application/x-www-form-urlencoded",
//        "authorization": basicAuth
//      },
      body: inputMap,
    );

    aktivitasByID = DaftarAktivitasResponse.fromJson(json.decode(response.body));
    if (aktivitasByID.status == "true") {
      List<DaftarAktivitas> data = aktivitasByID.data!;
      return data;
    } else {
      return null;
    }
  }

  DaftarAktivitasResponse aktivitasCreate = new DaftarAktivitasResponse();
  Future<String> create(DaftarAktivitas aktivitas, String tokenCreate) async {
    //getPrefFromApi();
    Map<String, dynamic> inputMap = {
      //'DEMO-API-KEY': '$key',
      'idsubpekerjaan': aktivitas.idSubPekerjaan,
      //'id_data_kinerja': aktivitas.idDataKinerja,
      'tgl_kinerja': aktivitas.tglKinerja,
      //'nama_pekerjaan': aktivitas.namaPekerjaan,
      //'waktu_mengerjakan': aktivitas.waktuMengerjakan,
      //'standar_waktu': aktivitas.standarWaktu,
      'jam_mulai': aktivitas.jamMulai,
      'jam_selesai': aktivitas.jamSelesai,
      'uraian_pekerjaan': aktivitas.uraianPekerjaan,
      //'waktu_diakui': aktivitas.waktuDiakui,
      //'status': aktivitas.status
    };

    final response = await http.post(Uri.parse(ApiService.urlUtama+"rekam/simpanpekerjaan?token="+tokenCreate),
      //headers: {"content-type": "application/json"},
//      headers: {
//        "Accept": "application/json",
//        "Content-Type": "application/x-www-form-urlencoded",
//        "authorization": basicAuth
//      },
      body: inputMap
    );

    aktivitasCreate = DaftarAktivitasResponse.fromJson(json.decode(response.body));
    //if (response.statusCode == 200) {
    if (aktivitasCreate.status == "true") {
      return aktivitasCreate.status!;
    } else {
      return aktivitasCreate.info!;
    }
  }

  DaftarAktivitasResponse aktivitasUpdate = new DaftarAktivitasResponse();
  Future<String> update(DaftarAktivitas aktivitas, String tokenUpdate) async {
    //getPrefFromApi();
    Map<String, dynamic> inputMap = {
//      'DEMO-API-KEY': '$key',
      //'numb': aktivitas.numb,
      'idsubpekerjaan': aktivitas.idSubPekerjaan,
      'tgl_kinerja': aktivitas.tglKinerja,
      'uraian_pekerjaan': aktivitas.uraianPekerjaan,
      'jam_mulai': aktivitas.jamMulai,
      'jam_selesai': aktivitas.jamSelesai,
    };
    final response = await http.post(Uri.parse(ApiService.urlUtama+"rekam/update?token="+tokenUpdate+"&id_data_kinerja="+aktivitas.idDataKinerja!),
//      headers: {
//        "Accept": "application/json",
//        "Content-Type": "application/x-www-form-urlencoded",
//        "authorization": basicAuth
//      },
      body: inputMap,
    );

    aktivitasUpdate = DaftarAktivitasResponse.fromJson(json.decode(response.body));
    if (aktivitasUpdate.status == "true") {
      return aktivitasUpdate.status!;
    } else {
      return aktivitasUpdate.info!;
    }
  }

  Future<bool> delete(String idDataKinerja, String tokenDelete) async {
    // getPrefFromApi();
    // Map<String, dynamic> inputMap = {
    //   //'DEMO-API-KEY': '$key',
    //   'id_data_kinerja': idDataKinerja
    // };
    final response = await http.get(Uri.parse(ApiService.urlUtama+"rekam/hapuspekerjaan?token="+tokenDelete+"&id_data_kinerja="+idDataKinerja),
     // headers: {
     //   "Accept": "application/json",
     //   "Content-Type": "application/x-www-form-urlencoded",
     // },
     // body: inputMap,
    );

    aktivitasBelum = DaftarAktivitasResponse.fromJson(json.decode(response.body));
    //if (response.statusCode == 200) {
    if (aktivitasBelum.status == "true") {
      return true;
    } else {
      return false;
    }
  }

  DaftarAktivitasResponse rfi = new DaftarAktivitasResponse();
  setujuiAktivitas(String token, String idDataKinerja, String waktuDiakui, String tglKinerja)async{
    final response = await http.get(Uri.parse(ApiService.urlUtama+"verifikasi/verifikasisatu?token="+token+"&id_kinerja="+idDataKinerja+"&status_verifikasi=Diterima&waktu_diakui="+waktuDiakui+"&tgl_kinerja="+tglKinerja),);
    if (response.statusCode == 200) {
      List<DaftarAktivitas> data = rfi.data!;
      return data;
    } else {
      return null;
    }
  }

  DaftarAktivitasResponse rfiKembalikan = new DaftarAktivitasResponse();
  kembalikanAktivitas(String token, String idDataKinerja, String statusVerifikasi, String keterangan)async{
    Map<String, dynamic> inputMap = {
      //'DEMO-API-KEY': '$key',
      'token': token,
      'id_kinerja': idDataKinerja,
      'status_verifikasi': statusVerifikasi,
      'keterangan': keterangan,
    };
    final response = await http.post(Uri.parse(
      ApiService.urlUtama+"verifikasi/tolakkembalikan"),
//      headers: {
//        "Accept": "application/json",
//        "Content-Type": "application/x-www-form-urlencoded",
//        "authorization": basicAuth
//      },
      body: inputMap,
    );
    rfiKembalikan = DaftarAktivitasResponse.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {
      List<DaftarAktivitas> data = rfiKembalikan.data!;
      return data;
    } else {
      return null;
    }
  }

  DaftarAktivitasResponse rfiTolak = new DaftarAktivitasResponse();
  tolakAktivitas(String token, String idDataKinerja, String statusVerifikasi, String keterangan)async{
    Map<String, dynamic> inputMap = {
      //'DEMO-API-KEY': '$key',
      'token': token,
      'id_kinerja': idDataKinerja,
      'status_verifikasi': statusVerifikasi,
      'keterangan': keterangan,
    };
    final response = await http.post(Uri.parse(ApiService.urlUtama+"verifikasi/tolakkembalikan"),
//      headers: {
//        "Accept": "application/json",
//        "Content-Type": "application/x-www-form-urlencoded",
//        "authorization": basicAuth
//      },
      body: inputMap,
    );
    rfiTolak = DaftarAktivitasResponse.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {
      List<DaftarAktivitas> data = rfiTolak.data!;
      return data;
    } else {
      return null;
    }
  }


  laporanInividu(String tokenByID, String bulanGet, String tahunGet) async {
    final response = await http.get(Uri.parse(ApiService.urlUtama+"laporan/individu_bulanan_new?bulan="+bulanGet+"&tahun="+tahunGet+"&token="+tokenByID));
    var dataObjJson = jsonDecode(response.body)['data'] as List;
//    List dataObjs = dataObjJson.map((e) => DaftarAktivitas.fromJson(e)).toList();
    if (response.statusCode == 200) {
      //jsonku = dataObjs;
      return dataObjJson;
    } else{
      return null;
    }
  }

  laporanInividuTahunan(String tokenByID, String tahunGet) async {
    final response = await http.get(Uri.parse(ApiService.urlUtama+"laporan/individu_tahunan?tahun="+tahunGet+"&token="+tokenByID));
    var dataObjJsonTahunan = jsonDecode(response.body)['data'] as List;
//    List dataObjs = dataObjJson.map((e) => DaftarAktivitas.fromJson(e)).toList();
    if (response.statusCode == 200) {
      //jsonku = dataObjs;
      return dataObjJsonTahunan;
    } else{
      return null;
    }
  }

  // getDataPresensiBlnLalu(String tokenByID,String bulan) async {
  //   final response = await http.get(Uri.parse(ApiService.urlUtama+"Login/data_diri?token="+tokenByID));
  //   if (response.statusCode == 200) {
  //     var bulanLaluData;
  //     if(bulan=="0"){
  //       bulanLaluData = jsonDecode(response.body)['berjalan'] as List<dynamic>;
  //     }else if(bulan=="1"){
  //       bulanLaluData = jsonDecode(response.body)['bulan_lalu'] as List<dynamic>;
  //     }else if(bulan=="2"){
  //       bulanLaluData = jsonDecode(response.body)['bulan_lusa'] as List<dynamic>;
  //     }
  //     // var presensiBulanLalu = jsonDecode(response.body)['bulan_lalu'] as List;
  //     return bulanLaluData;
  //   } else{
  //     return null;
  //   }
  // }

  getAbsenBerjalan(String tokenByID) async {
    final response = await http.get(Uri.parse(ApiService.urlUtama+"Login/absen_berjalan?token="+tokenByID));
    if (response.statusCode == 200) {
      var bulanLaluData = jsonDecode(response.body)['berjalan'] as List<dynamic>;
      return bulanLaluData;
    } else{
      return null;
    }
  }
  getAbsenLalu(String tokenByID) async {
    final response = await http.get(Uri.parse(ApiService.urlUtama+"Login/absen_lalu?token="+tokenByID));
    if (response.statusCode == 200) {
      var bulanLaluData = jsonDecode(response.body)['bulan_lalu'] as List<dynamic>;
      return bulanLaluData;
    } else{
      return null;
    }
  }
  getAbsenLusa(String tokenByID) async {
    final response = await http.get(Uri.parse(ApiService.urlUtama+"Login/absen_lusa?token="+tokenByID));
    if (response.statusCode == 200) {
      var bulanLaluData = jsonDecode(response.body)['bulan_lusa'] as List<dynamic>;
      return bulanLaluData;
    } else{
      return null;
    }
  }

  getDataPaguCapaianLalu(String tokenByID) async {
    final response = await http.get(Uri.parse(ApiService.urlUtama+"Login/data_pagu?token="+tokenByID));
    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      return decodedData['bulan_lalu'][0];
    }
  }
  getDataPaguCapaianLusa(String tokenByID) async {
    final response = await http.get(Uri.parse(ApiService.urlUtama+"Login/data_pagu?token="+tokenByID));
    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      return decodedData['bulan_lusa'][0];
    }
  }

  // getDataTamsil(String tokenByID,String bulan) async {
  //   final response = await http.get(Uri.parse(ApiService.urlUtama+"Login/data_pagu?token="+tokenByID));
  //   if (response.statusCode == 200) {
  //     var decodedData = jsonDecode(response.body);
  //
  //     if (bulan == "0") {
  //       return decodedData['berjalan'][0];
  //     } else if (bulan == "1") {
  //       return decodedData['bulan_lalu'][0];
  //     } else if (bulan == "2") {
  //       return decodedData['bulan_lusa'][0];
  //     }
  //   }
  // }


  kirimStatusLogout(String idPns) async {
    Map<String, dynamic> inputMap = {
      'id_pns': idPns,
    };
    final response = await http.post(Uri.parse(ApiService.urlUtama+"Login/proses_logout"),
      body: inputMap,
    );
    var objLogout = jsonDecode(response.body)['data'] as List;
//    List dataObjs = dataObjJson.map((e) => DaftarAktivitas.fromJson(e)).toList();
    if (response.statusCode == 200) {
      //jsonku = dataObjs;
      return objLogout;
    } else{
      return null;
    }
  }

}