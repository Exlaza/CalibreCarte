import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'dart:io';

class BookDownloader {
  Future<String> getTokenFromPreferences() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('token') ??
        "iWMa931y4c4AAAAAAAABG9VeRCMOkBy80ElDs2_2ETwTOf8zgbiIbP2LoZZCe9bY";
  }

  Future<String> getSelectedLibPathFromSharedPrefs() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('selected_calibre_lib_path') ?? '/Calibre Library/';
  }

  Future<bool> checkIfDownloadedFileExists(fileName) async {
    String pathMetadata = await returnFileDirectoryExternal(fileName);
    return await File(pathMetadata).exists();
  }

  checkAndDeleteIfDownloadedFilesExists(fileName) async {
    bool exists = await checkIfDownloadedFileExists(fileName);
    if (exists) {
      String pathMetadata = await returnFileDirectoryExternal(fileName);
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

  Future<String> returnFileDirectoryExternal(fileName) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String dd = sp.getString("downloaded_directory");
    String pathMetadata = join(dd + "/$fileName");
    print(pathMetadata);
    return pathMetadata;
  }
}
