import 'dart:convert';

//import 'package:ekinerja2020/model/daftar_pekerjaan.dart';
import 'package:flutter/material.dart';
import 'package:ekinerja2020/model/daftar_aktivitas.dart';
import 'package:ekinerja2020/service/ApiService.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:ekinerja2020/model/localization_dropdown_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';  //for date format
import 'package:intl/date_symbol_data_local.dart';  //for date locale
import 'package:flutter/cupertino.dart';

import 'customTimePicker.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormScreen extends StatefulWidget {
  List<DaftarAktivitas> daftarSudahAda;
  DaftarAktivitas daftaraktivitas;
  FormScreen({this.daftarSudahAda, this.daftaraktivitas});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  //DaftarPekerjaan repo = DaftarPekerjaan();
  var dataJson,_daftarPekerjaan,_daftarSubPekerjaan;
  //List<DaftarPekerjaan> semuaPekerjaan;
  String _date = "Belum diset";
  String _timeMulai = "Belum diset";
  String _timeSelesai = "Belum diset";

  String tokenlistaktivitas,tanggalAkSebelum,jamMulaiSebelum;
  TimeOfDay timeLimit = TimeOfDay(hour: 15, minute: 30);
  TimeOfDay startTime = TimeOfDay(hour: 7, minute: 30);
  TimeOfDay endTime = TimeOfDay(hour: 23, minute: 59);
  //List<String> _states = ["Pilih Pekerjaan"];
  //List<String> _lgas = ["Pilih waktu"];
  //List<String> _subPekerjaan;
  //String _selectedState = "Choose a state";
  //String _selectedLGA = "Choose ..";
  String pekerjaanDefaultEdit;
  List statesList = List();
  List provincesList = List();
  List tempList = List();
  String _state;
  String getIdSubPekerjaanValue;
  ApiService api = new ApiService();
//  ApiService_pekerjaan api_pekerjaan = new ApiService_pekerjaan();
  //TextEditingController ctrlTanggalAktivitas = new TextEditingController();
  TextEditingController ctrlIdSubPekerjaan = new TextEditingController();
  TextEditingController ctrlUraianPekerjaan = new TextEditingController();

  
  //List<DaftarPekerjaan> _list = [];
  //DaftarPekerjaan objJson;
//  List<Map> getAll() => _list;
//  List _list = [];
  //List<String> _list =[""] ;
  var loading = false;
//  Future<Null> _fetchData()async{
//    setState(() {
//      loading = true;
//    });
//    final response = await http.get("http://103.86.103.66/siltapkin/2020/index.php/api/master_data/pekerjaan?token=MTk3MDA4MjgxOTk3MDMxMDEy");
//    if(response.statusCode == 200){
//      dataJson = jsonDecode(response.body);
//      _daftarPekerjaan = dataJson['data'];
//      _daftarSubPekerjaan = _daftarPekerjaan["subpekerjaan"];
//      setState(() {
//        if(dataJson == null){
//          return Center(
//            child: Text("Data tidak ditemuakan"),
//          );
//        }else{
//          for(Map i in _daftarPekerjaan){
//            _states.add(DaftarPekerjaan.fromJson(_daftarPekerjaan[i]["namapekerjaan"]).toString());
//            for(Map z in _daftarSubPekerjaan){
//              _subPekerjaan.add(DaftarPekerjaan.fromJson(_daftarSubPekerjaan[z]["standarwaktu"]).toString());
//            }
//          }
//        }
//        loading = false;
//      });
//    }
//  }
  Future<String> _populateDropdown() async {
    await getPref();
    setState(() {
      loading = true;
    });
    final getPlaces = await http.get(api.baseDaftarPekerjaan+tokenlistaktivitas);
    if(getPlaces.statusCode == 200){
      final jsonResponse = json.decode(getPlaces.body);

      Localization places = new Localization.fromJson(jsonResponse);

      setState(() {
        statesList = places.pekerjaan;
        provincesList = places.subpekerjaan;
        if (this.widget.daftaraktivitas != null) {
          tempList = provincesList;
        }
        loading = false;
      });
    }

  }
  
  @override
  void initState() {
    //_states = List.from(_states)..addAll(api_pekerjaan.getAllPekerjaan());
    //DaftarPekerjaan pekerjaan = semuaPekerjaan[]
    //List<String> getPekerjaan() => _list.map((map) => DaftarPekerjaan.fromJson(map)).map(item) =>ite
    //_fetchData();
    getPref();
    _populateDropdown();
    //Jika ada lemparan dari second_fragment (Edit) maka dilakukan berikut
    if (this.widget.daftaraktivitas != null) { //ngecek ada isinya nggak klo ada isinya berarti edit
      _date = this.widget.daftaraktivitas.tglKinerja;
      _timeMulai = this.widget.daftaraktivitas.jamMulai;
      _timeSelesai = this.widget.daftaraktivitas.jamSelesai;
      pekerjaanDefaultEdit = this.widget.daftaraktivitas.namaPekerjaan;
      _state = this.widget.daftaraktivitas.idPekerjaan;
      getIdSubPekerjaanValue = this.widget.daftaraktivitas.idSubPekerjaan;
      //ctrlTanggalAktivitas.text = this.widget.daftaraktivitas.tglKinerja;
      ctrlUraianPekerjaan.text = this.widget.daftaraktivitas.uraianPekerjaan;
      //ctrlIdSubPekerjaan.text = this.widget.daftaraktivitas.idSubPekerjaan;
    }
    super.initState();
  }

  Future<Null> fetchAktivitasSebelumnya()async{
    setState(() {
      loading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      tokenlistaktivitas = preferences.getString("tokenlogin");

    });
    final response = await http.get(api.getAllKontak(tokenlistaktivitas));
    if(response.statusCode == 200){
      var tagObjsJson = jsonDecode(response.body)['data'] as List;
      List<DaftarAktivitas> tagObjs = tagObjsJson.map((tagJson) => DaftarAktivitas.fromJson(tagJson)).toList();

      print(tagObjs);

//      final data = jsonDecode(response.body);
//      //final _daftarPekerjaan = data['data'];
//      setState(() {
//        tanggalAkSebelum = data["data"]["tgl_kinerja"];
//        jamMulaiSebelum = data["data"]["jam_mulai"];
//      });
    }else{
      Text("error bro");
    }
  }

  Future<Null> getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      tokenlistaktivitas = preferences.getString("tokenlogin");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.daftaraktivitas == null ? "Form Tambah" : "Form Update",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child:loading ? Center(child: CircularProgressIndicator())
            : Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(15.0),
            children: <Widget>[
              Column(
                children: <Widget>[
                  AbsorbPointer(
                    absorbing: widget.daftaraktivitas == null ? false : true,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          elevation: 4.0,
                          onPressed: () {
                            DatePicker.showDatePicker(context,
                                theme: DatePickerTheme(
                                  containerHeight: 210.0,
                                ),
                                showTitleActions: true,
                                minTime: DateTime(2019, 1, 1),
                                maxTime: DateTime(2025, 12, 31), onConfirm: (date) {
                                  print('confirm $date');
                                  _date = '${date.year}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}';
                                  setState(() {});
                                }, currentTime: DateTime.now(), locale: LocaleType.en);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 50.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Tanggal aktivitas",style: Theme.of(context).textTheme.caption),
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.date_range,
                                                size: 18.0,
                                                color: widget.daftaraktivitas == null ? Colors.teal : Colors.black12,
                                              ),
                                              Text(
                                                " $_date",
                                                style: TextStyle(
                                                    color: widget.daftaraktivitas == null ? Colors.teal : Colors.black12,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),

                                  ],
                                ),
                                Text(widget.daftaraktivitas == null ? "  Ubah" : "",
                                  style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          ),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 18.0, right: 18.0),
                    child: new DropdownButton<String>(
                      isExpanded: true,
                      icon: const Icon(Icons.border_color),
                      items: statesList.map((item) {
                        return new DropdownMenuItem<String>(
                          child: new Text(item.namaPekerjaan),// Text(item.standarWaktu),
                          value: item.idPekerjaan.toString(),
                        );
                      }).toList(),
                      onChanged: (newVal) {//newVal adalah idPekerjaan yang dipilih (nilai dari value)
                        setState(() {
                          getIdSubPekerjaanValue = null;
                          _state = newVal;
                          tempList = provincesList
                              .where((x) =>
                          x.idPekerjaan.toString() == (_state.toString()))
                              .toList();
                        });

                        // print(testingList.toString());
                      },
//                      validator: (newVal) {
//                        if (newVal?.isEmpty ?? true) {
//                          return 'Aktivitas Diperlukan';
//                        }
//                        return null;
//                      },
                      value: _state,
                      hint: Text('Pilih Aktivitas'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 18.0, right: 18.0),
                    child: new DropdownButton<String>(
                      isExpanded: true,
                      icon: const Icon(Icons.access_time),
                      items: tempList.map((item) {
                        return new DropdownMenuItem<String>(
                          child: new Text(item.standarWaktu),
                          value: item.idSubPekerjaan.toString(),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          getIdSubPekerjaanValue = newVal;
                        });
                      },
//                      validator: (newVal) {
//                        if (newVal?.isEmpty ?? true) {
//                          return 'Standar Waktu Diperlukan';
//                        }
//                        return null;
//                      },
                      value: getIdSubPekerjaanValue,
                      hint: Text('Pilih Standar Waktu'),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    elevation: 4.0,
                    onPressed: () {
                      DatePicker.showTimePicker(context,
                          theme: DatePickerTheme(containerHeight: 210.0,),
                          showTitleActions: true, onConfirm: (time) {
                            print('confirm $time');
                            String jam = DateFormat('HH').format(time);
                            String menit = DateFormat('mm').format(time);
                            _timeMulai = (time.hour >= 0) ? '${jam}:${menit}'.padLeft(2,'0'):'${jam}:${menit}';//'${time.hour}:${time.minute}'.padLeft(2,"0");
                            setState(() {});},
                          currentTime: DateTime.now(),
                          showSecondsColumn: false,
                          locale: LocaleType.id);
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,//membuat isi kolom rata kiri
                                children: <Widget>[
                                  Text("Jam mulai",style: Theme.of(context).textTheme.caption),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.access_time,
                                          size: 18.0,
                                          color: Colors.teal,
                                        ),
                                        Text(
                                          " $_timeMulai",
                                          style: TextStyle(
                                              color: Colors.teal,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),

                            ],
                          ),
                          Text(
                            "  Ubah",
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                        ],
                      ),
                    ),
                    color: Colors.white,
                  ),
                  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                  SizedBox(
                    height: 3.0,
                  ),
                  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                  RaisedButton( //inputan jam selesai
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    elevation: 4.0,
                    onPressed: (){
                      DatePicker.showTimePicker(context,
                          theme: DatePickerTheme(containerHeight: 210.0,),
                          showTitleActions: true, onConfirm: (time) {
                            print('confirm $time');
                            String jam = DateFormat('HH').format(time);
                            String menit = DateFormat('mm').format(time);
                            _timeSelesai = (time.hour >= 0) ? '${jam}:${menit}'.padLeft(2,'0'):'${jam}:${menit}';//'${time.hour}:${time.minute}'.padLeft(2,"0");
                            setState(() {});},
                          currentTime: DateTime.now(),
                          showSecondsColumn: false,
                          locale: LocaleType.id);
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,//membuat isi kolom rata kiri
                                children: <Widget>[
                                  Text("Jam Selesai",style: Theme.of(context).textTheme.caption),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.access_time,
                                          size: 18.0,
                                          color: Colors.teal,
                                        ),
                                        Text(
                                          " $_timeSelesai",
                                          style: TextStyle(
                                              color: Colors.teal,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),

                            ],
                          ),
                          Text(
                            "  Ubah",
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                        ],
                      ),
                    ),
                    color: Colors.white,

//                    onPressed: () async {
//                        showModalBottomSheet<dynamic>(
//                            shape: RoundedRectangleBorder(
//                              borderRadius: BorderRadius.circular(20.0),
//                            ),
//                            context: context,
//                            builder: (BuildContext builder) {
//                              if(_timeMulai=="Belum diset"){
//                                //_timeMulai=="0:2";
//                                return Wrap(
//                                    children: <Widget>[
//                                      Stack(
//                                          children: [
//                                            Container(
//                                              width: double.infinity,
//                                              height: 36.0,
//                                              child: Center(
//                                                  child: Text("Jam mulai belum diset !",style: TextStyle(shadows: [
//                                                    Shadow(
//                                                      blurRadius: 10.0,
//                                                      color: Colors.blue,
//                                                      offset: Offset(5.0, 5.0),
//                                                    ),
//                                                  ],fontSize: 20.0,fontWeight: FontWeight.bold,color: Colors.red,),) // Your desired title
//                                              ),
//                                            ),
//                                            Positioned(
//                                                right: 0.0,
//                                                top: 0.0,
//                                                child: IconButton(
//                                                    icon: Icon(Icons.close), // Your desired icon
//                                                    onPressed: () {
//                                                      Navigator.of(context).pop();
//                                                    }
//                                                )
//                                            )
//                                          ]
//                                      ),
//                                      GestureDetector(
//                                        onTap: () => Navigator.of(context).pop(),
//                                        // closing showModalBottomSheet
//                                        child: Container(
//                                          height: MediaQuery.of(context).copyWith().size.height * 0.30,
//                                          child: Center(
//                                            child: Text("Sebelum mengisi jam selesai, silahkan isikan jam mulai terlebih dahulu !",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,), textAlign: TextAlign.center),
//                                          ),
//                                        ),
//                                      )
//                                    ]
//                                );
//                              }else {
//                                return Wrap(
//                                    children: <Widget>[
//                                      Stack(
//                                          children: [
//                                            Container(
//                                              width: double.infinity,
//                                              height: 36.0,
//                                              child: Center(
//                                                  child: Text(
//                                                      "Pilih Waktu") // Your desired title
//                                              ),
//                                            ),
//                                            Positioned(
//                                                right: 0.0,
//                                                top: 0.0,
//                                                child: IconButton(
//                                                    icon: Icon(Icons
//                                                        .check_circle_outline),
//                                                    // Your desired icon
//                                                    onPressed: () {
//                                                      Navigator.of(context).pop();
//                                                    }
//                                                )
//                                            )
//                                          ]
//                                      ),
//                                      GestureDetector(
//                                        onTap: () => Navigator.of(context).pop(),
//                                        // closing showModalBottomSheet
//                                        child: Container(
//                                          height: MediaQuery
//                                              .of(context)
//                                              .copyWith()
//                                              .size
//                                              .height * 0.30,
//                                          child: CustomCupertinoTimerPicker(
//                                            mode: CupertinoTimerPickerMode.hm,
//                                            minuteInterval: 1,
//                                            initialTimerDuration: Duration(
//                                                hours: timeLimit.hour,
//                                                minutes: timeLimit.minute),
//                                            startRestriction: TimeOfDay(hour:int.parse(_timeMulai.split(":")[0]),minute: int.parse(_timeMulai.split(":")[1])),
//                                            endRestriction: endTime,
//                                            onTimerDurationChanged: (
//                                                Duration changedtimer) {
//                                              print(changedtimer);
//                                              int minute = changedtimer.inMinutes % 60;
//                                              int hour = changedtimer.inMinutes ~/  60;
//                                              setState(() {
//                                                if (_timeMulai == "00:02") {
//                                                  AlertDialog(
//                                                    title: new Text(
//                                                        "Jam Mulai belum diset"),
//                                                    content: new Text(
//                                                        "Silahkan isikan jam mulai sebelum mengisi jam selesai"),
//                                                    actions: <Widget>[
//                                                      // usually buttons at the bottom of the dialog
//                                                      new FlatButton(
//                                                        child: new Text("Tutup"),
//                                                        onPressed: () {
//                                                          Navigator.of(context)
//                                                              .pop();
//                                                        },
//                                                      ),
//                                                    ],
//                                                  );
//                                                } else {
//                                                  _timeSelesai =
//                                                      hour.toString() + ":" +
//                                                          minute.toString();
//                                                }
//                                                //timeLimit = TimeOfDay(hour: hour, minute: minute);
//                                              });
//                                            },
//                                          ),
//                                        ),
//                                      )
//                                    ]
//                                );
//                              }
//
//                            }
//                        );
//
//                    },
//                    {
//                      DatePicker.showTimePicker(context,
//                          theme: DatePickerTheme(containerHeight: 210.0,),
//                          showTitleActions: true, onConfirm: (time) {
//                            print('confirm $time');
//                            String jam = DateFormat('HH').format(time);
//                            String menit = DateFormat('mm').format(time);
//                            _timeSelesai = (time.hour >= 0) ? '${jam}:${menit}'.padLeft(2,'0'):'${jam}:${menit}';//'${time.hour}:${time.minute}'.padLeft(2,"0");
//                            setState(() {});},
//                          currentTime: DateTime.now(),
//                          showSecondsColumn: false,
//                          locale: LocaleType.id);
//                      setState(() {});
//                    },
//                    child: Container(
//                      alignment: Alignment.center,
//                      height: 50.0,
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: <Widget>[
//                          Row(
//                            children: <Widget>[
//                              Column(
//                                mainAxisAlignment: MainAxisAlignment.center,
//                                crossAxisAlignment: CrossAxisAlignment.start,//membuat isi kolom rata kiri
//                                children: <Widget>[
//                                  Text("Jam Selesai",style: Theme.of(context).textTheme.caption),
//                                  Container(
//                                    child: Row(
//                                      children: <Widget>[
//                                        Icon(
//                                          Icons.access_time,
//                                          size: 18.0,
//                                          color: Colors.teal,
//                                        ),
//                                        Text(
//                                          " $_timeSelesai",
//                                          style: TextStyle(
//                                              color: Colors.teal,
//                                              fontWeight: FontWeight.bold,
//                                              fontSize: 18.0),
//                                        ),
//                                      ],
//                                    ),
//                                  )
//                                ],
//                              ),
//
//                            ],
//                          ),
//                          Text(
//                            "  Ubah",
//                            style: TextStyle(
//                                color: Colors.teal,
//                                fontWeight: FontWeight.bold,
//                                fontSize: 18.0),
//                          ),
//                        ],
//                      ),
//                    ),
//                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 18.0, right: 18.0),
                      child: TextFormField(
                        controller: ctrlUraianPekerjaan,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Uraian Pekerjaan',
                          hintText: 'Uraian Pekerjaan',
                        ),
                      )
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 18.0, right: 18.0),
                      child: Row(
                        children: <Widget>[
                          Spacer(),
                          RaisedButton(
                            onPressed: () {
                              if (validateInput()) {
                                DaftarAktivitas dataIn = new DaftarAktivitas(
                                    idDataKinerja: this.widget.daftaraktivitas != null
                                        ? this.widget.daftaraktivitas.idDataKinerja
                                        : "",
                                    tglKinerja: _date,
                                    idSubPekerjaan: getIdSubPekerjaanValue,
                                    jamMulai: _timeMulai,
                                    jamSelesai: _timeSelesai,
                                    uraianPekerjaan: ctrlUraianPekerjaan.text);
//                                    if(compareJamTanggal(dataIn, dataIn.tglKinerja, dataIn.jamSelesai)==true){
//                                      if(_date == "datedariserver" && _timeMulai<="timedariserver"){
//
//                                      }
                                    DateFormat dateFormat = new DateFormat.Hm();
                                    DateTime mulai = dateFormat.parse(_timeMulai);
                                    DateTime selesai = dateFormat.parse(_timeSelesai);
                                    if(mulai.isAfter(selesai)) {
                                      // tolak
                                      _scaffoldState.currentState
                                          .showSnackBar(SnackBar(
                                        content: Text("Jam selesai harus lebih dari jam mulai!"),
                                      ));

                                    }else{
                                      if (this.widget.daftaraktivitas != null) {
                                        api.update(dataIn, tokenlistaktivitas)
                                            .then((result) {
                                          if (result=="true") {
                                            Navigator.pop(
                                                _scaffoldState.currentState
                                                    .context, true);
                                          } else {
                                            _scaffoldState.currentState
                                                .showSnackBar(SnackBar(
                                              content: Text(result),
                                            ));
                                          }
                                        });
                                      } else {
                                        api.create(dataIn, tokenlistaktivitas)
                                            .then((result) {
                                          if (result=="true") {
                                            Navigator.pop(
                                                _scaffoldState.currentState
                                                    .context, true);
                                          } else {
                                            _scaffoldState.currentState
                                                .showSnackBar(SnackBar(
                                              content: Text(result),
                                            ));
                                            //                                            _scaffoldState.currentState
                                            //                                                .showSnackBar(SnackBar(
                                            //                                              content: Text(
                                            //                                                  "Simpan data gagal"),
                                            //                                            ));
                                          }
                                        });
                                      }
                                    }


//                                    }else{
//                                      _scaffoldState.currentState
//                                          .showSnackBar(SnackBar(
//                                        content: Text(
//                                            "Simpan data gagal"),
//                                      ));
//                                    }




                              } else {
                                _scaffoldState.currentState.showSnackBar(SnackBar(
                                  content: Text("Data belum lengkap"),
                                ));
                              }
                            },
                            child: Text(
                              widget.daftaraktivitas == null ? "Simpan" : "Ubah",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.orange[400],
                          ),
                        ],
                      )
                  )
                ],
              ),
            ],
          ),
        )
      )
    );
  }

//  void _onSelectedState(String value) {
//    setState(() {
//      _selectedLGA = "Choose ..";
//      _lgas = ["Choose .."];
//      _selectedState = value;
//      _lgas = List.from(_lgas)..addAll(getLocalByState(value));
//    });
//  }
//
//  getLocalByState(String nampek) => dataJson
//      .map((map) => DaftarPekerjaan.fromJson(map))
//      .where((item) => item.namasubpekerjaan == nampek)
//      .map((item) => item.standarwaktu)
//      .expand((i) => i)
//      .toList();
//
//  void _onSelectedLGA(String value) {
//    setState(() => _selectedLGA = value);
//  }

  bool validateInput() {
    if (_date == "Belum diset" ||
        ctrlUraianPekerjaan.text == "" ||
        _timeMulai == ""||
        _timeSelesai == "" ||
        getIdSubPekerjaanValue == null) {
      return false;
    } else {
      return true;
    }
  }

//  bool compareJamTanggal(DaftarAktivitas datInput, String tgl, String jamSelesai){
//    for(int i=0; i<=widget.daftarSudahAda.length; i++) {
//      TimeOfDay mulaiInput = TimeOfDay(hour: int.parse(datInput.jamMulai.split(":")[0]),minute: int.parse(datInput.jamMulai.split(":")[1]));
//      TimeOfDay selesaiSudahAda = TimeOfDay(hour: int.parse(widget.daftarSudahAda[i].jamSelesai.split(":")[0]),minute: int.parse(widget.daftarSudahAda[i].jamSelesai.split(":")[1]));
//      double selInput = mulaiInput.hour.toDouble() + (mulaiInput.minute.toDouble() / 60);
//      double selSudahada = selesaiSudahAda.hour.toDouble() +  (selesaiSudahAda.minute.toDouble() / 60);
//      if (datInput.tglKinerja == widget.daftarSudahAda[i].tglKinerja && selInput < selSudahada) {
//        AlertDialog(
//          title: new Text(
//              "Tidak diperbolehkan"),
//          content: new Text(
//              "Anda sudah input kegiatan pada tanggal dan jam tersebut"),
//          actions: <Widget>[
//            // usually buttons at the bottom of the dialog
//            new FlatButton(
//              child: new Text("Tutup"),
//              onPressed: () {
//                Navigator.of(context)
//                    .pop();
//              },
//            ),
//          ],
//        );
//        return false;
//      } else {
//        return true;
//      }
//    }
//  }

}