import 'dart:convert';

import 'package:calibre_carte/library/library.dart';
import 'package:calibre_carte/library/library_helper.dart';
import 'package:calibre_carte/library/library_storage.dart';
import 'package:calibre_carte/oauth/oauth2_helper.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class DropboxLibraryHelper implements LibraryHelper {

  static const String key = 'dropbox';

  static const String searchUrl = 'https://api.dropboxapi.com/2/files/search_v2';

  static const String downloadUrl = '';

  OAuth2Helper oauth2Helper;

  DropboxLibraryHelper({this.oauth2Helper})

//  @override
//  Future<String> downloadMetadata() {
//    // TODO: implement downloadMetadata
//    throw UnimplementedError();
//  }
//
//  @override
//  Future<bool> downloadBook() {
//    // TODO: implement downloadBook
//    throw UnimplementedError();
//  }
//
//  @override
//  Future<bool> downloadBookCovers() {
//    // TODO: implement downloadBookCovers
//
//  }

  @override
  Future<List<Library>> searchLibraries() async {
    Map<String, String> pathNameMap = Map();
    List<Library> libList = [];
    http.Response response;
    Map<String, String> headers = {
      "Content-type": "application/json"
    };
    String json =
        '{"query": "metadata.db", "options":{"filename_only":true, "file_extensions":["db"]}}';
    try {
      response =
      await oauth2Helper.post(searchUrl, headers: headers, body: json);
    } catch (e) {
      rethrow;
    }

    Map<String, dynamic> responseJson = jsonDecode(response.body);
    if (responseJson['matches'].length != 0) {
      responseJson['matches'].forEach((element) {
        if (element["metadata"]["metadata"]["name"] ==
            "metadata.db") {
          String libPath =
          element["metadata"]["metadata"]["path_display"];
          libPath = libPath.replaceAll('metadata.db', "");
          List<String> directories = element["metadata"]["metadata"]
          ["path_display"]
              .split('/');
          String libName =
          directories.elementAt(directories.length - 2);
          Library lib = Library(libName + libPath, libName, libPath, 'cloud');
          libList.add(lib);
        }
      });
    }

    return libList;
  }

//  This method should be called after a user has selected that this library should be added
  Future<bool> addLibrary(Library lib) async{
    LibraryCollectionStorage storage = await LibraryCollectionStorage.getInstance(key);
    return storage.addLibrary(lib);
  }

  Future<bool> switchLibrary(Library lib) async{
    LibraryCollectionStorage storage = await LibraryCollectionStorage.getInstance(key);


  }



}