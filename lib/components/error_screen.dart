import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/theme.dart';

Widget errorScreen(FlutterErrorDetails error) {
  return Scaffold(
    backgroundColor: backgroundColor,
    body: Builder(
      builder: (context) => Center(
        child: Text(
          tr('something_went_wrong'),
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    ),
  );
}
