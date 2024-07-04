import 'dart:convert';
import 'dart:io';

import 'package:ekinerja2020/service/ApiService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:package_info/package_info.dart';
// import 'package:package_info_plus/package_info_plus.dart';
//import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'DoNotAskAgainDialog.dart';

class UpdateApp extends StatefulWidget {
  final Widget? child;

  UpdateApp({this.child});

  @override
  _UpdateAppState createState() => _UpdateAppState();
}

class _UpdateAppState extends State<UpdateApp> {
  String? statusRun,getVersionLastServer;
  String? kUpdateDialogKeyName;
  String? versionName;
  String? versionCode;
//  int getVersionLastServer;
  @override
  void initState() {
    super.initState();
    _initPackageInfo();

  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      versionName = info.version;
      versionCode = info.buildNumber;
    });
    checkLatestVersion(context);
  }

  checkLatestVersion(context) async {
    //Add query here to get the minimum and latest app version
    final response = await http.get(Uri.parse(ApiService.urlUtama+"status/running"));
    final stat = jsonDecode(response.body);
    setState(() {
      statusRun = stat['status'];
      getVersionLastServer = stat['version'];
    });

    if (statusRun == "1") {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.buildNumber.toString();
      //Change
      //Parse the result here to get the info
      //AppVersion appVersion = response.results[0] as AppVersion;
      String minAppVersion = getVersionLastServer!;
      String? latestAppVersion = versionCode;//ApiService.versionCodeSekarang;



      if (int.parse(minAppVersion) > int.parse(currentVersion)) {
        _showCompulsoryUpdateDialog(
          context,
          "Silahkan update/install ulang aplikasi Anda di playstore untuk melanjutkan",
        );
      } else if (int.parse(latestAppVersion!) > int.parse(currentVersion)) {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

        bool showUpdates = false;
        showUpdates = sharedPreferences.getBool("updateAplikasi")!;
        if (showUpdates != null && showUpdates == false) {
          return;
        }

        _showOptionalUpdateDialog(
          context,
          "A newer version of the app is available",
        );
        print('Update available');
      } else {
        print('App is up to date');
      }
    }
  }

  _showOptionalUpdateDialog(context, String message) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        String title = "App Update Available";
        String btnLabel = "Update Sekarang";
        String btnLabelCancel = "Later";
        String btnLabelDontAskAgain = "Don't ask me again";
        return DoNotAskAgainDialog(
          kUpdateDialogKeyName!,
          title,
          message,
          btnLabel,
          btnLabelCancel,
          _onUpdateNowClicked,
          doNotAskAgainText:
          Platform.isIOS ? btnLabelDontAskAgain : 'Never ask again',
        );
      },
    );
  }

  _onUpdateNowClicked() async {
    const url = 'https://play.google.com/store/apps/details?id=id.go.kebumenkab.tukin.ekinerja2020';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _showCompulsoryUpdateDialog(context, String message) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "App Update Available";
        String btnLabel = "Update Sekarang";
        return Platform.isIOS
            ? new CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                btnLabel,
              ),
              isDefaultAction: true,
              onPressed: _onUpdateNowClicked,
            ),
          ],
        )
            : new AlertDialog(
          title: Text(
            title,
            style: TextStyle(fontSize: 22),
          ),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(btnLabel),
              onPressed: _onUpdateNowClicked,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child!;
  }
}