import 'package:calibre_carte/models/ratings.dart';
import 'package:sqflite/sqflite.dart';

import 'db_helper.dart';

class RatingsProvider {
  static String tableName = 'Ratings';

  static Future<Ratings> getFirstRating() async {
    Database db = await DatabaseHelper.instance.db;
    List<Map> maps = await db.query(tableName);
    return Ratings.fromMapObject(maps.first);
  }

  static Future<Ratings> getRatingByID(int id, cols) async {
    Database db = await DatabaseHelper.instance.db;
    try {
      List<Map> maps = await db.query(tableName,
          columns: cols!=null ? cols : Ratings.columns,
          where: '${Ratings.columns[0]} = ?',
          whereArgs: [id]);
      if (maps.length > 0) {
        return Ratings.fromMapObject(maps.first);
      }
    } catch (e) {
      print("rating error $e");
    }
    return null;
  }

  static Future<List<Ratings>> getAllRatings() async {
    Database db = await DatabaseHelper.instance.db;
    List<Map> maps = await db.query(tableName);
    return maps.map((m) {
      return Ratings.fromMapObject(m);
    }).toList();
  }
}
