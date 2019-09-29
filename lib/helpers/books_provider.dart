import 'package:calibre_carte/models/books.dart';
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
    print('Oer here');
    List<Map> maps = await db.query(tableName,
//        columns: Books.columns,
        where: '${Books.columns[0]} = ?',
        whereArgs: [id]);
    print('Not workng');
    print(maps);
    if (maps.length > 0) {
      print(Books.fromMapObject(maps.first).title);
      return Books.fromMapObject(maps.first);
    }
    return null;
  }

  static Future<List<Books>> getAllBooks() async {
    Database db = await DatabaseHelper.instance.db;
    List<Map> maps = await db.query(tableName);
    return maps.map((m) {
      return Books.fromMapObject(m);
    }).toList();
  }

}
