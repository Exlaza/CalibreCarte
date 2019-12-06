import 'dart:io';
import 'dart:typed_data';
import 'package:calibre_carte/helpers/metadata_cacher.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "/metadata.db";
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

  static nullDb() async{
    _db = null;
  }

  static Future<String> getDatabasePath() async{
    String databasePath = await getDatabasesPath();
    String path = join(databasePath + "/metadata.db");
    return path;
  }

  // Here we are checking that there is not already a copy of the
  initDb() async {
//    print("I am inside initDb");
    String path = await getDatabasePath();
    var exists = await databaseExists(path);

    if (!exists) {
//      print("Database at path doesn't exist");
//      Making sure  the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      //Copy the metadata file in assets so we can proceed with the
      // rest of the application development
      //Copy it to some location that Android like to keep it database files,
      // that only this application can access
      MetadataCacher mc = MetadataCacher();
//      print('Metdata cacher should now run"');
      await mc.downloadAndCacheMetadata();
    } else {
//      print("Database at path exists");
    }
//    print("Open gets called asfter this stateemnt");
    return await openDatabase("metadata.db");
  }

  static deleteDb() async{
    String path = await getDatabasePath();
    await deleteDatabase(path);
  }

  static invalidateCache() async{
    await _db.close();
    await DatabaseHelper.nullDb();
  }

}

