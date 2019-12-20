import 'package:calibre_carte/models/tags.dart';
import 'package:sqflite/sqflite.dart';

import 'db_helper.dart';

class TagsProvider {
  static String tableName = 'Tags';

  static Future<Tags> getFirstTag() async {
    Database db = await DatabaseHelper.instance.db;
    List<Map> maps = await db.query(tableName);
    return Tags.fromMapObject(maps.first);
  }

  static Future<Tags> getTagByID(int id, cols) async {
    Database db = await DatabaseHelper.instance.db;
    List<Map> maps = await db.query(tableName,
        columns: cols ? cols : Tags.columns,
        where: '${Tags.columns[0]} = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Tags.fromMapObject(maps.first);
    }
    return null;
  }

  static Future<List<Tags>> getAllTags() async {
    Database db = await DatabaseHelper.instance.db;
    List<Map> maps = await db.query(tableName);
    return maps.map((m) {
      return Tags.fromMapObject(m);
    }).toList();
  }
}
