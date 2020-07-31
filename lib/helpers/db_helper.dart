import 'dart:io';
import 'package:calibre_carte/helpers/metadata_cacher.dart';
import 'package:path/path.dart';
import 'dart:async';
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

  static nullDb() async {
    _db = null;
  }

  static Future<String> getDatabasePath() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath + "/metadata.db");
    return path;
  }

  // Here we are checking that there is not already a copy of the
  initDb() async {
//    print("I am inside initDb");
    String path = await getDatabasePath();
    bool exists;
    try{await databaseExists(path);
    exists=true;}catch(e){
//      print("database exception partial download $e");
    }

    if (!exists) {
//      print("Database at path doesn't exist");
//      Making sure  the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      MetadataCacher mc = MetadataCacher();
//      print('Metdata cacher should now run"');
      await mc.downloadAndCacheMetadata();
    } else {
//      print("Database at path exists");
    }
//    print("Open gets called asfter this stateemnt");
    try{return await openDatabase("metadata.db");}catch(e){
//      print(" exception $e");
      MetadataCacher mc = MetadataCacher();
//      print('Metdata cacher should now run"');
      await mc.downloadAndCacheMetadata();
      return await openDatabase("metadata.db");
    }
  }

  static deleteDb() async {
    String path = await getDatabasePath();
    await deleteDatabase(path);
  }

  static invalidateCache() async {
    await _db.close();
    await DatabaseHelper.nullDb();
  }
}
