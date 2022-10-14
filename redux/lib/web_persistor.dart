import 'dart:convert';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobidax_redux/store.dart';
import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'package:universal_html/html.dart';

class WebPersistor extends Persistor {
  /// localStorage key to save to.
  final String key;

  WebPersistor([this.key = "mobidax"]);

  @override
  Future<void> deleteState() async {
    try {
      window.localStorage.remove(key);
    } catch (e) {
      throw StateError('Unable to delete state from local storage $e');
    }
  }

  @override
  Future<void> persistDifference({lastPersistedState, newState}) async {
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    try {
      window.localStorage[key] = encoder.convert(newState.toJson());
    } catch (e) {
      throw StateError('Unable to write new state to local storage $e');
    }
  }

  @override
  Future<AppState> readState() async {
    try {
      return AppState.fromJson(json.decode(window.localStorage[key]));
    } catch (e) {
      debugPrint('Unable to read state from local storage $e');
      return AppState.initialState();
    }
  }
}
