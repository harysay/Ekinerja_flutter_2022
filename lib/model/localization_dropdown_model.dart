
class Localization {
  final List <DataPekerjaan>? pekerjaan;
  final List <SubPekerjaan>? subpekerjaan;
  //DataPekerjaan nd = new DataPekerjaan();

  Localization({this.pekerjaan, this.subpekerjaan});

  factory Localization.fromJson(Map<String, dynamic> json) {
    return Localization(
      pekerjaan: parseStates(json),
      subpekerjaan: parseProvinces(json),
      
    );
  }

  
  static List<DataPekerjaan> parseStates(statesJson) {
    //DataPekerjaan dd = DataPekerjaan();
//     var ff = DataPekerjaan.fromJson(statesJson);
//    List tt = List.from(ff.subPekerjaan);//ff.subPekerjaan;
    var plist = statesJson['data'] as List;
    //var slist = statesJson['subpekerjaan'] as List;
    List<DataPekerjaan> statesList =
    plist.map((data) => DataPekerjaan.fromJson(data)).toList();
    return statesList;
  }

  static List<SubPekerjaan> parseProvinces(provincesJson) {
    var plist = provincesJson['subpekerjaan'] as List;
    List<SubPekerjaan> provincesList =
        plist.map((data) => SubPekerjaan.fromJson(data)).toList();
    return provincesList;
  }



}

class SubPekerjaan {
  final String? idSubPekerjaan;
  final String? namaSubPekerjaan;
  final String? standarWaktu;
  final String? idPekerjaan;


  SubPekerjaan({this.idSubPekerjaan, this.namaSubPekerjaan, this.standarWaktu,this.idPekerjaan});

  factory SubPekerjaan.fromJson(Map<String, dynamic> parsedJson){
//    var rr=parsedJson['subpekerjaan'];
//    List<String> ssf = new List<String>.from(rr);
    return SubPekerjaan(
        idSubPekerjaan: parsedJson['idsubpekerjaan'],
        idPekerjaan: parsedJson['idpekerjaan'],
        namaSubPekerjaan: parsedJson['namasubpekerjaan'],
        standarWaktu: parsedJson['standarwaktu']);
  }

//  factory SubPekerjaan.fromMap(Map<String, dynamic> data){
//    this.idSubPekerjaan = data['message'];
//    this.namaSubPekerjaan = data['timestamp'];
//    this.standarWaktu = data['university'];
//  }
//  Map<String, dynamic> toMap() => {
//    'idsubpekerjaan': this.idSubPekerjaan,
//    'namasubpekerjaan': this.namaSubPekerjaan,
//    'standarwaktu': this.standarWaktu
//  };

}

class DataPekerjaan {
  final String? idPekerjaan;
  final String? namaPekerjaan;
  //final List<String> subPekerjaan;

  DataPekerjaan({
    this.idPekerjaan,
    this.namaPekerjaan
    //this.subPekerjaan
  });

  factory DataPekerjaan.fromJson(Map<String, dynamic> parsedJson) {
   // var dd = parsedJson['data'];
    //List<String> sss = dd.cast<String>();
    return DataPekerjaan(
        idPekerjaan: parsedJson['idpekerjaan'],
        namaPekerjaan: parsedJson['namapekerjaan'],
        //subPekerjaan: sss
    );
  }

}