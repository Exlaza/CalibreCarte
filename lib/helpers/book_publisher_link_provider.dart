import 'package:calibre_carte/helpers/publishers_provider.dart';
import 'package:calibre_carte/helpers/ratings_provider.dart';
import 'package:calibre_carte/models/books.dart';
import 'package:calibre_carte/models/books_publishers_link.dart';
import 'package:calibre_carte/models/books_ratings_link.dart';
import 'package:calibre_carte/models/publishers.dart';
import 'package:calibre_carte/models/ratings.dart';
import 'package:sqflite/sqflite.dart';

import 'db_helper.dart';

class BooksPublisherLinkProvider {
  static String tableName = 'books_publishers_link';

  static Future<BooksRatingLink> getFirstBookLinkProvider() async {
    Database db = await DatabaseHelper.instance.db;
    List<Map> maps = await db.query(tableName);
    return BooksRatingLink.fromMapObject(maps.first);
  }

  static Future<Publishers> getPublisherByBookID(int id) async {
//    print("book id $id");
    Database db = await DatabaseHelper.instance.db;
    try {
      List<Map> maps = await db.query(tableName,
          where: '${BooksRatingLink.columns[1]} = ?', whereArgs: [id]);
//      print(maps);
      if (maps == null) {
        return null;
      } else {
        BooksPublisherLink x = BooksPublisherLink.fromMapObject(maps.first);
//        print ("rating id ${x.rating}");
        Publishers publishers= await PublishersProvider.getPublisherByID(x.publisher, null);
        return publishers;
      }
    } catch (e) {
//      print("rating link error $e");
      return null;
    }
  }
}
