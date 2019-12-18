import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'dart:io';

class ImageCacher {
  Future<String> getTokenFromPreferences() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('token');
  }

  Future<String> getSelectedLibPathFromSharedPrefs() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('selected_calibre_lib_path');
  }

  downloadCoverImage(token, path) async {
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

  downloadThumbnailImage(token, path) async {
//    print("I am in th donlaod thumbanial image method");
//    print(token);
    String url = "https://content.dropboxapi.com/2/files/get_thumbnail";
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

  Future<bool> downloadAndCacheImage(relativePath, bookID) async {
//    print("I am in the download image method");
    String token = await getTokenFromPreferences();
//    print(token);
    String basePath = await getSelectedLibPathFromSharedPrefs();
    String absPath = basePath + relativePath + '/cover.jpg';
//    print(absPath);
    Response response = await downloadCoverImage(token, absPath);
    //Get the bytes, get the temp directory and write a file in temp
    if (response.statusCode != 200) {
//      print(response.statusCode);
      return false;
    }
    List<int> bytes = response.bodyBytes;
    Directory tempDir = await getTemporaryDirectory();
    String pathMetadata = join(tempDir.path + "/cover_$bookID.jpg");
    await File(pathMetadata).writeAsBytes(bytes, flush: true);
    return true;
  }

  Future<void> downloadAndCacheImageThumbnail(relativePath, bookID) async {
    String token = await getTokenFromPreferences();
    String basePath = await getSelectedLibPathFromSharedPrefs();
    String absPath = basePath + relativePath + '/cover.jpg';
    Response response = await downloadThumbnailImage(token, absPath);
    //Get the bytes, get the temp directory and write a file in temp
    List<int> bytes = response.bodyBytes;
    Directory tempDir = await getTemporaryDirectory();
    String pathMetadata = join(tempDir.path + "/thumbnail_$bookID.jpg");
    await File(pathMetadata).writeAsBytes(bytes, flush: true);
  }

  Future<bool> checkIfCachedFileExists(bookID) async {
    Directory tempDir = await getTemporaryDirectory();
    String pathMetadata = join(tempDir.path + "/cover_$bookID.jpg");
    return await File(pathMetadata).exists();
  }

  Future<bool> checkIfCachedThumbnailExists(bookID) async {
    Directory tempDir = await getTemporaryDirectory();
    String pathMetadata = join(tempDir.path + "/thumbnail_$bookID.jpg");
    return await File(pathMetadata).exists();
  }

  Future<String> returnCachedImagePath(bookID) async {
    Directory tempDir = await getTemporaryDirectory();
    String pathMetadata = join(tempDir.path + "/cover_$bookID.jpg");
    return pathMetadata;
  }

  Future<String> returnCachedThumbnailPath(bookID) async {
    Directory tempDir = await getTemporaryDirectory();
    String pathMetadata = join(tempDir.path + "/thumbnail_$bookID.jpg");
    return pathMetadata;
  }
}
