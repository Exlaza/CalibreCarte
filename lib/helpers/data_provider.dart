import 'package:calibre_carte/models/data.dart';
import 'package:sqflite/sqflite.dart';

import 'db_helper.dart';

class DataProvider {
  static String tableName = 'data';

  static Future<List<Data>> getDataByBookID(int id) async {
    Database db = await DatabaseHelper.instance.db;
    List<Map> maps = await db
        .query(tableName, where: '${Data.columns[1]} = ?', whereArgs: [id]);

    List<Data> booksDataList = List();

    maps.forEach((element) {
      booksDataList.add(Data.fromMapObject(element));
    });

    return booksDataList;
  }
}
