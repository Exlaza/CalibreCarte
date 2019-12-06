import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'dart:io';

class BookDownloader{
  Future<String> getTokenFromPreferences() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('token') ??
        "iWMa931y4c4AAAAAAAABG9VeRCMOkBy80ElDs2_2ETwTOf8zgbiIbP2LoZZCe9bY";
  }

  Future<String> getSelectedLibPathFromSharedPrefs() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('selected_calibre_lib_path') ??
        '/Calibre Library/';
  }

  downloadFile(token, path) async {
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

  Future<void> downloadAndStoreFile(relativePath, bookID, fileName) async {
    String token = await getTokenFromPreferences();
    String basePath = await getSelectedLibPathFromSharedPrefs();
//    print(basePath);
//    print(relativePath);
//    print(fileName);
    String absPath = basePath + relativePath + '/' + fileName;
    Response response = await downloadFile(token, absPath);
    //Get the bytes, get the temp directory and write a file in temp
    List<int> bytes = response.bodyBytes;
    Directory tempDir = await getApplicationDocumentsDirectory();
    String pathMetadata = join(tempDir.path + "/$fileName");
    await File(pathMetadata).writeAsBytes(bytes, flush: true);
  }

  Future<bool> checkIfDownloadedFileExists(fileName) async {
    Directory tempDir = await getApplicationDocumentsDirectory();
    String pathMetadata = join(tempDir.path + "/$fileName");
    return await File(pathMetadata).exists();
  }

  checkAndDeleteIfDownloadedFilesExists(fileName) async {
    bool exists = await checkIfDownloadedFileExists(fileName);
    if (exists) {
      String pathMetadata = await returnFileDirectory(fileName);
      await File(pathMetadata).delete();
      return true;
    }
    return false;

  }

  Future<String> returnFileDirectory(fileName) async {
    Directory tempDir = await getApplicationDocumentsDirectory();
    String pathMetadata = join(tempDir.path + "/$fileName");
    return pathMetadata;
  }
}