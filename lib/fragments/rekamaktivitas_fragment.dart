import 'package:ekinerja2020/model/daftar_aktivitas.dart';
import 'package:ekinerja2020/verifikasi/halVerifikasi.dart';
import 'package:ekinerja2020/verifikasi/splash/list_tile_splash.dart';
import 'package:ekinerja2020/verifikasi/ui/buttons.dart';
import 'package:ekinerja2020/verifikasi/ui/icon_button.dart';
import 'package:ekinerja2020/verifikasi/ui/tabs.dart';
import 'package:ekinerja2020/verifikasi/util/show_functions.dart';
import 'package:flutter/material.dart';
import 'package:ekinerja2020/pages/form_screen.dart';
import 'package:ekinerja2020/service/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

ApiService api = new ApiService();
final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class SecondFragment extends StatefulWidget{
  @override
  _SecondFragmentState createState() => _SecondFragmentState();
}
class _SecondFragmentState extends State<SecondFragment> with TickerProviderStateMixin {
  SelectionController? selectionController;
  TabController? _tabController;
  DaftarAktivitas? data;
  List<DaftarAktivitas>? semuaAktivitas;
  String tokenlistaktivitas="";
  _getRequests()async{
    setState(() {});
  }

  final _tabsAktivitas = [
    Tab(
      child: Text(
        "Belum Diverifikasi",
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    Tab(
      child: Text(
        "Sudah Verifikasi",
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    getPref();
    super.initState();

    // Init selection controller
    selectionController = SelectionController<String>(
      loadedAktivitas: [],
      switcher: IntSwitcher(),
      animationController:
      AnimationController(vsync: this, duration: kSelectionDuration),
    ) // Subscribe to tile clicks to update the selection counter in the SelectionAppBar
      ..addListener(() {
        setState(() {});
      })
    // Subscribe to selection status changes
      ..addStatusListener((status) {
        setState(() {});
      });

    _tabController =
        _tabController = TabController(vsync: this, length: _tabsAktivitas.length);
  }

  Future<Null> getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      tokenlistaktivitas = preferences.getString("tokenlogin")!;
    });
  }

  void _handleHapus() {
    ShowFunctions.showDialog(context,
        title: const Text("Yakin ingin hapus Aktivitas?"),
        acceptButton: DialogRaisedButton(
          text: "Tolak",
          onPressed: () {
            selectionController!.close();
            selectionController!.loadedAktivitas.forEach((element)async{
              api.delete(element.idDataKinerja!,tokenlistaktivitas);
            });
            Navigator.pop(context, true);
            Navigator.pop(context, true);
            ShowFunctions.showToast(msg: "Berhasil Dihapus!");
          },
        ),
        declineButton: DialogRaisedButton.decline(
          text: "Batal",
          onPressed: () {
            selectionController!.close();
//          selectionController.loadedAktivitas.forEach((element)async{
//            setujui(element.idDataKinerja,element.waktuDiakui,element.tglKinerja);
//          });
            Navigator.pop(context, true);
//          Navigator.pop(context, true);
//          ShowFunctions.showToast(msg: "Berhasil Disetujui!");
//          Navigator.of(context, rootNavigator: true).pop(true);
//          Navigator.pop(_scaffoldState.currentState.context,true);
          },
        )
    );
    //ContentControl.deleteSongs(selectionController.selectionSet);
//    Scaffold.of(context).showSnackBar(SnackBar(content: Text(selectionController.loadedAktivitas.first.toString())));
    //semuaAktivitas.add(selectionController.selectionSet)

  }

  Future<bool> _handlePop(BuildContext context) async {
    if (Scaffold.of(context).isDrawerOpen) {
      Navigator.of(context).pop();
      return Future.value(false);
    } else if (selectionController!.inSelection) {
      selectionController!.close();
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final baseAnimation = CurvedAnimation(
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
      parent: selectionController!.animationController,
    );
    return Scaffold(
      key: _scaffoldState,
      body: Builder(
        builder: (context) => WillPopScope(
          onWillPop: () => _handlePop(context),
          child: Stack(
            children: <Widget>[
              ScrollConfiguration(behavior: SMMScrollBehaviorGlowless(),
                child: AnimatedBuilder(
                  animation: baseAnimation,
                  child: TabBarView(
                    controller: _tabController,
                    // Don't let user to switch tab  by the swipe gesture when in selection
                    physics: selectionController!.inSelection
                        ? const NeverScrollableScrollPhysics()
                        : null,
                    children: <Widget>[
                      //AktivitasListTab(selectionController: selectionController,listAktivitas: semuaAktivitas),
                      AktivitasListTab(selectionController: selectionController!,tokenlog: tokenlistaktivitas),
                      AktivitasListTabVerifikasi(selectionController: selectionController!,tokenlog: tokenlistaktivitas)
//                      Center(child: Text("Aktivitas yang sudah diverifikasi")),
                    ],
                  ),
                  builder: (context,child){
                    return Padding(
                      padding: EdgeInsets.only(
                          top: 44.0 * (1 - baseAnimation.value)
                      ),
                      child: child,
                    );
                  }
                  // builder: (BuildContext context, Widget child) => Padding(
                  //   padding: EdgeInsets.only(
                  //     // Offsetting the list back to top
                  //       top: 44.0 * (1 - baseAnimation.value)),
                  //   child: child,
                  // ),
                ),
              ),
              IgnorePointer(
                ignoring: selectionController!.inSelection,
                child: FadeTransition(
                  opacity: ReverseAnimation(baseAnimation),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      splashFactory: ListTileInkRipple.splashFactory,
                    ),
                    child: Material(
                      elevation: 2.0,
                      color: Theme.of(context).appBarTheme.shadowColor,
                      child: SMMTabBar(
                        controller: _tabController,
                        indicatorWeight: 5.0,
                        indicator: BoxDecoration(
                          // color: Theme.of(context).textTheme.headline6.color,
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: const BorderRadius.only(
                            topLeft: const Radius.circular(3.0),
                            topRight: const Radius.circular(3.0),
                          ),
                        ),
                        labelColor: (Colors.blue[300])!,
                        indicatorSize: TabBarIndicatorSize.label,
                        unselectedLabelColor: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                        labelStyle: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(
                            fontSize: 15.0, fontWeight: FontWeight.w900),
                        tabs: _tabsAktivitas,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(

        onPressed: ()=>
            // Navigator.of(context).push(new MaterialPageRoute(builder: (_)=>new FormScreen()),)
            //     .then((val)=>val?_getRequests():null),
        Navigator.of(context).push(new MaterialPageRoute(builder: (_) => new FormScreen()))
            .then((val) {
          if (val != null && val) {
            _getRequests();
          }
        }),
        tooltip: 'Tambah Aktivitas',
        child: Icon(Icons.add_circle_outline),
      ),
    );
  }
}

class AktivitasListTab extends StatefulWidget {
  AktivitasListTab({
    Key? key,
    required this.selectionController,required this.tokenlog
  }) : super(key: key);
  final SelectionController selectionController;
  String tokenlog;

  @override
  _AktivitasListTabState createState() => _AktivitasListTabState();
}

class _AktivitasListTabState extends State<AktivitasListTab>
    with AutomaticKeepAliveClientMixin<AktivitasListTab> {
  // This mixin doesn't allow widget to redraw

  @override
  bool get wantKeepAlive => true;
  late ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    super.build(context);
//    final songs = ContentControl.songs;
    ApiService api = ApiService();
    List<DaftarAktivitas>? semuaAktivitas;

    return FutureBuilder(
      future: api.getAllKontak(widget.tokenlog),
      builder: (BuildContext context, AsyncSnapshot<List<DaftarAktivitas>?> snapshot){
        semuaAktivitas = snapshot.data;
        if((snapshot.hasData)){
          if (semuaAktivitas!.length == 0){
            return Center(
              child: Text(
                "Tidak Ada Data",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            );
          }else{
            return ListView.builder(
              itemBuilder: (context, index) {
                DaftarAktivitas aktivitas = semuaAktivitas![index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      //height: 80, //atur lebar card list
                      child: ListTile(
                        leading: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(aktivitas.tglKinerja!,style: TextStyle(fontSize: 14))
                          ],
                        ),
                        title: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Flexible(child: new Text(aktivitas.namaPekerjaan!+" ("+aktivitas.standarWaktu!+")",style: TextStyle(fontSize: 18)))
//                  Text(aktivitas.namaPekerjaan),Text(" ("+aktivitas.standarWaktu+")",style: TextStyle(fontSize: 11, color: Colors.black))
                            ]
                        ),
                        subtitle: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Flexible(child: new Text(aktivitas.uraianPekerjaan!+" ("+aktivitas.waktuMengerjakan!+")",style: TextStyle(fontSize: 14)))
                              //Text(aktivitas.uraianPekerjaan)
                            ]
                        ),
                        trailing: Column(
                          children: <Widget>[
                            InkWell(
//                              child:  Icon(Icons.edit, size: 20,),
                              child: new Container(
                                child: Icon(Icons.edit, size: 20,),
//                                color: Colors.orange[100],
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(color: Colors.lightBlue, spreadRadius: 1),
                                  ],
                                ),
                                height: 20,
//                                width: 50.0,
//                                height: 50.0,
                              ),
                              onTap: (){
                                //Masukan navigator di sini
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return FormScreen(daftaraktivitas: aktivitas);
                                    }));
                              },

                            ),
                            Padding(padding: EdgeInsets.only(bottom: 16)), //atur jarak antar InkWell
                            InkWell(
                              child: new Container(
                                child: Icon(Icons.delete, size: 20,),
//                                color: Colors.orange[100],
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(color: Colors.red, spreadRadius: 1),
                                  ],
                                ),
                                height: 20,
//                                width: 50.0,
//                                height: 50.0,
                              ),
                              onTap: (){
//                          _showModalAlert(
//                              'Peringatan',
//                              'Apakah task ini akan di hapus?',
//                              aktivitas.idSubPekerjaan
//                          );
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Peringatan'),
                                        content: Text('Apakah Anda yakin akan menghapus?'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('No'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Yes'),
                                            onPressed: () {
                                              //_deleteTask(aktivitas.idSubPekerjaan);
                                              api.delete(aktivitas.idDataKinerja!,widget.tokenlog).then((result) {
                                                if (result != null) {
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hapus data sukses"),));
                                                  // _scaffoldState.currentState
                                                  //     .showSnackBar(SnackBar(
                                                  //   content: Text("Hapus data sukses"),
                                                  // ));
                                                  setState(() {});
                                                } else {
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hapus data gagal"),));
                                                  // _scaffoldState.currentState
                                                  //     .showSnackBar(SnackBar(
                                                  //   content: Text("Hapus data gagal"),
                                                  // ));
                                                }
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      );
                                    }
                                );
                              },
                            ),
                          ],
                        ),
                      ),
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    Row(
//                      children: <Widget>[
//                        Text(aktivitas. tglKinerja),
//
//                        Text(
//                            aktivitas.namaPekerjaan + " " + aktivitas.waktuMengerjakan),
//                        Spacer(),
//                        Text(aktivitas.uraianPekerjaan),
//                      ],
//                    ),
//                    SizedBox(
//                      height: 10,
//                    ),
//                    Row(
//                      children: <Widget>[
//                        Spacer(),
//                        RaisedButton(
//                          child: Text("Ubah",
//                              style: TextStyle(color: Colors.white)),
//                          color: Colors.orange[400],
//                          onPressed: () {
//                            // panggil FormScreen dengan parameter
//                          },
//                        ),
//                        SizedBox(
//                          width: 5,
//                        ),
//                        RaisedButton(
//                          child: Text("Hapus",
//                              style: TextStyle(color: Colors.white)),
//                          color: Colors.orange[400],
//                          onPressed: () {
//                            // panggil endpoint hapus
//                          },
//                        ),
//                      ],
//                    ),
//                  ],
//                ),
                    ),
                  ),
                );
              },
              itemCount: semuaAktivitas!.length,
            );
          }
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class AktivitasListTabVerifikasi extends StatefulWidget {
  AktivitasListTabVerifikasi({
    Key? key,
    required this.selectionController,required this.tokenlog
  }) : super(key: key);
  final SelectionController selectionController;
  String tokenlog;

  @override
  _AktivitasListTabVerifikasi createState() => _AktivitasListTabVerifikasi();
}

class _AktivitasListTabVerifikasi extends State<AktivitasListTabVerifikasi>
    with AutomaticKeepAliveClientMixin<AktivitasListTabVerifikasi> {
  // This mixin doesn't allow widget to redraw

  @override
  bool get wantKeepAlive => true;
  late ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    super.build(context);
//    final songs = ContentControl.songs;
    ApiService api = ApiService();
    List<DaftarAktivitas>? semuaAktivitas;

    return FutureBuilder(
      future: api.getSudahverfiPribadi(widget.tokenlog),
      builder: (BuildContext context, AsyncSnapshot<List<DaftarAktivitas>?> snapshot){
        semuaAktivitas = snapshot.data;
        if((snapshot.hasData)){
          if (semuaAktivitas!.length == 0){
            return Center(
              child: Text(
                "Tidak Ada Data",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            );
          }else{
            return ListView.builder(
              itemBuilder: (context, index) {
                DaftarAktivitas aktivitas = semuaAktivitas![index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      child: ListTile(
                        leading: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(aktivitas.tglKinerja!,style: TextStyle(fontSize: 14))
                          ],
                        ),
                        title: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Flexible(child: new Text(aktivitas.namaSubPekerjaan!+" ("+aktivitas.standarWaktu!+")",style: TextStyle(fontSize: 18)))
//                  Text(aktivitas.namaPekerjaan),Text(" ("+aktivitas.standarWaktu+")",style: TextStyle(fontSize: 11, color: Colors.black))
                            ]
                        ),
                        subtitle: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Flexible(child: new Text(aktivitas.uraianPekerjaan!+" ("+aktivitas.waktuMengerjakan!+")",style: TextStyle(fontSize: 14)))
                              //Text(aktivitas.uraianPekerjaan)
                            ]
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: semuaAktivitas!.length,
            );
          }
        }
        return Center(
            child: Container(
              margin: EdgeInsets.only(left: 22,right: 22),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(height: 22),
                  Text('Mungkin membutuhkan waktu lebih untuk ini..'),
                  Text("Data yang tampil hanya data kinerja bulan ini yang sudah terverifikasi, namun khusus jika sekarang tanggal 1 data kinerja pada bulan sebelumnya masih bisa ditampilkan (jika sudah masuk tanggal 2 data tidak ditampilkan)",style: TextStyle(fontSize: 10)),
//              Text('Data yang tampil hanya data kinerja bulan ini yang sudah terverifikasi, namun khusus jika sekarang tanggal 1 data kinerja pada bulan sebelumnya masih bisa ditampilkan (jika sudah masuk tanggal 2 data tidak ditampilkan'+')',style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 10))
                ],
              ),
            )
        );
      },
    );
  }
}