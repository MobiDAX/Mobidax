import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobidax_redux/redux.dart';

Widget makeWidgetTestable({Widget child, Store<AppState> store}) {
  return MediaQuery(
    data: const MediaQueryData(
      size: Size(
        600.0,
        800.0,
      ),
    ),
    child: store != null
        ? StoreProvider<AppState>(
            store: store,
            child: MaterialApp(
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              home: child,
            ),
          )
        : MaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            home: child,
          ),
  );
}
