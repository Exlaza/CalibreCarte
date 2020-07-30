import 'dart:convert';

import 'package:calibre_carte/library/library.dart';
import 'package:calibre_carte/oauth/normal_storage.dart';
import 'package:calibre_carte/oauth/storage.dart';


class LibraryCollectionStorage {
  String key;

  NormalStorage storage;

  static Future<LibraryCollectionStorage> getInstance(key) async{
    NormalStorage storage = await NormalStorage.getInstance();
    return LibraryCollectionStorage._(key, storage);
  }

  LibraryCollectionStorage._(this.key, this.storage);

  Future<bool> addLibrary(Library lib) async{
    Map<String, dynamic> libMap = lib.toMap();
    return storage.write(key, jsonEncode(libMap));
  }

  Future<bool> addLibraryCollection

  Future<Library> getLibrary() async{
    Map<String, dynamic> libMap = jsonDecode(await storage.read(key));
    Library lib = Library.fromMap(libMap);
    return lib;
  }




}