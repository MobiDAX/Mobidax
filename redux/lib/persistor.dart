import 'dart:convert';
import 'dart:io';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mobidax_redux/store.dart';

class AppPersistor extends Persistor {
  Duration get throttle => const Duration(seconds: 10);

  Future<File> get _reduxStorePath async {
    final path =
        await getApplicationDocumentsDirectory().then((value) => value.path);
    return File('$path/redux_store.json');
  }

  @override
  Future<void> deleteState() async {
    try {
      final file = await _reduxStorePath;

      // Delete the file
      file.writeAsStringSync('');
    } catch (e) {
      throw StateError('Unable to delete state file');
    }
  }

  @override
  Future<void> persistDifference({lastPersistedState, newState}) async {
    try {
      final file = await _reduxStorePath;
      file.writeAsStringSync(jsonEncode(newState.toJson()));
    } catch (e) {
      throw StateError('Unable to write to a file');
    }
  }

  @override
  Future<AppState> readState() async {
    try {
      final path =
          await getApplicationDocumentsDirectory().then((value) => value.path);
      final file = await _reduxStorePath;
      if (FileSystemEntity.typeSync('$path/redux_store.json') ==
          FileSystemEntityType.notFound) {
        await file.create();
        return AppState.initialState();
      }
      await file.open();
      String contents = await file.readAsString();
      return AppState.fromJson(json.decode(contents));
    } catch (e) {
      debugPrint('Unable to read state from file $e');
      return AppState.initialState();
    }
  }
}
