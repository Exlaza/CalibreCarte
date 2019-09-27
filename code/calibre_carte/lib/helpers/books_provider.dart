import 'package:calibre_carte/models/books.dart';
import 'package:sqflite/sqflite.dart';

import 'db_helper.dart';

class BookProvider {


  static Future<Books> getFirstBook() async {
    Database db = await DatabaseHelper.instance.db;

    List<Map> maps = await db.query('books');
    return Books.fromMapObject(maps.first);

  }
}