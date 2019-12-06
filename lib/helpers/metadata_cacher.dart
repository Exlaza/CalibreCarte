import 'dart:convert';
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
//    print("I should also have come here after logging in");
    String url = "https://content.dropboxapi.com/2/files/download";
    Map<String, String> headers = {
      "Authorization": "Bearer $token",
      "Dropbox-API-Arg": jsonEncode({"path": path}),
    };
//    String json = '{"path": $path}'; // make POST request
    Response response = await post(
      url,
      headers: headers,
    ); // check the status code for the result
    return response;
  }

  Future<void> downloadAndCacheMetadata() async {
    print("Download and cahce metadata getting called");
    String databasePath = await getDatabasesPath();
    String pathD = join(databasePath + "/metadata.db");
    await deleteDatabase(pathD);
    print("I am deleting the database and checking whether it exists");
    print(await databaseExists(pathD));
    print("Check complete");

    String token = await getTokenFromPreferences();
    String path = await getSelectedLibPathFromSharedPrefs();
    String absPath = path + 'metadata.db';
//    print(absPath);
    Response response = await downloadMetadata(token, absPath);
    //Get the bytes, get the temp directory and write a file in temp
//    print(response.statusCode);
    List<int> bytes = response.bodyBytes;
//    print(bytes.length);
    String tempDir = await getDatabasesPath();
    String pathMetadata = join(tempDir + "/metadata.db");
//    print(pathMetadata);
    print("I am writing the database and checking whether it exists");
    await File(pathMetadata).writeAsBytes(bytes, flush: true);
    print(await databaseExists(pathD));
    print("Check complete");
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
