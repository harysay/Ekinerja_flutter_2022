/*---------------------------------------------------------------------------------------------
*  Copyright (c) nt4f04und. All rights reserved.
*  Licensed under the BSD-style license. See LICENSE in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'package:ekinerja2020/verifikasi/splash/list_tile_splash.dart';
//import 'list_tile_splash.dart';

/// Creates [Raised] with border radius, by default colored into main app color

class DialogRaisedButton extends StatelessWidget {
  const DialogRaisedButton({
    Key? key,
    this.text = "Menutup",
    this.textStyle,
    this.color,
    this.padding = const EdgeInsets.symmetric(horizontal: 15.0),
    this.borderRadius = 15.0,
    this.onPressed,
  }) : super(key: key);

  /// Text to show inside button
  final String? text;
  final TextStyle? textStyle;
  final Color? color;
  final EdgeInsets? padding;
  final double? borderRadius;

  /// The returned value will be passed to [Navigator.maybePop()] method call
  final Function? onPressed;

  /// Constructs an accept button.
  ///
  /// `true` will be always passed to [Navigator.maybePop()] call.
  factory DialogRaisedButton.accept(
      {String text = "Setuju", Function? onPressed}) {
    return DialogRaisedButton(
      text: text,
      onPressed: () {
        if (onPressed != null) {
          onPressed();
        }
        return true;
      },
    );
  }

  /// Constructs a decline button.
  ///
  /// `false` will be always passed to [Navigator.maybePop()] call.
  factory DialogRaisedButton.decline(
      {String text = "Batal", Function? onPressed}) {
    return DialogRaisedButton(
      text: text,
      color: AppColors.whiteDarkened,
      textStyle: TextStyle(color: Colors.black),
      onPressed: () {
        if (onPressed != null) {
          onPressed();
        }
        return false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: ListTileInkRipple.splashFactory,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          animationDuration: Duration(milliseconds: 1000),
          primary: Colors.orangeAccent,
          shadowColor: Colors.redAccent,
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: padding,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
          ),
        ),
        child: Text(
          text!,
          style: textStyle ??
              TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        onPressed: () async {
          var res;
          if (onPressed != null) {
            res = await onPressed!();
          }
          //App.navigatorKey.currentState.maybePop(res);
        },
      ),
    );
  }
}

/// Creates [FlatButton] with border radius, perfect for [showDialog]s accept and decline buttons
class DialogFlatButton extends StatelessWidget {
  DialogFlatButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.textColor,
    this.borderRadius = 5.0,
  });

  final Widget? child;
  final VoidCallback onPressed;
  final Color? textColor;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      key: key,
      child: child!,
      onPressed: onPressed,
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius!),
                  side: BorderSide(color: textColor!)))
      ),
    );
  }
}

