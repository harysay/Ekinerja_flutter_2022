import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ekinerja2020/model/daftar_aktivitas.dart';
import 'package:ekinerja2020/service/ApiService.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:ekinerja2020/model/localization_dropdown_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; //for date format
import 'package:flutter/cupertino.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormScreen extends StatefulWidget {
  DaftarAktivitas? aktivitas;
  final List<DaftarAktivitas>? daftarAllAktivitas;
  final String processType;
  FormScreen(
      {this.aktivitas, this.daftarAllAktivitas, required this.processType});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  var dataJson;
  String _date = "Belum diset";
  String _timeMulai = "Belum diset";
  String _timeSelesai = "Belum diset";

  String? tokenlistaktivitas, tanggalAkSebelum, jamMulaiSebelum;
  TimeOfDay timeLimit = TimeOfDay(hour: 15, minute: 30);
  // TimeOfDay startTime = TimeOfDay(hour: 7, minute: 30);
  // TimeOfDay endTime = TimeOfDay(hour: 23, minute: 59);
  String? pekerjaanDefaultEdit;
  // List statesList = List();
  List<Map<String, dynamic>> statesList = [];
  // List provincesList = List();
  List<Map<String, dynamic>> provincesList = [];
  // List tempList = List();
  List<Map<String, dynamic>> tempList = [];
  String? _state;
  String? getIdSubPekerjaanValue;
  ApiService api = new ApiService();
//  ApiService_pekerjaan api_pekerjaan = new ApiService_pekerjaan();
  //TextEditingController ctrlTanggalAktivitas = new TextEditingController();
  TextEditingController ctrlIdSubPekerjaan = new TextEditingController();
  TextEditingController ctrlUraianPekerjaan = new TextEditingController();

  var loading = false;
  Future<void> _populateDropdown() async {
    await getPref();
    setState(() {
      loading = true;
    });
    final getPlaces = await http.get(Uri.parse(ApiService.urlUtama +
        "master_data/pekerjaan_lepas?token=" +
        tokenlistaktivitas!));
    if (getPlaces.statusCode == 200) {
      // final jsonResponse = json.decode(getPlaces.body);
      Map<String, dynamic> jsonData = json.decode(getPlaces.body);
      // Localization places = new Localization.fromJson(jsonData);

      setState(() {
        statesList = List<Map<String, dynamic>>.from(jsonData['data']);
        provincesList =
            List<Map<String, dynamic>>.from(jsonData['subpekerjaan']);
        if (this.widget.aktivitas != null) {
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
    if (this.widget.aktivitas != null) {
      //ngecek ada isinya nggak klo ada isinya berarti edit
      _date = this.widget.aktivitas!.tglKinerja!;
      _timeMulai = this.widget.aktivitas!.jamMulai!;
      _timeSelesai = this.widget.aktivitas!.jamSelesai!;
      pekerjaanDefaultEdit = this.widget.aktivitas!.namaPekerjaan;
      _state = this.widget.aktivitas!.idPekerjaan;
      getIdSubPekerjaanValue = this.widget.aktivitas!.idSubPekerjaan;
      //ctrlTanggalAktivitas.text = this.widget.aktivitas.tglKinerja;
      ctrlUraianPekerjaan.text = this.widget.aktivitas!.uraianPekerjaan!;
      //ctrlIdSubPekerjaan.text = this.widget.aktivitas.idSubPekerjaan;
    }
    super.initState();
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
            widget.aktivitas == null ? "Form Tambah" : "Form Update",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
            child: loading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Container(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        AbsorbPointer(
                          absorbing: widget.aktivitas == null ? false : true,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              ElevatedButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            side: BorderSide(
                                                color: Colors.greenAccent)))),

                                onPressed: () {
                                  DatePicker.showDatePicker(context,
                                      // theme: DatePickerTheme(containerHeight: 210.0,),
                                      showTitleActions: true,
                                      minTime: DateTime(2019, 1, 1),
                                      maxTime: DateTime(2025, 12, 31),
                                      onConfirm: (date) {
                                    print('confirm $date');
                                    _date =
                                        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                                    setState(() {});
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.en);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 50.0,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text("Tanggal aktivitas",
                                                  style: TextStyle(
                                                      color: Colors.black87)),
                                              Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.date_range,
                                                      size: 18.0,
                                                      color: widget.aktivitas ==
                                                              null
                                                          ? Colors.white70
                                                          : Colors.black12,
                                                    ),
                                                    Text(
                                                      " $_date",
                                                      style: TextStyle(
                                                          color:
                                                              widget.aktivitas ==
                                                                      null
                                                                  ? Colors
                                                                      .white70
                                                                  : Colors
                                                                      .black12,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                        widget.aktivitas == null
                                            ? "  Ubah"
                                            : "",
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                    ],
                                  ),
                                ),
                                // color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 18.0, right: 18.0),
                          child: new DropdownButton<String>(
                            isExpanded: true,
                            icon: const Icon(Icons.border_color),
                            items: statesList.map((Map<String, dynamic> item) {
                              return new DropdownMenuItem<String>(
                                child: new Text(item['namapekerjaan']),
                                value: item['idpekerjaan'].toString(),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              //newVal adalah idPekerjaan yang dipilih (nilai dari value)
                              setState(() {
                                getIdSubPekerjaanValue = null;
                                _state = newVal;
                                tempList = provincesList
                                    .where((x) =>
                                        x['idpekerjaan'].toString() ==
                                        (_state.toString()))
                                    .toList();
                              });
                              // print(testingList.toString());
                            },
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
                                child: new Text(item['standarwaktu']),
                                value: item['idsubpekerjaan'].toString(),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                getIdSubPekerjaanValue = newVal;
                              });
                            },
                            value: getIdSubPekerjaanValue,
                            hint: Text('Pilih Standar Waktu'),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                        AbsorbPointer(
                          absorbing: widget.aktivitas == null ? false : true,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              ElevatedButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            side: BorderSide(
                                                color: Colors.greenAccent)))),
                                onPressed: () {
                                  DatePicker.showTimePicker(context,
                                      // theme: DatePickerTheme(containerHeight: 210.0,),
                                      showTitleActions: true,
                                      onConfirm: (time) {
                                    print('confirm $time');
                                    String jam = DateFormat('HH').format(time);
                                    String menit =
                                        DateFormat('mm').format(time);
                                    _timeMulai = (time.hour >= 0)
                                        ? '${jam}:${menit}'.padLeft(2, '0')
                                        : '${jam}:${menit}'; //'${time.hour}:${time.minute}'.padLeft(2,"0");
                                    setState(() {});
                                  },
                                      currentTime: DateTime.now(),
                                      showSecondsColumn: false,
                                      locale: LocaleType.id);
                                  setState(() {});
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 50.0,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start, //membuat isi kolom rata kiri
                                            children: <Widget>[
                                              Text("Jam mulai",
                                                  style: TextStyle(
                                                      color: Colors.black87)),
                                              Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.access_time,
                                                      size: 18.0,
                                                      color: widget.aktivitas ==
                                                          null
                                                          ? Colors.white70
                                                          : Colors.black12,
                                                    ),
                                                    Text(
                                                      " $_timeMulai",
                                                      style: TextStyle(
                                                          color: widget.aktivitas ==
                                                              null
                                                              ? Colors.white70
                                                              : Colors.black12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18.0),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      Text(widget.aktivitas == null ? "Ubah" : "Tidak diizinkan diubah",
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                    ],
                                  ),
                                ),
                                // color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                        SizedBox(
                          height: 3.0,
                        ),
                        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                        AbsorbPointer(
                          absorbing: widget.aktivitas == null ? false : true,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              ElevatedButton(
                                //inputan jam selesai
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            side: BorderSide(
                                                color: Colors.greenAccent)))),
                                onPressed: () {
                                  DatePicker.showTimePicker(context,
                                      // theme: DatePickerTheme(containerHeight: 210.0,),
                                      showTitleActions: true,
                                      onConfirm: (time) {
                                    print('confirm $time');
                                    String jam = DateFormat('HH').format(time);
                                    String menit =
                                        DateFormat('mm').format(time);
                                    _timeSelesai = (time.hour >= 0)
                                        ? '${jam}:${menit}'.padLeft(2, '0')
                                        : '${jam}:${menit}'; //'${time.hour}:${time.minute}'.padLeft(2,"0");
                                    setState(() {});
                                  },
                                      currentTime: DateTime.now(),
                                      showSecondsColumn: false,
                                      locale: LocaleType.id);
                                  setState(() {});
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 50.0,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start, //membuat isi kolom rata kiri
                                            children: <Widget>[
                                              Text("Jam Selesai",
                                                  style: TextStyle(
                                                      color: Colors.black87)),
                                              Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.access_time,
                                                      size: 18.0,
                                                      color: widget.aktivitas ==
                                                          null
                                                          ? Colors.white70
                                                          : Colors.black12,
                                                    ),
                                                    Text(
                                                      " $_timeSelesai",
                                                      style: TextStyle(
                                                          color: widget.aktivitas ==
                                                              null
                                                              ? Colors.white70
                                                              : Colors.black12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18.0),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      Text(widget.aktivitas == null ? "Ubah" : "Tidak diizinkan diubah",
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 18.0, right: 18.0),
                          child: TextField(
                            controller: ctrlUraianPekerjaan,
                            keyboardType: TextInputType.multiline,
                            maxLines:
                                null, // Set maxLines ke null untuk membuat textarea dengan ruang input yang lebih luas
                            decoration: InputDecoration(
                              labelText: 'Uraian Pekerjaan',
                              hintText: 'Uraian Pekerjaan',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 18.0, right: 18.0),
                            child: Row(
                              children: <Widget>[
                                Spacer(),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange[400],
                                  ),
                                  onPressed: () {
                                    if (validateInput()) {
                                      DaftarAktivitas dataIn =
                                          new DaftarAktivitas(
                                              idDataKinerja:
                                                  this.widget.aktivitas !=
                                                          null
                                                      ? this
                                                          .widget
                                                          .aktivitas!
                                                          .idDataKinerja
                                                      : "",
                                              tglKinerja: _date,
                                              idSubPekerjaan:
                                                  getIdSubPekerjaanValue,
                                              jamMulai: _timeMulai,
                                              jamSelesai: _timeSelesai,
                                              uraianPekerjaan:
                                                  ctrlUraianPekerjaan.text);
                                      //                                    if(compareJamTanggal(dataIn, dataIn.tglKinerja, dataIn.jamSelesai)==true){
                                      //                                      if(_date == "datedariserver" && _timeMulai<="timedariserver"){
                                      //
                                      //                                      }
                                      DateFormat dateFormat =
                                          new DateFormat.Hm();
                                      DateTime mulai =
                                          dateFormat.parse(_timeMulai);
                                      DateTime selesai =
                                          dateFormat.parse(_timeSelesai);
                                      if (mulai.isAfter(selesai)) {
                                        // tolak
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              "Jam selesai harus lebih dari jam mulai!"),
                                        ));
                                        // _scaffoldState.currentState
                                        //     .showSnackBar(SnackBar(
                                        //   content: Text("Jam selesai harus lebih dari jam mulai!"),
                                        // ));
                                      } else {
                                        _handleSave(dataIn, widget.processType);
                                        // if (this.widget.aktivitas != null) {
                                        //   _handleSave(dataIn, widget.processType);
                                        // } else {
                                        //   _handleSave(dataIn, widget.processType);
                                        // }
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text("Data belum lengkap"),
                                      ));
                                    }
                                  },
                                  child: Text(
                                    widget.aktivitas == null
                                        ? "Simpan"
                                        : "Ubah",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  // color: Colors.orange[400],
                                ),
                              ],
                            ))
                      ],
                    ),
                  ))));
  }

  bool validateInput() {
    if (_date == "Belum diset" ||
        ctrlUraianPekerjaan.text == "" ||
        _timeMulai == "" ||
        _timeSelesai == "" ||
        getIdSubPekerjaanValue == null) {
      return false;
    } else {
      return true;
    }
  }

  // Validasi rentang waktu untuk tanggal yang sama
  bool isTimeRangeValid(DateTime startTime, DateTime endTime,
      List<DaftarAktivitas>? daftarAllAktivitas) {
    for (var aktivitas in daftarAllAktivitas ?? []) {
      DateTime existingStartTime =
          DateTime.parse("${aktivitas.tglKinerja} ${aktivitas.jamMulai}");
      DateTime existingEndTime =
          DateTime.parse("${aktivitas.tglKinerja} ${aktivitas.jamSelesai}");
      if ((startTime.isAfter(existingStartTime) &&
              startTime.isBefore(existingEndTime)) ||
          (endTime.isAfter(existingStartTime) &&
              endTime.isBefore(existingEndTime)) ||
          (startTime.isBefore(existingStartTime) &&
              endTime.isAfter(existingEndTime)) ||
          (startTime.isAtSameMomentAs(existingStartTime) &&
              endTime.isAtSameMomentAs(existingEndTime))) {
        return false; // Rentang waktu tidak valid
      }
    }
    return true; // Rentang waktu valid
  }

  void _handleSave(DaftarAktivitas dataIn, String typeInput) {
    if (!validateInput()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data belum lengkap atau tidak valid.'),
        ),
      );
      return;
    }

    // Mengonversi jam mulai dan jam selesai menjadi objek DateTime
    DateTime startTime = DateTime.parse("$_date $_timeMulai");
    DateTime endTime = DateTime.parse("$_date $_timeSelesai");

    // Memvalidasi apakah jam mulai lebih besar dari jam selesai
    if (startTime.isAfter(endTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Jam selesai harus lebih besar dari jam mulai.'),
        ),
      );
      return;
    }

    // Lanjutkan dengan proses simpan data
    if (typeInput == 'input') {
      // Memvalidasi rentang waktu untuk tanggal yang sama
      if (!isTimeRangeValid(startTime, endTime, widget.daftarAllAktivitas)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Jam mulai dan jam selesai tidak boleh dalam rentang waktu yang sama dengan tanggal yang sudah ada.'),
          ),
        );
        return;
      } else {
        api.create(dataIn, tokenlistaktivitas!).then((result) {
          if (result == "true") {
            Fluttertoast.showToast(
                msg: "Berhasil Menambah Aktivitas!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 16.0);
            Navigator.pop(_scaffoldState.currentState!.context, true);
          } else {
            Fluttertoast.showToast(
                msg: "Tambah data gagal!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 16.0);
            Navigator.pop(_scaffoldState.currentState!.context, true);
          }
        });
      }
    } else if (typeInput == 'update') {
      // Memvalidasi rentang waktu untuk tanggal yang sama
      if (!isTimeRangeValid(startTime, endTime, widget.daftarAllAktivitas)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Jam mulai dan jam selesai tidak boleh dalam rentang waktu yang sama dengan tanggal yang sudah ada.'),
          ),
        );
        return;
      } else {
        api.update(dataIn, tokenlistaktivitas!).then((result) {
          if (result == "true") {
            Fluttertoast.showToast(
                msg: "Update data sukses!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 16.0);
            // Navigator.pop(context, true);
            Navigator.pop(_scaffoldState.currentState!.context, true);
          } else {
            Fluttertoast.showToast(
                msg: "Update data gagal!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        });
      }
    }
  }
}
