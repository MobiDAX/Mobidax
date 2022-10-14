import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobidax_redux/types.dart';

import 'color_helper.dart';

class SnackBarNotifier {
  static void createSnackBar(String message, BuildContext context,
      [Status status]) {
    var bgColor = status != null
        ? status == Status.error
            ? Theme.of(context).colorScheme.error
            : Colors.green
        : Theme.of(context).colorScheme.primaryVariant;

    print(toHex(Theme.of(context).colorScheme.error));
    var webBgColor = status != null
        ? status == Status.error
            ? toHex(
                Theme.of(context).colorScheme.error,
              )
            : toHex(Colors.green)
        : toHex(
            Theme.of(context).colorScheme.primaryVariant,
          );

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: bgColor,
      textColor: Colors.white,
      webShowClose: true,
      webPosition: 'center',
      webBgColor: webBgColor,
      fontSize: Theme.of(context).textTheme.headline6.fontSize,
    );
  }
}
