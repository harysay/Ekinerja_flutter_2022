/*---------------------------------------------------------------------------------------------
*  Copyright (c) nt4f04und. All rights reserved.
*  Licensed under the BSD-style license. See LICENSE in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import 'package:ekinerja2020/verifikasi/ui/buttons.dart';
import 'package:ekinerja2020/verifikasi/ui/scrollbar.dart';
import 'package:ekinerja2020/verifikasi/util/route_transitions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Class that contains composed 'show' functions, like [showDialog] and others
///
/// TODO: add code to prevent stacking alert dialogs
abstract class ShowFunctions {
  /// Shows toast from [Fluttertoast] with already set [backgroundColor] to `Color.fromRGBO(18, 18, 18, 1)`
  static Future<Future<bool?>> showToast({
    required String msg,
    Toast? toastLength,
    int timeInSecForIos = 1,
    double fontSize = 14.0,
    ToastGravity? gravity,
    Color? textColor,
    Color? backgroundColor,
  }) async {
    backgroundColor ??= Color.fromRGBO(18, 18, 18, 1);

    return Fluttertoast.showToast(
      msg: msg,
      toastLength: toastLength,
      timeInSecForIosWeb: timeInSecForIos,
      fontSize: fontSize,
      gravity: gravity,
      textColor: textColor,
      backgroundColor: backgroundColor,
    );
  }

  /// Calls [showGeneralDialog] function from flutter material library to show a message to user (only accept button)
  static Future<dynamic> showAlert(
    BuildContext context, {
    Widget title = const Text("Peringatan"),
    required Widget content,
    EdgeInsets titlePadding = const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 6.0),
    EdgeInsets contentPadding = const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 10.0),
    DialogRaisedButton? acceptButton,
    List<Widget>? additionalActions,
  }) async {
    assert(title != null);
    assert(content != null);

    acceptButton ??= DialogRaisedButton.accept(text: "Tutup");

    return showDialog(
      context,
      title: title,
      content: content,
      titlePadding: titlePadding,
      contentPadding: contentPadding,
      acceptButton: acceptButton,
      additionalActions: additionalActions!,
      hideDeclineButton: true,
    );
  }

  /// Calls [showGeneralDialog] function from flutter material library to show a dialog to user (accept and decline buttons)
  static Future<dynamic> showDialog(
    BuildContext context, {
    required Widget title,
    Widget? content,
    EdgeInsets titlePadding = const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 10.0),
    EdgeInsets contentPadding = const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 10.0),
    DialogRaisedButton? acceptButton,
    DialogRaisedButton? declineButton,
    bool hideDeclineButton = false,
    List<Widget>? additionalActions,
  }) async {
    assert(title != null);
    assert(content != null);

    acceptButton ??= DialogRaisedButton.accept();
    if (!hideDeclineButton) {
      declineButton ??= DialogRaisedButton.decline();
    }

    return showGeneralDialog(
      barrierColor: Colors.black54,
      transitionDuration: kSMMRouteTransitionDuration,
      barrierDismissible: true,
      barrierLabel: 'SMMAlertDialog',
      context: context,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final scaleAnimation = Tween(begin: 0.98, end: 1.0).animate(
          CurvedAnimation(
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
            parent: animation,
          ),
        );

        final fadeAnimation = CurvedAnimation(
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
          parent: animation,
        );

        return ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: AlertDialog(
            title: Container(
              padding: titlePadding,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              child: title,
            ),
            titlePadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //  widget(child: content),
                Flexible(
                  child: Padding(
                    padding: contentPadding,
                    child: SMMScrollbar(
                      thickness: 5.0,
                      child: SingleChildScrollView(
                        child: content,
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 2.0),
                    child: Row(
                      mainAxisAlignment: additionalActions == null
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        if(additionalActions != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: ButtonBar(
                              buttonPadding: EdgeInsets.zero,
                              alignment: MainAxisAlignment.start,
                              children: additionalActions,
                            ),
                          ),
                        ButtonBar(
                          buttonPadding: EdgeInsets.zero,
                          mainAxisSize: MainAxisSize.min,
                          alignment: MainAxisAlignment.end,
                          children: <Widget>[
                            acceptButton!,
                            if(!hideDeclineButton) declineButton!
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            contentPadding: EdgeInsets.zero,
            contentTextStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 15.0,
                ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
        );
      },
    );
  }
}
