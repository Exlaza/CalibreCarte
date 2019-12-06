import 'package:calibre_carte/helpers/cache_invalidator.dart';
import 'package:calibre_carte/models/books.dart';
import 'package:calibre_carte/models/data.dart';
import 'package:sqflite/sqflite.dart';

import 'db_helper.dart';

class BooksProvider {
  static String tableName = 'Books';

  static Future<Books> getFirstBook() async {
    Database db = await DatabaseHelper.instance.db;
    List<Map> maps = await db.query(tableName);
    return Books.fromMapObject(maps.first);
  }

  static Future<Books> getBookByID(int id, cols) async {
    Database db = await DatabaseHelper.instance.db;
    List<Map> maps = await db.query(tableName,
//        columns: Books.columns,
        where: '${Books.columns[0]} = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
//      print(Books.fromMapObject(maps.first).title);
      return Books.fromMapObject(maps.first);
    }
    return null;
  }

  static Future<List<Books>> getAllBooks(bool refresh) async {
    Database db = await DatabaseHelper.instance.db;

    if (refresh) {
      print('This is a new cache invalidation update');
      db = null;
      await CacheInvalidator.invalidateDatabaseCache();
      db = await DatabaseHelper.instance.db;
    }

    List<Map> maps = await db.query(tableName);
    return maps.map((m) {
      return Books.fromMapObject(m);
    }).toList();
  }

}
