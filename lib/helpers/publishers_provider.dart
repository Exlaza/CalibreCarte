import 'package:calibre_carte/models/publishers.dart';
import 'package:sqflite/sqflite.dart';

import 'db_helper.dart';

class PublishersProvider {
  static String tableName = 'publishers';

  static Future<Publishers> getFirstPublisher() async {
    Database db = await DatabaseHelper.instance.db;
    List<Map> maps = await db.query(tableName);
    return Publishers.fromMapObject(maps.first);
  }

  static Future<Publishers> getPublisherByID(int id, cols) async {
    Database db = await DatabaseHelper.instance.db;
    try {
      List<Map> maps = await db.query(tableName,
          columns: cols!=null ? cols : Publishers.columns,
          where: '${Publishers.columns[0]} = ?',
          whereArgs: [id]);
      if (maps.length > 0) {
        return Publishers.fromMapObject(maps.first);
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<Publishers>> getAllPublishers() async {
    Database db = await DatabaseHelper.instance.db;
    List<Map> maps = await db.query(tableName);
    return maps.map((m) {
      return Publishers.fromMapObject(m);
    }).toList();
  }
}
