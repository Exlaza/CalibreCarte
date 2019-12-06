import 'dart:convert';
import 'package:calibre_carte/helpers/cache_invalidator.dart';
import 'package:calibre_carte/models/data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import '../helpers/db_helper.dart';


class MetadataCacher {
  //Should make a shared preferences helper
  Future<String> getTokenFromPreferences() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('token');
  }

  Future<String> getSelectedLibPathFromSharedPrefs() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('selected_calibre_lib_path');
  }

  downloadMetadata(token, path) async {
    String url = "https://content.dropboxapi.com/2/files/download";
    Map<String, String> headers = {
      "Authorization": "Bearer $token",
      "Dropbox-API-Arg": jsonEncode({"path": path}),
    };
    Response response = await post(
      url,
      headers: headers,
    );
    return response;
  }

  Future<void> downloadAndCacheMetadata() async {
    String token = await getTokenFromPreferences();
    String path = await getSelectedLibPathFromSharedPrefs();
    String absPath = path + 'metadata.db';
    Response response = await downloadMetadata(token, absPath);
    //Get the bytes, get the temp directory and write a file in temp
    if (response.statusCode == 200){
      print("Metadata file Downloaded Correctly");
      await DatabaseHelper.deleteDb();
      print("Old Database Deleted successfully");
      await CacheInvalidator.invalidateImagesCache();
      print("Cache of images cleared successfully");
    }
    List<int> bytes = response.bodyBytes;
    String tempDir = await getDatabasesPath();
    String pathMetadata = join(tempDir + "/metadata.db");
    await File(pathMetadata).writeAsBytes(bytes, flush: true);
  }

  Future<bool> checkIfCachedFileExists() async {
    Directory tempDir = await getTemporaryDirectory();
    String pathMetadata = join(tempDir.path + "metadata.db");
    return await File(pathMetadata).exists();
  }

  Future<String> returnCachedMetadataPath(bookID) async {
    Directory tempDir = await getTemporaryDirectory();
    String pathMetadata = join(tempDir.path + "/cover_$bookID.jpg");
    return pathMetadata;
  }
}
