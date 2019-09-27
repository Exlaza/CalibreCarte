import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "metadata.db";
  static final _databaseVersion = 1;

  //  Make this class a singleton class(A singleton class is has only one instance active at any time)
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDb();
    return _db;
  }

  // Here we are checking that there is not already a copy of the
  initDb() async {
    var databasePath = await getDatabasesPath();
    var path = join(databasePath, _databaseName);
    var exists = await databaseExists(path);

    if (!exists) {
      print("Creating new copt from asset");

      //Making sure  the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      print("Doing someting");

      ByteData data = await rootBundle.load("assets/testing/metadata.db");
      print("over eerer");
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      print("Almpost there");
      await File(path).writeAsBytes(bytes, flush: true);
      print("Finally I htnk it is time");
    } else {
      print('Print opening part');
    }

    return await openDatabase(path);
  }
}

