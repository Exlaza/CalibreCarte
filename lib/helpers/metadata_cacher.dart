import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'dart:io';

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
    print("I should also have come here after logging in");
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
    String token = await getTokenFromPreferences();
    String path = await getSelectedLibPathFromSharedPrefs();
    String absPath = path + 'metadata.db';
    print(absPath);
    Response response = await downloadMetadata(token, absPath);
    //Get the bytes, get the temp directory and write a file in temp
    print(response.statusCode);
    List<int> bytes = response.bodyBytes;
    Directory tempDir = await getTemporaryDirectory();
    String pathMetadata = join(tempDir.path + "metadata.db");
    await File(pathMetadata).writeAsBytes(bytes, flush: true);
  }

  Future<bool> checkIfCachedFileExists() async {
    Directory tempDir = await getTemporaryDirectory();
    String pathMetadata = join(tempDir.path + "metadata.db");
    return await File(pathMetadata).exists();
  }
}
