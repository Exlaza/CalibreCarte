import 'dart:io';
import 'package:calibre_carte/helpers/db_helper.dart';
import 'package:path_provider/path_provider.dart';

class CacheInvalidator {
  static invalidateImagesCache() async {
    var appDir = (await getTemporaryDirectory()).path;
    Directory(appDir).delete(recursive: true);
  }

  static invalidateDatabaseCache() async {
    await DatabaseHelper.invalidateCache();
  }
}
