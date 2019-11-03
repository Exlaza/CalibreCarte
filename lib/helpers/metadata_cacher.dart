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
    return sp.getString('token') ??
        "iWMa931y4c4AAAAAAAABG9VeRCMOkBy80ElDs2_2ETwTOf8zgbiIbP2LoZZCe9bY";
  }

  Future<String> getSelectedLibPathFromSharedPrefs() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('selected_calibre_lib_path') ??
        '/Calibre Library/metadata.db';
  }

  downloadMetadata(token, path) async {
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
    Response response = await downloadMetadata(token, path);
    //Get the bytes, get the temp directory and write a file in temp
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
