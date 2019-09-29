import 'package:calibre_carte/models/comments.dart';
import 'package:sqflite/sqflite.dart';

import 'db_helper.dart';

class CommentsProvider {
  static String tableName = 'Comments';

  static Future<Comments> getFirstComment() async {
    Database db = await DatabaseHelper.instance.db;
    List<Map> maps = await db.query(tableName);
    return Comments.fromMapObject(maps.first);
  }

  static Future<Comments> getCommentByID(int id, cols) async {
    Database db = await DatabaseHelper.instance.db;
    List<Map> maps = await db.query(tableName,
        columns: cols != null ? cols : Comments.columns,
        where: '${Comments.columns[1]} = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Comments.fromMapObject(maps.first);
    }
    return null;
  }

  static Future<Comments> getCommentByBookID(int id, cols) async {
    Database db = await DatabaseHelper.instance.db;
    List<Map> maps = await db.query(tableName,
        columns: cols != null ? cols : Comments.columns,
        where: '${Comments.columns[0]} = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Comments.fromMapObject(maps.first);
    }
    return null;
  }

  static Future<List<Comments>> getAllComments() async {
    Database db = await DatabaseHelper.instance.db;
    List<Map> maps = await db.query(tableName);
    return maps.map((m) {
      return Comments.fromMapObject(m);
    }).toList();
  }
}